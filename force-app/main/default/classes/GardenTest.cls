// https://campapex.org/course/GreenGuardian
@IsTest
private with sharing class GardenTest {
    private static TestDataFactory testDataFactory = new TestDataFactory();

    private static final String SYSTEM_ADMINISTRATOR = 'System Administrator';
    private static final String ACQUIRE_PLANTS = 'Acquire Plants';
    private static final String GARDEN_BRAVO_MGR_SYS_ADMIN = 'gardenBravo_MgrSysAdmin';

    private static User sysAdmin = [
        SELECT Id 
        FROM User 
        WHERE Profile.Name = :SYSTEM_ADMINISTRATOR 
        WITH USER_MODE 
        LIMIT 1
    ];

    @TestSetup
    private static void setup() {
        List<CAMPX__Garden__c> gardensToInsert = testDataFactory.createGardens_setup_GardenTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardensToInsert;
        }
    }

    // https://campapex.org/lesson/6571bd7f941d307edf62f86b (Initialize Garden Fields Upon Record Creation)
    // https://campapex.org/lesson/6572365bd5dbbae2aacac1a5 (Initialize Garden Fields Upon Record Creation (Sometimes))
    @IsTest
    private static void initialize_fields() {
        // GIVEN
        List<CAMPX__Garden__c> gardensToInsert = testDataFactory.createGardens_initializeField();

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardensToInsert;
        }

        Test.stopTest();

        // THEN
        final List<String> NAMES = new List<String>{
            'gardenZulu_null', 
            'gardenYankee_MaxOneHundred_MinFive_TotalTen_UnhealthyFive'
        };

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT 
                CAMPX__Max_Plant_Count__c, 
                CAMPX__Minimum_Plant_Count__c, 
                CAMPX__Total_Plant_Count__c, 
                CAMPX__Total_Unhealthy_Plant_Count__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        List<CAMPX__Garden__c> retrievedGardensChanged = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensNotChanged = new List<CAMPX__Garden__c>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            if (
                retrievedGarden.CAMPX__Max_Plant_Count__c == 100 
                && retrievedGarden.CAMPX__Minimum_Plant_Count__c == 1 
                && retrievedGarden.CAMPX__Total_Plant_Count__c == 0 
                && retrievedGarden.CAMPX__Total_Unhealthy_Plant_Count__c == 0
            ) {
                retrievedGardensChanged.add(retrievedGarden);
            } else {
                retrievedGardensNotChanged.add(retrievedGarden);
            }
        }

        System.assertEquals(1, retrievedGardensChanged.size(), 'Expect 1 garden to have fields initialized');
        System.assertEquals(1, retrievedGardensNotChanged.size(), 'Expect 1 garden to not change');
    }

    // https://campapex.org/lesson/6572949bd5dbbae2aacac1ab (Create a Task for New Gardening Managers - Part 1)
    @IsTest
    private static void create_task_on_insert() {
        // GIVEN
        List<CAMPX__Garden__c> gardensToInsert = testDataFactory.createGardens_generateTask();

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardensToInsert;
        }

        Test.stopTest();

        // THEN
        Id gardenYankee_MgrSysAdminId;
        Id gardenYankee_MgrSysAdminMgr;

        for (CAMPX__Garden__c gardenToInsert : gardensToInsert) {
            if (gardenToInsert.Name == 'gardenYankee_MgrSysAdmin') {
                gardenYankee_MgrSysAdminId = gardenToInsert.Id;

                gardenYankee_MgrSysAdminMgr = gardenToInsert.CAMPX__Manager__c;
            }
        }

        List<Task> retrievedTsks = [
            SELECT 
                Subject, 
                WhatId, 
                OwnerId 
            FROM Task 
            WHERE Subject = :ACQUIRE_PLANTS 
                AND WhatId = :gardenYankee_MgrSysAdminId 
                AND OwnerId = :gardenYankee_MgrSysAdminMgr 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedTsks.size(), 'Expect 1 task to be created');
    }

    // https://campapex.org/lesson/6578de40cb4798858351bb2b (Create a Task for New Gardening Managers - Part 2)
    @IsTest
    private static void create_task_on_update() {
        // GIVEN
        final String GARDEN_ALPHA_NULL = 'gardenAlpha_null';

        List<CAMPX__Garden__c> gardensToUpdate = [
            SELECT 
                Name, 
                CAMPX__Manager__c 
            FROM CAMPX__Garden__c 
            WHERE Name = :GARDEN_ALPHA_NULL 
            WITH USER_MODE 
            LIMIT 1
        ];

        Id gardenAlpha_nullId;

        for (CAMPX__Garden__c gardenToUpdate : gardensToUpdate) {
            if (gardenToUpdate.Name == 'gardenAlpha_null') {
                gardenToUpdate.CAMPX__Manager__c = sysAdmin.Id;

                gardenAlpha_nullId = gardenToUpdate.Id;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardensToUpdate;
        }

        Test.stopTest();

        // THEN
        List<Task> retrievedTsks = [
            SELECT 
                Subject, 
                WhatId, 
                OwnerId 
            FROM Task 
            WHERE Subject = :ACQUIRE_PLANTS 
                AND WhatId = :gardenAlpha_nullId 
                AND OwnerId = :sysAdmin.Id 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedTsks.size(), 'Expect 1 task to be created');
    }

    // https://campapex.org/lesson/6578753bcb4798858351bb22 (Reassign a Task)
    @IsTest
    private static void reassign_task() {
        // GIVEN
        List<CAMPX__Garden__c> gardensToUpdate = [
            SELECT 
                Name, 
                CAMPX__Manager__c 
            FROM CAMPX__Garden__c 
            WHERE Name = :GARDEN_BRAVO_MGR_SYS_ADMIN 
                AND CAMPX__Manager__c = :sysadmin.Id 
            WITH USER_MODE
        ];

        Profile profileSysAdmin = [
            SELECT Id 
            FROM Profile 
            WHERE Name = :SYSTEM_ADMINISTRATOR 
            WITH USER_MODE 
            LIMIT 1
        ];

        User userAlpha = new User(
            LastName = 'Alpha', 
            Alias = 'alpha', 
            Email = 'alpha@example.com', 
            Username = 'alpha@example.com.' + UserInfo.getOrganizationId(), 
            ProfileId = profileSysAdmin.Id, 
            EmailEncodingKey = 'ISO-8859-1', 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US'
        );

        if (Schema.sObjectType.User.isCreateable()) {
            insert as user userAlpha;
        }

        Id gardenBravo_MgrSysAdminId;

        for (CAMPX__Garden__c gardenToUpdate : gardensToUpdate) {
            if (gardenToUpdate.Name == 'gardenBravo_MgrSysAdmin') {
                gardenToUpdate.CAMPX__Manager__c = userAlpha.Id;

                gardenBravo_MgrSysAdminId = gardenToUpdate.Id;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardensToUpdate;
        }

        Test.stopTest();

        // THEN
        final String COMPLETED = 'Completed';

        List<Task> retrievedTsks = [
            SELECT 
                Subject, 
                Status, 
                WhatId, 
                OwnerId 
            FROM Task 
            WHERE Subject = :ACQUIRE_PLANTS 
                AND Status != :COMPLETED 
                AND WhatId = :gardenBravo_MgrSysAdminId 
                AND OwnerId = :userAlpha.Id 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedTsks.size(), 'Expect 1 task to be reassigned');
    }

    // https://campapex.org/lesson/657af897cb4798858351bb33 (Delete a Task)
    @IsTest
    private static void delete_task() {
        // GIVEN
        List<CAMPX__Garden__c> gardensToUpdate = [
            SELECT 
                Name, 
                CAMPX__Manager__c 
            FROM CAMPX__Garden__c 
            WHERE Name = :GARDEN_BRAVO_MGR_SYS_ADMIN 
            WITH USER_MODE 
            LIMIT 1
        ];

        Id gardenBravo_MgrSysAdminId;

        for (CAMPX__Garden__c gardenToUpdate : gardensToUpdate) {
            if (gardenToUpdate.Name == 'gardenBravo_MgrSysAdmin') {
                gardenToUpdate.CAMPX__Manager__c = null;

                gardenBravo_MgrSysAdminId = gardenToUpdate.Id;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardensToUpdate;
        }

        Test.stopTest();

        // THEN
        List<Task> retrievedTsks = [
            SELECT 
                Subject, 
                WhatId, 
                OwnerId 
            FROM Task 
            WHERE Subject = :ACQUIRE_PLANTS 
                AND WhatId = :gardenBravo_MgrSysAdminId 
                AND OwnerId = :sysAdmin.Id 
            WITH USER_MODE
        ];

        System.assertEquals(0, retrievedTsks.size(), 'Expect 0 task');
    }

    // https://campapex.org/lesson/657afc47cb4798858351bb34 (Set Manager Start Date)
    @IsTest
    private static void set_manager_start_date() {
        // GIVEN
        List<CAMPX__Garden__c> gardensToInsert = testDataFactory.createGardens_setMgrStartDate();

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardensToInsert;
        }

        Test.stopTest();

        // THEN
        final List<String> NAMES = new List<String>{
            'gardenZulu_null', 
            'gardenYankee_MgrSysAdmin'
        };

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT CAMPX__Manager_Start_Date__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :NAMES 
                AND CAMPX__Manager_Start_Date__c = TODAY 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedGardens.size(), 'Expect 1 garden to have manager start date');
    }

    // https://campapex.org/lesson/657b763dcb4798858351bb3b (Calculate Capacity)
    @IsTest
    private static void calculate_capacity_on_insert() {
        // GIVEN
        List<CAMPX__Garden__c> gardensToInsert = testDataFactory.createGardens_calculateCapacity();

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardensToInsert;
        }

        Test.stopTest();

        // THEN
        final List<String> NAMES = new List<String>{
            'gardenZulu_MaxOneHundred_MinOne', 
            'gardenYankee_MaxFifty_MinOne_TotalFifty'
        };

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT CAMPX__Capacity__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        List<CAMPX__Garden__c> retrievedGardensNull = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensZero = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensHaveCapacity = new List<CAMPX__Garden__c>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            if (retrievedGarden.CAMPX__Capacity__c == null) {
                retrievedGardensNull.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Capacity__c == 0) {
                retrievedGardensZero.add(retrievedGarden);
            } else {
                retrievedGardensHaveCapacity.add(retrievedGarden);
            }
        }

        System.assertEquals(0, retrievedGardensNull.size(), 'Expect 0 garden to have capacity');
        System.assertEquals(1, retrievedGardensZero.size(), 'Expect 1 garden to have zero capacity');
        System.assertEquals(1, retrievedGardensHaveCapacity.size(), 'Expect 1 garden to have capacity');
    }

    // https://campapex.org/lesson/657b763dcb4798858351bb3b (Calculate Capacity)
    @IsTest
    private static void calculate_capacity_on_update() {
        // GIVEN
        final List<String> NAMES = new List<String>{
            'gardenCharlie_MaxOneHundred_MinOne', 
            'gardenDelta_MaxOneHundred_MinOne_TotalFifty', 
            'gardenEcho_MaxFifty_MinOne_TotalFifty'
        };

        List<CAMPX__Garden__c> gardensToUpdate = [
            SELECT 
                Name, 
                CAMPX__Manager__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        for (CAMPX__Garden__c gardenToUpdate : gardensToUpdate) {
            if (gardenToUpdate.Name == 'gardenCharlie_MaxOneHundred_MinOne') {
                gardenToUpdate.CAMPX__Total_Plant_Count__c = 50;
            } else if (gardenToUpdate.Name == 'gardenDelta_MaxOneHundred_MinOne_TotalFifty') {
                gardenToUpdate.CAMPX__Total_Plant_Count__c = 0;
            } else if (gardenToUpdate.Name == 'gardenEcho_MaxFifty_MinOne_TotalFifty') {
                gardenToUpdate.CAMPX__Max_Plant_Count__c = 100;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardensToUpdate;
        }

        Test.stopTest();

        // THEN
        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT CAMPX__Capacity__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        List<CAMPX__Garden__c> retrievedGardensNull = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensZero = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensHaveCapacity = new List<CAMPX__Garden__c>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            if (retrievedGarden.CAMPX__Capacity__c == null) {
                retrievedGardensNull.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Capacity__c == 0) {
                retrievedGardensZero.add(retrievedGarden);
            } else {
                retrievedGardensHaveCapacity.add(retrievedGarden);
            }
        }

        System.assertEquals(0, retrievedGardensNull.size(), 'Expect 0 garden to have capacity');
        System.assertEquals(1, retrievedGardensZero.size(), 'Expect 1 garden to have zero capacity');
        System.assertEquals(2, retrievedGardensHaveCapacity.size(), 'Expect 2 gardens to have capacity');
    }

    // https://campapex.org/lesson/657c4f15cb4798858351bb40 (Calculate the Health Index)
    @IsTest
    private static void calculate_health_index_on_insert() {
        // GIVEN
        List<CAMPX__Garden__c> gardensToInsert = testDataFactory.createGardens_calculateHealthIndex();

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardensToInsert;
        }

        Test.stopTest();

        // THEN
        final List<String> NAMES = new List<String>{
            'gardenZulu_MaxOneHundred_MinOne', 
            'gardenYankee_MaxOneHundred_MinOne_TotalFifty'
        };

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT CAMPX__Health_Index__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        List<CAMPX__Garden__c> retrievedGardensNull = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensZero = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensHaveHealthIndex = new List<CAMPX__Garden__c>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            if (retrievedGarden.CAMPX__Health_Index__c == null) {
                retrievedGardensNull.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Health_Index__c == 0) {
                retrievedGardensZero.add(retrievedGarden);
            } else {
                retrievedGardensHaveHealthIndex.add(retrievedGarden);
            }
        }

        System.assertEquals(0, retrievedGardensNull.size(), 'Expect 0 garden to have health index');
        System.assertEquals(1, retrievedGardensZero.size(), 'Expect 1 garden to have zero health index');
        System.assertEquals(1, retrievedGardensHaveHealthIndex.size(), 'Expect 1 garden to have health index');
    }

    // https://campapex.org/lesson/657c4f15cb4798858351bb40 (Calculate the Health Index)
    @IsTest
    private static void calculate_health_index_on_update() {
        // GIVEN
        final List<String> NAMES = new List<String>{
            'gardenCharlie_MaxOneHundred_MinOne', 
            'gardenDelta_MaxOneHundred_MinOne_TotalFifty', 
            'gardenEcho_MaxFifty_MinOne_TotalFifty'
        };

        List<CAMPX__Garden__c> gardensToUpdate = [
            SELECT 
                Name, 
                CAMPX__Manager__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        for (CAMPX__Garden__c gardenToUpdate : gardensToUpdate) {
            if (gardenToUpdate.Name == 'gardenCharlie_MaxOneHundred_MinOne') {
                gardenToUpdate.CAMPX__Total_Plant_Count__c = 50;
            } else if (gardenToUpdate.Name == 'gardenDelta_MaxOneHundred_MinOne_TotalFifty') {
                gardenToUpdate.CAMPX__Total_Plant_Count__c = 0;
            } else if (gardenToUpdate.Name == 'gardenEcho_MaxFifty_MinOne_TotalFifty') {
                gardenToUpdate.CAMPX__Max_Plant_Count__c = 100;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardensToUpdate;
        }

        Test.stopTest();

        // THEN
        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT CAMPX__Health_Index__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        List<CAMPX__Garden__c> retrievedGardensNull = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensZero = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensHaveHealthIndex = new List<CAMPX__Garden__c>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            if (retrievedGarden.CAMPX__Health_Index__c == null) {
                retrievedGardensNull.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Health_Index__c == 0) {
                retrievedGardensZero.add(retrievedGarden);
            } else {
                retrievedGardensHaveHealthIndex.add(retrievedGarden);
            }
        }

        System.assertEquals(0, retrievedGardensNull.size(), 'Expect 0 garden to have health index');
        System.assertEquals(1, retrievedGardensZero.size(), 'Expect 1 garden to have zero health index');
        System.assertEquals(2, retrievedGardensHaveHealthIndex.size(), 'Expect 2 gardens to have health index');
    }

    // https://campapex.org/lesson/657c529ecb4798858351bb41 (Set Garden's Status)
    @IsTest
    private static void set_garden_status_on_insert() {
        // GIVEN
        List<CAMPX__Garden__c> gardens = testDataFactory.createGardens_setGardenStatus_on_insert();

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardens;
        }

        Test.stopTest();

        // THEN
        final List<String> NAMES = new List<String>{
            'gardenZulu_StatusPermanentClosure', 
            'gardenYankee_StatusOperational', 
            'gardenXray_StatusTemporaryClosure', 
            'gardenWhiskey_StatusOverCapacity', 
            'gardenVictor_StatusAwaitingResourcesCapacity', 
            'gardenUniform_StatusAwaitingResourcesHealth'
        };

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT CAMPX__Status__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        List<CAMPX__Garden__c> retrievedGardensPermanentClosure = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensOperational = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensTemporaryClosure = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensOverCapacity = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensAwaitingResources = new List<CAMPX__Garden__c>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            if (retrievedGarden.CAMPX__Status__c == 'Permanent Closure') {
                retrievedGardensPermanentClosure.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Status__c == 'Operational') {
                retrievedGardensOperational.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Status__c == 'Temporary Closure') {
                retrievedGardensTemporaryClosure.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Status__c == 'Over Capacity') {
                retrievedGardensOverCapacity.add(retrievedGarden);
            } else {
                retrievedGardensAwaitingResources.add(retrievedGarden);
            }
        }

        System.assertEquals(1, retrievedGardensPermanentClosure.size(), 'Expect 1 garden to be permanently closed');
        System.assertEquals(1, retrievedGardensOperational.size(), 'Expect 1 garden to be operational');
        System.assertEquals(1, retrievedGardensTemporaryClosure.size(), 'Expect 1 garden to be temporarily closed');
        System.assertEquals(1, retrievedGardensOverCapacity.size(), 'Expect 1 garden to be over capacity');
        System.assertEquals(2, retrievedGardensAwaitingResources.size(), 'Expect 2 gardens to be awaiting resources');
    }

    // https://campapex.org/lesson/657c529ecb4798858351bb41 (Set Garden's Status)
    @IsTest
    private static void set_garden_status_on_update() {
        // GIVEN
        List<CAMPX__Garden__c> gardens = testDataFactory.createGardens_setGardenStatus_on_update();

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardens;
        }

        for (CAMPX__Garden__c garden : gardens) {
            if (garden.Name == 'gardenZulu_StatusPermanentClosure') {
                garden.CAMPX__Total_Plant_Count__c = 70;
                garden.CAMPX__Total_Unhealthy_Plant_Count__c = 0;
            } else if (garden.Name == 'gardenYankee_StatusOperational') {
                garden.CAMPX__Total_Plant_Count__c = 70;
                garden.CAMPX__Total_Unhealthy_Plant_Count__c = 0;
            } else if (garden.Name == 'gardenXray_StatusTemporaryClosure') {
                garden.CAMPX__Total_Plant_Count__c = 0;
                garden.CAMPX__Total_Unhealthy_Plant_Count__c = 0;
            } else if (garden.Name == 'gardenWhiskey_StatusOverCapacity') {
                garden.CAMPX__Total_Plant_Count__c = 101;
                garden.CAMPX__Total_Unhealthy_Plant_Count__c = 0;
            } else if (garden.Name == 'gardenVictor_StatusAwaitingResourcesCapacity') {
                garden.CAMPX__Total_Plant_Count__c = 50;
                garden.CAMPX__Total_Unhealthy_Plant_Count__c = 0;
            } else if (garden.Name == 'gardenUniform_StatusAwaitingResourcesHealth') {
                garden.CAMPX__Total_Plant_Count__c = 70;
                garden.CAMPX__Total_Unhealthy_Plant_Count__c = 50;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
            update as user gardens;
        }

        Test.stopTest();

        // THEN
        final List<String> NAMES = new List<String>{
            'gardenZulu_StatusPermanentClosure', 
            'gardenYankee_StatusOperational', 
            'gardenXray_StatusTemporaryClosure', 
            'gardenWhiskey_StatusOverCapacity', 
            'gardenVictor_StatusAwaitingResourcesCapacity', 
            'gardenUniform_StatusAwaitingResourcesHealth'
        };

        List<CAMPX__Garden__c> retrievedGardens = [
            SELECT CAMPX__Status__c 
            FROM CAMPX__Garden__c 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        List<CAMPX__Garden__c> retrievedGardensPermanentClosure = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensOperational = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensTemporaryClosure = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensOverCapacity = new List<CAMPX__Garden__c>();
        List<CAMPX__Garden__c> retrievedGardensAwaitingResources = new List<CAMPX__Garden__c>();

        for (CAMPX__Garden__c retrievedGarden : retrievedGardens) {
            if (retrievedGarden.CAMPX__Status__c == 'Permanent Closure') {
                retrievedGardensPermanentClosure.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Status__c == 'Operational') {
                retrievedGardensOperational.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Status__c == 'Temporary Closure') {
                retrievedGardensTemporaryClosure.add(retrievedGarden);
            } else if (retrievedGarden.CAMPX__Status__c == 'Over Capacity') {
                retrievedGardensOverCapacity.add(retrievedGarden);
            } else {
                retrievedGardensAwaitingResources.add(retrievedGarden);
            }
        }

        System.assertEquals(1, retrievedGardensPermanentClosure.size(), 'Expect 1 garden to be permanently closed');
        System.assertEquals(1, retrievedGardensOperational.size(), 'Expect 1 garden to be operational');
        System.assertEquals(1, retrievedGardensTemporaryClosure.size(), 'Expect 1 garden to be temporarily closed');
        System.assertEquals(1, retrievedGardensOverCapacity.size(), 'Expect 1 garden to be over capacity');
        System.assertEquals(2, retrievedGardensAwaitingResources.size(), 'Expect 2 gardens to be awaiting resources');
    }

    // https://campapex.org/lesson/657c7808cb4798858351bb42 (Data Integrity - Negative Values)
    @IsTest
    private static void plant_count_cannot_be_negative_on_insert() {
        // GIVEN
        List<CAMPX__Garden__c> gardens = testDataFactory.createGardens_validateNegativeValue_on_insert();

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
                insert as user gardens;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Plant Count fields must be greater than or equal to zero.', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    // https://campapex.org/lesson/657c7808cb4798858351bb42 (Data Integrity - Negative Values)
    @IsTest
    private static void plant_count_cannot_be_negative_on_update() {
        // GIVEN
        List<CAMPX__Garden__c> gardens = testDataFactory.createGardens_validateNegativeValue_on_update();

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardens;
        }

        for (CAMPX__Garden__c garden : gardens) {
            if (garden.Name == 'gardenZulu_Min') {
                garden.CAMPX__Minimum_Plant_Count__c = -1;
            } else if (garden.Name == 'gardenYankee_Total') {
                garden.CAMPX__Total_Plant_Count__c = -1;
            } else if (garden.Name == 'gardenXray_Unhealthy') {
                garden.CAMPX__Total_Unhealthy_Plant_Count__c = -1;
            }
        }

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
                update as user gardens;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Plant Count fields must be greater than or equal to zero.', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    // https://campapex.org/lesson/6580a9fbcb4798858351bb67 (Data Integrity - Blank Values)
    @IsTest
    private static void plant_count_cannot_be_blank_on_update() {
        // GIVEN
        List<CAMPX__Garden__c> gardens = testDataFactory.createGardens_validateBlankValue_on_update();

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardens;
        }

        for (CAMPX__Garden__c garden : gardens) {
            if (garden.Name == 'gardenZulu_Max') {
                garden.CAMPX__Max_Plant_Count__c = null;
            } else if (garden.Name == 'gardenYankee_Min') {
                garden.CAMPX__Minimum_Plant_Count__c = null;
            }
        }

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
                update as user gardens;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Maximum and Minimum Plant Count fields cannot be blank when there are plants in the Garden.', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    // https://campapex.org/lesson/657c7846cb4798858351bb43 (Data Integrity - Within Range)
    @IsTest
    private static void max_plant_count_cannot_be_less_than_min_plant_count_on_insert() {
        // GIVEN
        CAMPX__Garden__c gardenZulu_Max_Min = new CAMPX__Garden__c(
            CAMPX__Max_Plant_Count__c = 1, 
            CAMPX__Minimum_Plant_Count__c = 100
        );

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
                insert as user gardenZulu_Max_Min;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, The Maximum Plant Count must be greater than or equal to the Minimum Plant Count.', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    // https://campapex.org/lesson/657c7846cb4798858351bb43 (Data Integrity - Within Range)
    @IsTest
    private static void max_plant_count_cannot_be_less_than_min_plant_count_on_update() {
        // GIVEN
        CAMPX__Garden__c gardenZulu_Max_Min = new CAMPX__Garden__c(
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1
        );

        if (Schema.sObjectType.CAMPX__Garden__c.isCreateable()) {
            insert as user gardenZulu_Max_Min;
        }

        gardenZulu_Max_Min.CAMPX__Max_Plant_Count__c = 1;
        gardenZulu_Max_Min.CAMPX__Minimum_Plant_Count__c = 100;

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.CAMPX__Garden__c.isUpdateable()) {
                update as user gardenZulu_Max_Min;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, The Maximum Plant Count must be greater than or equal to the Minimum Plant Count.', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }
}