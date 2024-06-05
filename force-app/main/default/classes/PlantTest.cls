// https://campapex.org/course/GreenGuardian
@IsTest
private with sharing class PlantTest {
    private static TestDataFactory testDataFactory = new TestDataFactory();

    private static final String GARDEN_ALPHA_PARTIAL_SHADE = 'gardenAlpha_PartialShade';

    @TestSetup
    private static void setup() {
        List<CAMPX__Garden__c> gardensToInsert = testDataFactory.createGardens_setup_PlantTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardensToInsert;
        }

        Id gardenDelta_FullSunId;
        Id gardenEcho_PartialShadeId;
        Id gardenFoxtrot_FullShadeId;
        Id gardenGolfId;
        Id gardenHotelId;

        for (CAMPX__Garden__c gardenToInsert : gardensToInsert) {
            if (gardenToInsert.Name == 'gardenDelta_FullSun') {
                gardenDelta_FullSunId = gardenToInsert.Id;
            } else if (gardenToInsert.Name == 'gardenEcho_PartialShade') {
                gardenEcho_PartialShadeId = gardenToInsert.Id;
            } else if (gardenToInsert.Name == 'gardenFoxtrot_FullShade') {
                gardenFoxtrot_FullShadeId = gardenToInsert.Id;
            } else if (gardenToInsert.Name == 'gardenGolf') {
                gardenGolfId = gardenToInsert.Id;
            } else if (gardenToInsert.Name == 'gardenHotel') {
                gardenHotelId = gardenToInsert.Id;
            }
        }

        List<CAMPX__Plant__c> plantsToInsert = testDataFactory.createPlants_setup(
            gardenDelta_FullSunId, 
            gardenEcho_PartialShadeId, 
            gardenFoxtrot_FullShadeId, 
            gardenGolfId, 
            gardenHotelId
        );

        if (Schema.sObjectType.CAMPX__Plant__c.isCreateable()) {
            insert as user plantsToInsert;
        }
    }

    // https://campapex.org/lesson/657c84c3cb4798858351bb48 (Initialize Plant Fields)
    @IsTest
    private static void initialize_fields() {
        // GIVEN
        Map<String, Id> gardenIdMap = getGardenIdMap();

        Id gardenAlpha_PartialShadeId = gardenIdMap.get('gardenAlpha_PartialShade');

        List<CAMPX__Plant__c> plantsToInsert = testDataFactory.createPlants_initializeField(gardenAlpha_PartialShadeId);

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Plant__c.isCreateable()) {
            insert as user plantsToInsert;
        }

        Test.stopTest();

        // THEN
        final List<String> NAMES = new List<String>{
            'plantZulu_null', 
            'plantYankee_FullSun', 
            'plantXray_PartialShade', 
            'plantWhiskey_FullShade'
        };

        final String ALL_PURPOSE_POTTING_SOIL = 'All Purpose Potting Soil';
        final String ONCE_WEEKLY = 'Once Weekly';

        List<CAMPX__Plant__c> retrievedPlants = [
            SELECT CAMPX__Sunlight__c 
            FROM CAMPX__Plant__c 
            WHERE Name IN :NAMES 
                AND CAMPX__Soil_Type__c = :ALL_PURPOSE_POTTING_SOIL 
                AND CAMPX__Water__c = :ONCE_WEEKLY 
            WITH USER_MODE
        ];

        List<CAMPX__Plant__c> retrievedPlantsFullSun = new List<CAMPX__Plant__c>();
        List<CAMPX__Plant__c> retrievedPlantsPartialSun = new List<CAMPX__Plant__c>();
        List<CAMPX__Plant__c> retrievedPlantsPartialShade = new List<CAMPX__Plant__c>();
        List<CAMPX__Plant__c> retrievedPlantsFullShade = new List<CAMPX__Plant__c>();
        List<CAMPX__Plant__c> retrievedPlantsNull = new List<CAMPX__Plant__c>();

        for (CAMPX__Plant__c retrievedPlant : retrievedPlants) {
            if (retrievedPlant.CAMPX__Sunlight__c == 'Full Sun') {
                retrievedPlantsFullSun.add(retrievedPlant);
            } else if (retrievedPlant.CAMPX__Sunlight__c == 'Partial Sun') {
                retrievedPlantsPartialSun.add(retrievedPlant);
            } else if (retrievedPlant.CAMPX__Sunlight__c == 'Partial Shade') {
                retrievedPlantsPartialShade.add(retrievedPlant);
            } else if (retrievedPlant.CAMPX__Sunlight__c == 'Full Shade') {
                retrievedPlantsFullShade.add(retrievedPlant);
            } else {
                retrievedPlantsNull.add(retrievedPlant);
            }
        }

        System.assertEquals(1, retrievedPlantsFullSun.size(), 'Expect 1 plant to have full sun, all purpose potting soil, and water once weekly');
        System.assertEquals(1, retrievedPlantsPartialSun.size(), 'Expect 1 plant to have partial sun, all purpose potting soil, and water once weekly');
        System.assertEquals(1, retrievedPlantsPartialShade.size(), 'Expect 1 plant to have partial shade, all purpose potting soil, and water once weekly');
        System.assertEquals(1, retrievedPlantsFullShade.size(), 'Expect 1 plant to have full shade, all purpose potting soil, and water once weekly');
        System.assertEquals(0, retrievedPlantsNull.size(), 'Expect 0 plant');
    }

    private static Map<String, Id> getGardenIdMap() {
        final List<String> NAMES = new List<String>{
            'gardenAlpha_PartialShade', 
            'gardenBravo_FullSun', 
            'gardenCharlie_FullShade', 
            'gardenDelta_FullSun', 
            'gardenEcho_PartialShade', 
            'gardenFoxtrot_FullShade', 
            'gardenGolf', 
            'gardenDelta'
        };

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT 
                Id, 
                Name 
            FROM CAMPX__Garden__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        Map<String, Id> gardenIdMap = new Map<String, Id>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            if (retrievedGarden.Name == 'gardenAlpha_PartialShade') {
                gardenIdMap.put('gardenAlpha_PartialShade', retrievedGarden.Id);
            } else if (retrievedGarden.Name == 'gardenBravo_FullSun') {
                gardenIdMap.put('gardenBravo_FullSun', retrievedGarden.Id);
            } else if (retrievedGarden.Name == 'gardenCharlie_FullShade') {
                gardenIdMap.put('gardenCharlie_FullShade', retrievedGarden.Id);
            } else if (retrievedGarden.Name == 'gardenDelta_FullSun') {
                gardenIdMap.put('gardenDelta_FullSun', retrievedGarden.Id);
            } else if (retrievedGarden.Name == 'gardenEcho_PartialShade') {
                gardenIdMap.put('gardenEcho_PartialShade', retrievedGarden.Id);
            } else if (retrievedGarden.Name == 'gardenFoxtrot_FullShade') {
                gardenIdMap.put('gardenFoxtrot_FullShade', retrievedGarden.Id);
            } else if (retrievedGarden.Name == 'gardenGolf') {
                gardenIdMap.put('gardenGolf', retrievedGarden.Id);
            } else if (retrievedGarden.Name == 'gardenHotel') {
                gardenIdMap.put('gardenHotel', retrievedGarden.Id);
            }
        }

        return gardenIdMap;
    }

    // https://campapex.org/lesson/657b750acb4798858351bb3a (Aggregate the Total Plant Count)
    @IsTest
    private static void aggregate_plant_count_on_insert() {
        // GIVEN
        Map<String, Id> gardenIdMap = getGardenIdMap();

        Id gardenAlpha_PartialShadeId = gardenIdMap.get('gardenAlpha_PartialShade');

        List<CAMPX__Plant__c> plantsToInsert = testDataFactory.createPlants_aggregateTotalPlantCount(gardenAlpha_PartialShadeId);

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Plant__c.isCreateable()) {
            insert as user plantsToInsert;
        }

        Test.stopTest();

        // THEN
        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT CAMPX__Total_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Name = :GARDEN_ALPHA_PARTIAL_SHADE 
            WITH USER_MODE
        ];

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            System.assertEquals(2, retrievedGarden.CAMPX__Total_Plant_Count__c, 'Expect garden to have 2 plants');
        }
    }

    // https://campapex.org/lesson/657b750acb4798858351bb3a (Aggregate the Total Plant Count)
    @IsTest
    private static void aggregate_plant_count_on_update() {
        // GIVEN
        Map<String, Id> gardenIdMap = getGardenIdMap();

        Id gardenEcho_PartialShadeId = gardenIdMap.get('gardenEcho_PartialShade');

        final List<String> PLANTS_TO_UPDATE_NAMES = new List<String>{
            'plantBravo_FullSun', 
            'plantCharlie_FullSun', 
            'plantDelta_PartialShade', 
            'plantEcho_FullShade'
        };

        List<CAMPX__Plant__c> plantsToUpdate = [
            SELECT 
                Name, 
                CAMPX__Sunlight__c 
            FROM CAMPX__Plant__c 
            WHERE Name IN :PLANTS_TO_UPDATE_NAMES 
            WITH USER_MODE
        ];

        for (CAMPX__Plant__c plantToUpdate : plantsToUpdate) {
            if (plantToUpdate.Name == 'plantBravo_FullSun') {
                plantToUpdate.CAMPX__Garden__c = gardenEcho_PartialShadeId;
            } else if (plantToUpdate.Name == 'plantCharlie_FullSun') {
                plantToUpdate.CAMPX__Garden__c = gardenEcho_PartialShadeId;
            } else if (plantToUpdate.Name == 'plantEcho_FullShade') {
                plantToUpdate.CAMPX__Garden__c = gardenEcho_PartialShadeId;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Plant__c.isUpdateable()) {
            update as user plantsToUpdate;
        }

        Test.stopTest();

        // THEN
        final List<String> RETRIEVED_GARDENS_NAMES = new List<String>{
            'gardenDelta_FullSun', 
            'gardenEcho_PartialShade', 
            'gardenFoxtrot_FullShade'
        };

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT 
                CAMPX__Sun_Exposure__c, 
                CAMPX__Total_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :RETRIEVED_GARDENS_NAMES 
            WITH USER_MODE
        ];

        List<CAMPX__Garden__c> retrievedGardensFullSun = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensPartialSun = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensPartialShade = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensFullShade = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensNull = new List<CAMPX__Garden__c>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            if (retrievedGarden.CAMPX__Sun_Exposure__c == 'Full Sun') {
                retrievedGardensFullSun.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Sun_Exposure__c == 'Partial Sun') {
                retrievedGardensPartialSun.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Sun_Exposure__c == 'Partial Shade') {
                retrievedGardensPartialShade.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Sun_Exposure__c == 'Full Shade') {
                retrievedGardensFullShade.add(retrievedGarden);
            } else {
                retrievedGardensNull.add(retrievedGarden);
            }
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardensFullSun) {
            System.assertEquals(0, retrievedGarden.CAMPX__Total_Plant_Count__c, 'Expect 0 plant to have full sun');
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardensPartialSun) {
            System.assertEquals(0, retrievedGarden.CAMPX__Total_Plant_Count__c, 'Expect 0 plant to have partial sun');
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardensPartialShade) {
            System.assertEquals(4, retrievedGarden.CAMPX__Total_Plant_Count__c, 'Expect 4 plants to have partial shade');
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardensFullShade) {
            System.assertEquals(0, retrievedGarden.CAMPX__Total_Plant_Count__c, 'Expect 0 plant to have full shade');
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardensNull) {
            System.assertEquals(1, retrievedGarden.CAMPX__Total_Plant_Count__c, 'Expect 0 plant');
        }
    }

    // https://campapex.org/lesson/657b750acb4798858351bb3a (Aggregate the Total Plant Count)
    @IsTest
    private static void aggregate_plant_count_on_delete() {
        // GIVEN
        final List<String> PLANTS_TO_DELETE_NAMES = new List<String>{
            'plantBravo_FullSun', 
            'plantCharlie_FullSun', 
            'plantDelta_PartialShade', 
            'plantEcho_FullShade'
        };

        List<CAMPX__Plant__c> plantsToDelete = [
            SELECT Id 
            FROM CAMPX__Plant__c 
            WHERE Name IN :PLANTS_TO_DELETE_NAMES 
            WITH USER_MODE
        ];

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Plant__c.isDeletable()) {
            delete plantsToDelete;
        }

        Test.stopTest();

        // THEN
        final List<String> RETRIEVED_GARDENS_NAMES = new List<String>{
            'gardenDelta_FullSun', 
            'gardenEcho_PartialShade', 
            'gardenFoxtrot_FullShade'
        };

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT 
                CAMPX__Sun_Exposure__c, 
                CAMPX__Total_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :RETRIEVED_GARDENS_NAMES 
            WITH USER_MODE
        ];

        List<CAMPX__Garden__c> retrievedGardensFullSun = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensPartialSun = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensPartialShade = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensFullShade = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensNull = new List<CAMPX__Garden__c>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            if (retrievedGarden.CAMPX__Sun_Exposure__c == 'Full Sun') {
                retrievedGardensFullSun.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Sun_Exposure__c == 'Partial Sun') {
                retrievedGardensPartialSun.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Sun_Exposure__c == 'Partial Shade') {
                retrievedGardensPartialShade.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Sun_Exposure__c == 'Full Shade') {
                retrievedGardensFullShade.add(retrievedGarden);
            } else {
                retrievedGardensNull.add(retrievedGarden);
            }
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardensFullSun) {
            System.assertEquals(0, retrievedGarden.CAMPX__Total_Plant_Count__c, 'Expect 0 plant to have full sun');
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardensPartialSun) {
            System.assertEquals(0, retrievedGarden.CAMPX__Total_Plant_Count__c, 'Expect 0 plant to have partial sun');
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardensPartialShade) {
            System.assertEquals(0, retrievedGarden.CAMPX__Total_Plant_Count__c, 'Expect 0 plant to have partial shade');
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardensFullShade) {
            System.assertEquals(0, retrievedGarden.CAMPX__Total_Plant_Count__c, 'Expect 0 plant to have full shade');
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardensNull) {
            System.assertEquals(0, retrievedGarden.CAMPX__Total_Plant_Count__c, 'Expect 0 plant');
        }
    }

    // https://campapex.org/lesson/657b7968cb4798858351bb3d (Aggregate Unhealthy Plant Count)
    @IsTest
    private static void aggregate_unhealthy_plant_count_on_insert() {
        // GIVEN
        Map<String, Id> gardenIdMap = getGardenIdMap();

        Id gardenAlpha_PartialShadeId = gardenIdMap.get('gardenAlpha_PartialShade');

        List<CAMPX__Plant__c> plantsToInsert = testDataFactory.createPlants_aggregateUnhealthyPlantCount(gardenAlpha_PartialShadeId);

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Plant__c.isCreateable()) {
            insert as user plantsToInsert;
        }

        Test.stopTest();

        // THEN
        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT CAMPX__Total_Unhealthy_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Name = :GARDEN_ALPHA_PARTIAL_SHADE 
            WITH USER_MODE
        ];

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            System.assertEquals(3, retrievedGarden.CAMPX__Total_Unhealthy_Plant_Count__c, 'Expect 3 plants to be unhealthy');
        }
    }

    // https://campapex.org/lesson/657b7968cb4798858351bb3d (Aggregate Unhealthy Plant Count)
    @IsTest
    private static void aggregate_unhealthy_plant_count_on_update() {
        // GIVEN
        final List<String> PLANTS_TO_UPDATE_NAMES = new List<String>{
            'plantFoxtrot_Healthy', 
            'plantGolf_Healthy', 
            'plantHotel_Sick', 
            'plantIndia_Wilting', 
            'plantJuliet_Deceased', 
            'plantKilo_Wilting'
        };

        List<CAMPX__Plant__c> plantsToUpdate = [
            SELECT 
                Id, 
                Name, 
                CAMPX__Status__c 
            FROM CAMPX__Plant__c 
            WHERE Name IN :PLANTS_TO_UPDATE_NAMES 
            WITH USER_MODE
        ];

        for (CAMPX__Plant__c plantToUpdate : plantsToUpdate) {
            if (plantToUpdate.Name == 'plantFoxtrot_Healthy') {
                plantToUpdate.CAMPX__Status__c = 'Wilting';
            } else if (plantToUpdate.Name == 'plantGolf_Healthy') {
                plantToUpdate.CAMPX__Status__c = 'Sick';
            } else if (plantToUpdate.Name == 'plantHotel_Sick') {
                plantToUpdate.CAMPX__Status__c = 'Healthy';
            } else if (plantToUpdate.Name == 'plantJuliet_Deceased') {
                plantToUpdate.CAMPX__Status__c = 'Healthy';
            } else if (plantToUpdate.Name == 'plantKilo_Wilting') {
                plantToUpdate.CAMPX__Status__c = 'Healthy';
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Plant__c.isUpdateable()) {
            update as user plantsToUpdate;
        }

        Test.stopTest();

        // THEN
        final List<String> RETRIEVED_GARDENS_NAMES = new List<String>{
            'gardenCharlie', 
            'gardenDelta'
        };

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT 
                Name, 
                CAMPX__Total_Unhealthy_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :RETRIEVED_GARDENS_NAMES 
            WITH USER_MODE
        ];

        List<CAMPX__Garden__c> retrievedGardens1 = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardens2 = new List<CAMPX__Garden__c>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            if (retrievedGarden.Name == 'gardenCharlie') {
                retrievedGardens1.add(retrievedGarden);
            } else if (retrievedGarden.Name == 'gardenDelta') {
                retrievedGardens2.add(retrievedGarden);
            }
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens1) {
            System.assertEquals(3, retrievedGarden.CAMPX__Total_Unhealthy_Plant_Count__c, 'Expect 3 gardens to be unhealthy');
        }

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens2) {
            System.assertEquals(0, retrievedGarden.CAMPX__Total_Unhealthy_Plant_Count__c, 'Expect 0 garden to be unhealthy');
        }
    }

    // https://campapex.org/lesson/657b7968cb4798858351bb3d (Aggregate Unhealthy Plant Count)
    @IsTest
    private static void aggregate_unhealthy_plant_count_on_delete() {
        // GIVEN
        final List<String> NAMES = new List<String>{
            'plantFoxtrot_Healthy', 
            'plantGolf_Healthy', 
            'plantHotel_Sick', 
            'plantIndia_Wilting', 
            'plantJuliet_Deceased'
        };

        List<CAMPX__Plant__c> plantsToDelete = [
            SELECT Id 
            FROM CAMPX__Plant__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Plant__c.isDeletable()) {
            delete plantsToDelete;
        }

        Test.stopTest();

        // THEN
        final String GARDEN_CHARLIE = 'gardenCharlie';

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT CAMPX__Total_Unhealthy_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Name = :GARDEN_CHARLIE 
            WITH USER_MODE
        ];

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            System.assertEquals(0, retrievedGarden.CAMPX__Total_Unhealthy_Plant_Count__c, 'Expect 0 plant to be unhealthy');
        }
    }

    // https://campapex.org/lesson/657c788fcb4798858351bb44 (Data Integrity - Closed Gardens)
    @IsTest
    private static void cannot_select_permanently_closed_garden_on_insert() {
        // GIVEN
        CAMPX__Garden__c gardenZulu_StatusPermanentClosure = new CAMPX__Garden__c(
            Name = 'gardenZulu_StatusPermanentClosure', 
            CAMPX__Status__c = 'Permanent Closure'
        );

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardenZulu_StatusPermanentClosure;
        }

        CAMPX__Plant__c plantZulu_null = new CAMPX__Plant__c(
            Name = 'plantZulu_null', 
            CAMPX__Garden__c = gardenZulu_StatusPermanentClosure.Id
        );

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.CAMPX__Plant__c.isCreateable()) {
                insert as user plantZulu_null;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, The garden selected for this plant is permanently closed. Please select a different garden.', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    // https://campapex.org/lesson/657c788fcb4798858351bb44 (Data Integrity - Closed Gardens)
    @IsTest
    private static void cannot_select_permanently_closed_garden_on_update() {
        // GIVEN
        CAMPX__Garden__c gardenZulu_StatusPermanentClosure = new CAMPX__Garden__c(
            Name = 'gardenZulu_StatusPermanentClosure', 
            CAMPX__Status__c = 'Permanent Closure'
        );

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardenZulu_StatusPermanentClosure;
        }

        CAMPX__Plant__c plantZulu_null = new CAMPX__Plant__c(
            Name = 'plantZulu_null'
        );

        if (Schema.sObjectType.CAMPX__Plant__c.isCreateable()) {
            insert as user plantZulu_null;
        }

        plantZulu_null.CAMPX__Garden__c = gardenZulu_StatusPermanentClosure.Id;

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.CAMPX__Plant__c.isUpdateable()) {
                update as user plantZulu_null;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, The garden selected for this plant is permanently closed. Please select a different garden.', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }
}