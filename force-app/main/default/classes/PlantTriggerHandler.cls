// https://campapex.org/course/GreenGuardian
public with sharing class PlantTriggerHandler {
    // https://campapex.org/lesson/657c84c3cb4798858351bb48 (Initialize Plant Fields)
    public void initializeField(List<CAMPX__Plant__c> triggerDotNew) {
        Set<Id> gardenIds = new Set<Id>();

        for (CAMPX__Plant__c newPlant : triggerDotNew) {
            if (newPlant.CAMPX__Soil_Type__c == null) {
                newPlant.CAMPX__Soil_Type__c = 'All Purpose Potting Soil';
            }

            if (newPlant.CAMPX__Water__c == null) {
                newPlant.CAMPX__Water__c = 'Once Weekly';
            }

            gardenIds.add(newPlant.CAMPX__Garden__c);
        }

        Map<Id, CAMPX__Garden__c> gardensById = new Map<Id, CAMPX__Garden__c>([
            SELECT 
                Id, 
                CAMPX__Sun_Exposure__c 
            FROM CAMPX__Garden__c 
            WHERE Id IN :gardenIds 
                AND CAMPX__Sun_Exposure__c != null 
            WITH USER_MODE
        ]);

        for (CAMPX__Plant__c newPlant : triggerDotNew) {
            if (newPlant.CAMPX__Sunlight__c != null) {
                continue;
            }

            if (gardensById.containsKey(newPlant.CAMPX__Garden__c)) {
                newPlant.CAMPX__Sunlight__c = gardensById.get(newPlant.CAMPX__Garden__c).CAMPX__Sun_Exposure__c;
            } else {
                newPlant.CAMPX__Sunlight__c = 'Partial Sun';
            }
        }
    }

    // https://campapex.org/lesson/657b750acb4798858351bb3a (Aggregate the Total Plant Count)
    public void aggregateTotalPlantCount_Insert(List<CAMPX__Plant__c> triggerDotNew) {
        Map<Id, Integer> plantCountByGardenId = new Map<Id, Integer>();

        for (CAMPX__Plant__c newPlant : triggerDotNew) {
            if (newPlant.CAMPX__Garden__c != null) {
                if (plantCountByGardenId.containsKey(newPlant.CAMPX__Garden__c)) {
                    Integer plantCount = plantCountByGardenId.get(newPlant.CAMPX__Garden__c);

                    plantCountByGardenId.put(newPlant.CAMPX__Garden__c, plantCount + 1);
                } else {
                    plantCountByGardenId.put(newPlant.CAMPX__Garden__c, 1);
                }
            }
        }

        List<CAMPX__Garden__c> gardensToUpdate = [
            SELECT 
                Id, 
                CAMPX__Total_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Id IN :plantCountByGardenId.keySet() 
            WITH USER_MODE
        ];

        for (CAMPX__Garden__c gardenToUpdate : gardensToUpdate) {
            Integer plantCount = plantCountByGardenId.get(gardenToUpdate.Id);

            gardenToUpdate.CAMPX__Total_Plant_Count__c += plantCount;
        }

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardensToUpdate;
        }
    }

    // https://campapex.org/lesson/657b750acb4798858351bb3a (Aggregate the Total Plant Count)
    public void aggregateTotalPlantCount_Update(Map<Id, CAMPX__Plant__c> triggerDotOldMap, List<CAMPX__Plant__c> triggerDotNew) {
        Map<Id, Integer> plantCountByGardenId = new Map<Id, Integer>();

        for (CAMPX__Plant__c newPlant : triggerDotNew) {
            if (
                triggerDotOldMap.get(newPlant.Id).CAMPX__Garden__c != newPlant.CAMPX__Garden__c 
                && newPlant.CAMPX__Garden__c != null
            ) {
                if (plantCountByGardenId.containsKey(newPlant.CAMPX__Garden__c)) {
                    Integer plantCount = plantCountByGardenId.get(newPlant.CAMPX__Garden__c);

                    plantCountByGardenId.put(newPlant.CAMPX__Garden__c, plantCount + 1);
                } else {
                    plantCountByGardenId.put(newPlant.CAMPX__Garden__c, 1);
                }
            }

            if (
                triggerDotOldMap.get(newPlant.Id).CAMPX__Garden__c != null 
                && triggerDotOldMap.get(newPlant.Id).CAMPX__Garden__c != newPlant.CAMPX__Garden__c
            ) {
                if (plantCountByGardenId.containsKey(triggerDotOldMap.get(newPlant.Id).CAMPX__Garden__c)) {
                    Integer plantCount = plantCountByGardenId.get(triggerDotOldMap.get(newPlant.Id).CAMPX__Garden__c);

                    plantCountByGardenId.put(triggerDotOldMap.get(newPlant.Id).CAMPX__Garden__c, plantCount - 1);
                } else {
                    plantCountByGardenId.put(triggerDotOldMap.get(newPlant.Id).CAMPX__Garden__c, -1);
                }
            }
        }

        List<CAMPX__Garden__c> gardensToUpdate = [
            SELECT 
                Id, 
                CAMPX__Total_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Id IN :plantCountByGardenId.keySet() 
            WITH USER_MODE
        ];

        for (CAMPX__Garden__c gardenToUpdate : gardensToUpdate) {
            Integer plantCount = plantCountByGardenId.get(gardenToUpdate.Id);

            gardenToUpdate.CAMPX__Total_Plant_Count__c += plantCount;
        }

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardensToUpdate;
        }
    }

    // https://campapex.org/lesson/657b750acb4798858351bb3a (Aggregate the Total Plant Count)
    public void aggregateTotalPlantCount_Delete(List<CAMPX__Plant__c> triggerDotOld) {
        Map<Id, Integer> plantCountByGardenId = new Map<Id, Integer>();

        for (CAMPX__Plant__c oldPlant : triggerDotOld) {
            if (oldPlant.CAMPX__Garden__c != null) {
                if (plantCountByGardenId.containsKey(oldPlant.CAMPX__Garden__c)) {
                    Integer plantCount = plantCountByGardenId.get(oldPlant.CAMPX__Garden__c);

                    plantCountByGardenId.put(oldPlant.CAMPX__Garden__c, plantCount - 1);
                } else {
                    plantCountByGardenId.put(oldPlant.CAMPX__Garden__c, -1);
                }
            }
        }

        List<CAMPX__Garden__c> gardensToUpdate = [
            SELECT 
                Id, 
                CAMPX__Total_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Id IN :plantCountByGardenId.keySet() 
            WITH USER_MODE
        ];

        for (CAMPX__Garden__c gardenToUpdate : gardensToUpdate) {
            Integer plantCount = plantCountByGardenId.get(gardenToUpdate.Id);

            gardenToUpdate.CAMPX__Total_Plant_Count__c += plantCount;
        }

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardensToUpdate;
        }
    }

    // https://campapex.org/lesson/657b7968cb4798858351bb3d (Aggregate Unhealthy Plant Count)
    public void aggregateUnhealthyPlantCount_Insert(List<CAMPX__Plant__c> triggerDotNew) {
        Map<Id, Integer> plantCountByGardenId = new Map<Id, Integer>();

        for (CAMPX__Plant__c newPlant : triggerDotNew) {
            if (
                newPlant.CAMPX__Garden__c != null 
                && newPlant.CAMPX__Status__c != null 
                && newPlant.CAMPX__Status__c != 'Healthy'
            ) {
                if (plantCountByGardenId.containsKey(newPlant.CAMPX__Garden__c)) {
                    Integer plantCount = plantCountByGardenId.get(newPlant.CAMPX__Garden__c);

                    plantCountByGardenId.put(newPlant.CAMPX__Garden__c, plantCount + 1);
                } else {
                    plantCountByGardenId.put(newPlant.CAMPX__Garden__c, 1);
                }
            }
        }

        List<CAMPX__Garden__c> gardensToUpdate = [
            SELECT 
                Id, 
                CAMPX__Total_Unhealthy_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Id IN :plantCountByGardenId.keySet() 
            WITH USER_MODE
        ];

        for (CAMPX__Garden__c gardenToUpdate : gardensToUpdate) {
            Integer plantCount = plantCountByGardenId.get(gardenToUpdate.Id);

            gardenToUpdate.CAMPX__Total_Unhealthy_Plant_Count__c += plantCount;
        }

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardensToUpdate;
        }
    }

    // https://campapex.org/lesson/657b7968cb4798858351bb3d (Aggregate Unhealthy Plant Count)
    public void aggregateUnhealthyPlantCount_Update(Map<Id, CAMPX__Plant__c> triggerDotOldMap, List<CAMPX__Plant__c> triggerDotNew) {
        Map<Id, Integer> plantCountByGardenId = new Map<Id, Integer>();

        for (CAMPX__Plant__c newPlant : triggerDotNew) {
            if (
                triggerDotOldMap.get(newPlant.Id).CAMPX__Garden__c == newPlant.CAMPX__Garden__c 
                && newPlant.CAMPX__Garden__c != null 
                && triggerDotOldMap.get(newPlant.Id).CAMPX__Status__c == 'Healthy' 
                && newPlant.CAMPX__Status__c != null 
                && newPlant.CAMPX__Status__c != 'Healthy'
            ) {
                if (plantCountByGardenId.containsKey(newPlant.CAMPX__Garden__c)) {
                    Integer plantCount = plantCountByGardenId.get(newPlant.CAMPX__Garden__c);

                    plantCountByGardenId.put(newPlant.CAMPX__Garden__c, plantCount + 1);
                } else {
                    plantCountByGardenId.put(newPlant.CAMPX__Garden__c, 1);
                }
            }

            if (
                triggerDotOldMap.get(newPlant.Id).CAMPX__Garden__c == newPlant.CAMPX__Garden__c 
                && newPlant.CAMPX__Garden__c != null 
                && triggerDotOldMap.get(newPlant.Id).CAMPX__Status__c != 'Healthy' 
                && newPlant.CAMPX__Status__c == 'Healthy'
            ) {
                if (plantCountByGardenId.containsKey(newPlant.CAMPX__Garden__c)) {
                    Integer plantCount = plantCountByGardenId.get(newPlant.CAMPX__Garden__c);

                    plantCountByGardenId.put(newPlant.CAMPX__Garden__c, plantCount - 1);
                } else {
                    plantCountByGardenId.put(newPlant.CAMPX__Garden__c, -1);
                }
            }
        }

        List<CAMPX__Garden__c> gardensToUpdate = [
            SELECT 
                Id, 
                CAMPX__Total_Unhealthy_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Id IN :plantCountByGardenId.keySet() 
            WITH USER_MODE
        ];

        for (CAMPX__Garden__c gardenToUpdate : gardensToUpdate) {
            Integer plantCount = plantCountByGardenId.get(gardenToUpdate.Id);

            gardenToUpdate.CAMPX__Total_Unhealthy_Plant_Count__c += plantCount;
        }

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardensToUpdate;
        }
    }

    // https://campapex.org/lesson/657b7968cb4798858351bb3d (Aggregate Unhealthy Plant Count)
    public void aggregateUnhealthyPlantCount_Delete(List<CAMPX__Plant__c> triggerDotOld) {
        Map<Id, Integer> plantCountByGardenId = new Map<Id, Integer>();

        for (CAMPX__Plant__c oldPlant : triggerDotOld) {
            if (
                oldPlant.CAMPX__Garden__c != null 
                && oldPlant.CAMPX__Status__c != null 
                && oldPlant.CAMPX__Status__c != 'Healthy'
            ) {
                if (plantCountByGardenId.containsKey(oldPlant.CAMPX__Garden__c)) {
                    Integer plantCount = plantCountByGardenId.get(oldPlant.CAMPX__Garden__c);

                    plantCountByGardenId.put(oldPlant.CAMPX__Garden__c, plantCount - 1);
                } else {
                    plantCountByGardenId.put(oldPlant.CAMPX__Garden__c, -1);
                }
            }
        }

        List<CAMPX__Garden__c> gardensToUpdate = [
            SELECT 
                Id, 
                CAMPX__Total_Unhealthy_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Id IN :plantCountByGardenId.keySet() 
            WITH USER_MODE
        ];

        for (CAMPX__Garden__c gardenToUpdate : gardensToUpdate) {
            Integer plantCount = plantCountByGardenId.get(gardenToUpdate.Id);

            gardenToUpdate.CAMPX__Total_Unhealthy_Plant_Count__c += plantCount;
        }

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardensToUpdate;
        }
    }

    // https://campapex.org/lesson/657c788fcb4798858351bb44 (Data Integrity - Closed Gardens)
    public void validateClosedGarden(List<CAMPX__Plant__c> triggerDotNew) {
        Set<Id> gardenIds = new Set<Id>();

        for (CAMPX__Plant__c newPlant : triggerDotNew) {
            gardenIds.add(newPlant.CAMPX__Garden__c);
        }

        final String PERMANENT_CLOSURE = 'Permanent Closure';

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT 
                Id, 
                CAMPX__Status__c 
            FROM CAMPX__Garden__c 
            WHERE Id IN :gardenIds 
                AND CAMPX__Status__c = :PERMANENT_CLOSURE 
            WITH USER_MODE
        ];

        Map<Id, CAMPX__Garden__c> gardensById = new Map<Id, CAMPX__Garden__c>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            gardensById.put(retrievedGarden.Id, retrievedGarden);
        }

        for (CAMPX__Plant__c newPlant : triggerDotNew) {
            if (gardensById.containsKey(newPlant.CAMPX__Garden__c)) {
                newPlant.addError('The garden selected for this plant is permanently closed. Please select a different garden.');
            }
        }
    }
}