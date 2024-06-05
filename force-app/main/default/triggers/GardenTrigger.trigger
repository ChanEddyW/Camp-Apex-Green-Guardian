// https://campapex.org/course/GreenGuardian
trigger GardenTrigger on CAMPX__Garden__c (before insert, after insert, before update, after update) {
    GardenTriggerHandler gardenTriggerHandler = new GardenTriggerHandler();

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            // https://campapex.org/lesson/6571bd7f941d307edf62f86b (Initialize Garden Fields Upon Record Creation)
            // https://campapex.org/lesson/6572365bd5dbbae2aacac1a5 (Initialize Garden Fields Upon Record Creation (Sometimes))
            gardenTriggerHandler.initializeField(Trigger.new);

            // https://campapex.org/lesson/657afc47cb4798858351bb34 (Set Manager Start Date)
            gardenTriggerHandler.setMgrStartDate(Trigger.new);

            // https://campapex.org/lesson/657b763dcb4798858351bb3b (Calculate Capacity)
            gardenTriggerHandler.calculateCapacity_Insert(Trigger.new);

            // https://campapex.org/lesson/657c4f15cb4798858351bb40 (Calculate the Health Index)
            gardenTriggerHandler.calculateHealthIndex_Insert(Trigger.new);

            // https://campapex.org/lesson/657c529ecb4798858351bb41 (Set Garden's Status)
            gardenTriggerHandler.setGardenStatus(Trigger.new);

            // https://campapex.org/lesson/657c7808cb4798858351bb42 (Data Integrity - Negative Values)
            gardenTriggerHandler.validateNegativeValue(Trigger.new);

            // https://campapex.org/lesson/6580a9fbcb4798858351bb67 (Data Integrity - Blank Values)
            gardenTriggerHandler.validateBlankValue(Trigger.new);

            // https://campapex.org/lesson/657c7846cb4798858351bb43 (Data Integrity - Within Range)
            gardenTriggerHandler.validateWithinRange(Trigger.new);
        }

        when AFTER_INSERT {
            // https://campapex.org/lesson/6572949bd5dbbae2aacac1ab (Create a Task for New Gardening Managers - Part 1)
            gardenTriggerHandler.generateTask_Insert(Trigger.new);
        }

        when BEFORE_UPDATE {
            // https://campapex.org/lesson/657afc47cb4798858351bb34 (Set Manager Start Date)
            gardenTriggerHandler.setMgrStartDate(Trigger.new);

            // https://campapex.org/lesson/657b763dcb4798858351bb3b (Calculate Capacity)
            gardenTriggerHandler.calculateCapacity_Update(Trigger.oldMap, Trigger.new);

            // https://campapex.org/lesson/657c4f15cb4798858351bb40 (Calculate the Health Index)
            gardenTriggerHandler.calculateHealthIndex_Update(Trigger.oldMap, Trigger.new);

            // https://campapex.org/lesson/657c529ecb4798858351bb41 (Set Garden's Status)
            gardenTriggerHandler.setGardenStatus(Trigger.new);

            // https://campapex.org/lesson/657c7808cb4798858351bb42 (Data Integrity - Negative Values)
            gardenTriggerHandler.validateNegativeValue(Trigger.new);

            // https://campapex.org/lesson/6580a9fbcb4798858351bb67 (Data Integrity - Blank Values)
            gardenTriggerHandler.validateBlankValue(Trigger.new);

            // https://campapex.org/lesson/657c7846cb4798858351bb43 (Data Integrity - Within Range)
            gardenTriggerHandler.validateWithinRange(Trigger.new);
        }

        when AFTER_UPDATE {
            // https://campapex.org/lesson/6578de40cb4798858351bb2b (Create a Task for New Gardening Managers - Part 2)
            gardenTriggerHandler.generateTask_Update(Trigger.oldMap, Trigger.new);

            // https://campapex.org/lesson/6578753bcb4798858351bb22 (Reassign a Task)
            gardenTriggerHandler.reassignTask(Trigger.oldMap, Trigger.new);

            // https://campapex.org/lesson/657af897cb4798858351bb33 (Delete a Task)
            gardenTriggerHandler.deleteTaskOpenUnassigned(Trigger.oldMap, Trigger.new);
        }
    }
}