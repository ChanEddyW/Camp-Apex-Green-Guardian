// https://campapex.org/course/GreenGuardian
trigger PlantTrigger on CAMPX__Plant__c (before insert, before update, after insert, after update, after delete) {
    PlantTriggerHandler plantTriggerHandler = new PlantTriggerHandler();

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            // https://campapex.org/lesson/657c84c3cb4798858351bb48 (Initialize Plant Fields)
            plantTriggerHandler.initializeField(Trigger.new);

            // https://campapex.org/lesson/657c788fcb4798858351bb44 (Data Integrity - Closed Gardens)
            plantTriggerHandler.validateClosedGarden(Trigger.new);
        }

        when BEFORE_UPDATE {
            // https://campapex.org/lesson/657c788fcb4798858351bb44 (Data Integrity - Closed Gardens)
            plantTriggerHandler.validateClosedGarden(Trigger.new);
        }

        when AFTER_INSERT {
            // https://campapex.org/lesson/657b750acb4798858351bb3a (Aggregate the Total Plant Count)
            plantTriggerHandler.aggregateTotalPlantCount_Insert(Trigger.new);

            // https://campapex.org/lesson/657b7968cb4798858351bb3d (Aggregate Unhealthy Plant Count)
            plantTriggerHandler.aggregateUnhealthyPlantCount_Insert(Trigger.new);
        }

        when AFTER_UPDATE {
            // https://campapex.org/lesson/657b750acb4798858351bb3a (Aggregate the Total Plant Count)
            plantTriggerHandler.aggregateTotalPlantCount_Update(Trigger.oldMap, Trigger.new);

            // https://campapex.org/lesson/657b7968cb4798858351bb3d (Aggregate Unhealthy Plant Count)
            plantTriggerHandler.aggregateUnhealthyPlantCount_Update(Trigger.oldMap, Trigger.new);
        }

        when AFTER_DELETE {
            // https://campapex.org/lesson/657b750acb4798858351bb3a (Aggregate the Total Plant Count)
            plantTriggerHandler.aggregateTotalPlantCount_Delete(Trigger.old);

            // https://campapex.org/lesson/657b7968cb4798858351bb3d (Aggregate Unhealthy Plant Count)
            plantTriggerHandler.aggregateUnhealthyPlantCount_Delete(Trigger.old);
        }
    }
}