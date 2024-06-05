// https://campapex.org/course/GreenGuardian
public with sharing class GardenTriggerHandler {
    private final String ACQUIRE_PLANTS = 'Acquire Plants';
    private final String COMPLETED = 'Completed';

    // https://campapex.org/lesson/6571bd7f941d307edf62f86b (Initialize Garden Fields Upon Record Creation)
    // https://campapex.org/lesson/6572365bd5dbbae2aacac1a5 (Initialize Garden Fields Upon Record Creation (Sometimes))
    public void initializeField(List<CAMPX__Garden__c> triggerDotNew) {
        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (newGarden.CAMPX__Max_Plant_Count__c == null) {
                newGarden.CAMPX__Max_Plant_Count__c = 100;
            }

            if (newGarden.CAMPX__Minimum_Plant_Count__c == null) {
                newGarden.CAMPX__Minimum_Plant_Count__c = 1;
            }

            if (newGarden.CAMPX__Total_Plant_Count__c == null) {
                newGarden.CAMPX__Total_Plant_Count__c = 0;
            }

            if (newGarden.CAMPX__Total_Unhealthy_Plant_Count__c == null) {
                newGarden.CAMPX__Total_Unhealthy_Plant_Count__c = 0;
            }
        }
    }

    // https://campapex.org/lesson/6572949bd5dbbae2aacac1ab (Create a Task for New Gardening Managers - Part 1)
    public void generateTask_Insert(List<CAMPX__Garden__c> triggerDotNew) {
        List<Task> tsksToInsert = new List<Task>();

        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (newGarden.CAMPX__Manager__c != null) {
                Task tskToInsert = new Task(
                    Subject = 'Acquire Plants', 
                    WhatId = newGarden.Id, 
                    OwnerId = newGarden.CAMPX__Manager__c
                );

                tsksToInsert.add(tskToInsert);
            }
        }

        if (Schema.sObjectType.Task.isCreateable()) {
            insert as user tsksToInsert;
        }
    }

    // https://campapex.org/lesson/6578de40cb4798858351bb2b (Create a Task for New Gardening Managers - Part 2)
    public void generateTask_Update(Map<Id, CAMPX__Garden__c> triggerDotOldMap, List<CAMPX__Garden__c> triggerDotNew) {
        List<Task> tsksToInsert = new List<Task>();

        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (triggerDotOldMap.get(newGarden.Id).CAMPX__Manager__c == null && newGarden.CAMPX__Manager__c != null) {
                Task tskToInsert = new Task(
                    Subject = 'Acquire Plants', 
                    WhatId = newGarden.Id, 
                    OwnerId = newGarden.CAMPX__Manager__c
                );

                tsksToInsert.add(tskToInsert);
            }
        }

        if (Schema.sObjectType.Task.isCreateable()) {
            insert as user tsksToInsert;
        }
    }

    // https://campapex.org/lesson/6578753bcb4798858351bb22 (Reassign a Task)
    public void reassignTask(Map<Id, CAMPX__Garden__c> triggerDotOldMap, List<CAMPX__Garden__c> triggerDotNew) {
        List<Task> tsksToUpdate = new List<Task>();

        List<Task> retrievedTsks = [
            SELECT 
                Subject, 
                Status, 
                WhatId, 
                OwnerId 
            FROM Task 
            WHERE Subject = :ACQUIRE_PLANTS 
                AND Status != :COMPLETED 
                AND WhatId IN :triggerDotNew 
            WITH USER_MODE
        ];

        Map<Id, Task> tsksByWhatId = new Map<Id, Task>();

        for (Task retrievedTsk : retrievedTsks) {
            tsksByWhatId.put(retrievedTsk.WhatId, retrievedTsk);
        }

        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (
                triggerDotOldMap.get(newGarden.Id).CAMPX__Manager__c != null 
                && newGarden.CAMPX__Manager__c != null 
                && triggerDotOldMap.get(newGarden.Id).CAMPX__Manager__c != newGarden.CAMPX__Manager__c
            ) {
                if (tsksByWhatId.containsKey(newGarden.Id)) {
                    Task tskToUpdate = tsksByWhatId.get(newGarden.Id);

                    tskToUpdate.OwnerId = newGarden.CAMPX__Manager__c;

                    tsksToUpdate.add(tskToUpdate);
                }
            }
        }

        if (Schema.sObjectType.Task.isUpdateable()) {
            update as user tsksToUpdate;
        }
    }

    // https://campapex.org/lesson/657af897cb4798858351bb33 (Delete a Task)
    public void deleteTaskOpenUnassigned(Map<Id, CAMPX__Garden__c> triggerDotOldMap, List<CAMPX__Garden__c> triggerDotNew) {
        List<Task> tsksToDelete = new List<Task>();

        List<Task> retrievedTsks = [
            SELECT 
                Id, 
                Subject, 
                Status, 
                WhatId, 
                OwnerId 
            FROM Task 
            WHERE Subject = :ACQUIRE_PLANTS 
                AND Status != :COMPLETED 
                AND WhatId IN :triggerDotNew 
            WITH USER_MODE
        ];

        Map<Id, Task> tsksByWhatId = new Map<Id, Task>();

        for (Task retrievedTsk : retrievedTsks) {
            tsksByWhatId.put(retrievedTsk.WhatId, retrievedTsk);
        }

        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (triggerDotOldMap.get(newGarden.Id).CAMPX__Manager__c != null && newGarden.CAMPX__Manager__c == null) {
                if (tsksByWhatId.containsKey(newGarden.Id)) {
                    Task tskToDelete = tsksByWhatId.get(newGarden.Id);

                    tsksToDelete.add(tskToDelete);
                }
            }
        }

        if (Schema.sObjectType.Task.isDeletable()) {
            delete as user tsksToDelete;
        }
    }

    // https://campapex.org/lesson/657afc47cb4798858351bb34 (Set Manager Start Date)
    public void setMgrStartDate(List<CAMPX__Garden__c> triggerDotNew) {
        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (newGarden.CAMPX__Manager__c == null) {
                newGarden.CAMPX__Manager_Start_Date__c = null;
            } else {
                newGarden.CAMPX__Manager_Start_Date__c = Date.today();
            }
        }
    }

    // https://campapex.org/lesson/657b763dcb4798858351bb3b (Calculate Capacity)
    public void calculateCapacity_Insert(List<CAMPX__Garden__c> triggerDotNew) {
        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (
                newGarden.CAMPX__Max_Plant_Count__c == null 
                || newGarden.CAMPX__Max_Plant_Count__c == 0 
                || newGarden.CAMPX__Total_Plant_Count__c == null 
                || newGarden.CAMPX__Total_Plant_Count__c == 0
            ) {
                newGarden.CAMPX__Capacity__c = 0;
            } else {
                newGarden.CAMPX__Capacity__c = (newGarden.CAMPX__Total_Plant_Count__c / newGarden.CAMPX__Max_Plant_Count__c) * 100;
            }
        }
    }

    // https://campapex.org/lesson/657b763dcb4798858351bb3b (Calculate Capacity)
    public void calculateCapacity_Update(Map<Id, CAMPX__Garden__c> triggerDotOldMap, List<CAMPX__Garden__c> triggerDotNew) {
        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (
                triggerDotOldMap.get(newGarden.Id).CAMPX__Max_Plant_Count__c != newGarden.CAMPX__Max_Plant_Count__c 
                || triggerDotOldMap.get(newGarden.Id).CAMPX__Total_Plant_Count__c != newGarden.CAMPX__Total_Plant_Count__c
            ) {
                if (
                    newGarden.CAMPX__Max_Plant_Count__c == null 
                    || newGarden.CAMPX__Max_Plant_Count__c == 0 
                    || newGarden.CAMPX__Total_Plant_Count__c == null 
                    || newGarden.CAMPX__Total_Plant_Count__c == 0
                ) {
                    newGarden.CAMPX__Capacity__c = 0;
                } else {
                    newGarden.CAMPX__Capacity__c = (newGarden.CAMPX__Total_Plant_Count__c / newGarden.CAMPX__Max_Plant_Count__c) * 100;
                }
            }
        }
    }

    // https://campapex.org/lesson/657c4f15cb4798858351bb40 (Calculate the Health Index)
    public void calculateHealthIndex_Insert(List<CAMPX__Garden__c> triggerDotNew) {
        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (newGarden.CAMPX__Total_Plant_Count__c == null || newGarden.CAMPX__Total_Plant_Count__c == 0) {
                newGarden.CAMPX__Health_Index__c = 0;
            } else {
                newGarden.CAMPX__Health_Index__c = 
                    (
                        (
                            newGarden.CAMPX__Total_Plant_Count__c - newGarden.CAMPX__Total_Unhealthy_Plant_Count__c
                        ) / newGarden.CAMPX__Total_Plant_Count__c
                    ) * 100;
            }
        }
    }

    // https://campapex.org/lesson/657c4f15cb4798858351bb40 (Calculate the Health Index)
    public void calculateHealthIndex_Update(Map<Id, CAMPX__Garden__c> triggerDotOldMap, List<CAMPX__Garden__c> triggerDotNew) {
        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (
                triggerDotOldMap.get(newGarden.Id).CAMPX__Total_Plant_Count__c != newGarden.CAMPX__Total_Plant_Count__c 
                || triggerDotOldMap.get(newGarden.Id).CAMPX__Total_Unhealthy_Plant_Count__c != newGarden.CAMPX__Total_Unhealthy_Plant_Count__c
            ) {
                if (newGarden.CAMPX__Total_Plant_Count__c == null || newGarden.CAMPX__Total_Plant_Count__c == 0) {
                    newGarden.CAMPX__Health_Index__c = 0;
                } else {
                    newGarden.CAMPX__Health_Index__c = 
                        (
                            (
                                newGarden.CAMPX__Total_Plant_Count__c - newGarden.CAMPX__Total_Unhealthy_Plant_Count__c
                            ) / newGarden.CAMPX__Total_Plant_Count__c
                        ) * 100;
                }
            }
        }
    }

    // https://campapex.org/lesson/657c529ecb4798858351bb41 (Set Garden's Status)
    public void setGardenStatus(List<CAMPX__Garden__c> triggerDotNew) {
        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (newGarden.CAMPX__Status__c != 'Permanent Closure') {
                if (
                    newGarden.CAMPX__Minimum_Plant_Count__c < newGarden.CAMPX__Total_Plant_Count__c 
                    && newGarden.CAMPX__Capacity__c >= 70 
                    && newGarden.CAMPX__Capacity__c <= 100 
                    && newGarden.CAMPX__Health_Index__c >= 70
                ) {
                    newGarden.CAMPX__Status__c = 'Operational';
                } else if (newGarden.CAMPX__Capacity__c == 0) {
                    newGarden.CAMPX__Status__c = 'Temporary Closure';
                } else if (newGarden.CAMPX__Capacity__c > 100) {
                    newGarden.CAMPX__Status__c = 'Over Capacity';
                } else if (
                    (newGarden.CAMPX__Capacity__c > 0 && newGarden.CAMPX__Capacity__c < 70) 
                    || newGarden.CAMPX__Health_Index__c < 70
                ) {
                    newGarden.CAMPX__Status__c = 'Awaiting Resources';
                }
            }
        }
    }

    // https://campapex.org/lesson/657c7808cb4798858351bb42 (Data Integrity - Negative Values)
    public void validateNegativeValue(List<CAMPX__Garden__c> triggerDotNew) {
        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (
                newGarden.CAMPX__Max_Plant_Count__c < 0 
                || newGarden.CAMPX__Minimum_Plant_Count__c < 0 
                || newGarden.CAMPX__Total_Plant_Count__c < 0 
                || newGarden.CAMPX__Total_Unhealthy_Plant_Count__c < 0
            ) {
                newGarden.addError('Plant Count fields must be greater than or equal to zero.');
            }
        }
    }

    // https://campapex.org/lesson/6580a9fbcb4798858351bb67 (Data Integrity - Blank Values)
    public void validateBlankValue(List<CAMPX__Garden__c> triggerDotNew) {
        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (newGarden.CAMPX__Total_Plant_Count__c > 0) {
                if (
                    newGarden.CAMPX__Max_Plant_Count__c == null 
                    || newGarden.CAMPX__Minimum_Plant_Count__c == null
                ) {
                    newGarden.addError('Maximum and Minimum Plant Count fields cannot be blank when there are plants in the Garden.');
                }
            }
        }
    }

    // https://campapex.org/lesson/657c7846cb4798858351bb43 (Data Integrity - Within Range)
    public void validateWithinRange(List<CAMPX__Garden__c> triggerDotNew) {
        for (CAMPX__Garden__c newGarden : triggerDotNew) {
            if (newGarden.CAMPX__Minimum_Plant_Count__c > newGarden.CAMPX__Max_Plant_Count__c) {
                newGarden.addError('The Maximum Plant Count must be greater than or equal to the Minimum Plant Count.');
            }
        }
    }
}