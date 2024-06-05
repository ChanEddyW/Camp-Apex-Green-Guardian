@IsTest
public with sharing class TestDataFactory {
    private final String SYSTEM_ADMINISTRATOR = 'System Administrator';

    private User sysAdmin = [
        SELECT Id 
        FROM User 
        WHERE Profile.Name = :SYSTEM_ADMINISTRATOR 
        WITH USER_MODE 
        LIMIT 1
    ];

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_setup_GardenTest() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenAlpha_null = new CAMPX__Garden__c(Name = 'gardenAlpha_null');

        gardens.add(gardenAlpha_null);

        CAMPX__Garden__c gardenBravo_MgrSysAdmin = new CAMPX__Garden__c(
            Name = 'gardenBravo_MgrSysAdmin', 
            CAMPX__Manager__c = sysAdmin.Id
        );

        gardens.add(gardenBravo_MgrSysAdmin);

        CAMPX__Garden__c gardenCharlie_MaxOneHundred_MinOne = new CAMPX__Garden__c(
            Name = 'gardenCharlie_MaxOneHundred_MinOne', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1
        );

        gardens.add(gardenCharlie_MaxOneHundred_MinOne);

        CAMPX__Garden__c gardenDelta_MaxOneHundred_MinOne_TotalFifty = new CAMPX__Garden__c(
            Name = 'gardenDelta_MaxOneHundred_MinOne_TotalFifty', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 50
        );

        gardens.add(gardenDelta_MaxOneHundred_MinOne_TotalFifty);

        CAMPX__Garden__c gardenEcho_MaxFifty_MinOne_TotalFifty = new CAMPX__Garden__c(
            Name = 'gardenEcho_MaxFifty_MinOne_TotalFifty', 
            CAMPX__Max_Plant_Count__c = 50, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 50
        );

        gardens.add(gardenEcho_MaxFifty_MinOne_TotalFifty);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_initializeField() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenZulu_null = new CAMPX__Garden__c(Name = 'gardenZulu_null');

        gardens.add(gardenZulu_null);

        CAMPX__Garden__c gardenYankee_MaxOneHundred_MinFive_TotalTen_UnhealthyFive = new CAMPX__Garden__c(
            Name = 'gardenYankee_MaxOneHundred_MinFive_TotalTen_UnhealthyFive', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 5, 
            CAMPX__Total_Plant_Count__c = 10, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 5
        );

        gardens.add(gardenYankee_MaxOneHundred_MinFive_TotalTen_UnhealthyFive);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_generateTask() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenZulu_null = new CAMPX__Garden__c(Name = 'gardenZulu_null');

        gardens.add(gardenZulu_null);

        CAMPX__Garden__c gardenYankee_MgrSysAdmin = new CAMPX__Garden__c(
            Name = 'gardenYankee_MgrSysAdmin', 
            CAMPX__Manager__c = sysAdmin.Id
        );

        gardens.add(gardenYankee_MgrSysAdmin);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_setMgrStartDate() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenZulu_null = new CAMPX__Garden__c(Name = 'gardenZulu_null');

        gardens.add(gardenZulu_null);

        CAMPX__Garden__c gardenYankee_MgrSysAdmin = new CAMPX__Garden__c(
            Name = 'gardenYankee_MgrSysAdmin', 
            CAMPX__Manager__c = sysAdmin.Id
        );

        gardens.add(gardenYankee_MgrSysAdmin);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_calculateCapacity() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenZulu_MaxOneHundred_MinOne = new CAMPX__Garden__c(
            Name = 'gardenZulu_MaxOneHundred_MinOne', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1
        );

        gardens.add(gardenZulu_MaxOneHundred_MinOne);

        CAMPX__Garden__c gardenYankee_MaxFifty_MinOne_TotalFifty = new CAMPX__Garden__c(
            Name = 'gardenYankee_MaxFifty_MinOne_TotalFifty', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 50
        );

        gardens.add(gardenYankee_MaxFifty_MinOne_TotalFifty);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_calculateHealthIndex() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenZulu_MaxOneHundred_MinOne = new CAMPX__Garden__c(
            Name = 'gardenZulu_MaxOneHundred_MinOne', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1
        );

        gardens.add(gardenZulu_MaxOneHundred_MinOne);

        CAMPX__Garden__c gardenYankee_MaxOneHundred_MinOne_TotalFifty = new CAMPX__Garden__c(
            Name = 'gardenYankee_MaxOneHundred_MinOne_TotalFifty', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 50
        );

        gardens.add(gardenYankee_MaxOneHundred_MinOne_TotalFifty);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_setGardenStatus_on_insert() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenZulu_StatusPermanentClosure = new CAMPX__Garden__c(
            Name = 'gardenZulu_StatusPermanentClosure', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Status__c = 'Permanent Closure', 
            CAMPX__Total_Plant_Count__c = 70, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 0
        );

        gardens.add(gardenZulu_StatusPermanentClosure);

        CAMPX__Garden__c gardenYankee_StatusOperational = new CAMPX__Garden__c(
            Name = 'gardenYankee_StatusOperational', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 70, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 0
        );

        gardens.add(gardenYankee_StatusOperational);

        CAMPX__Garden__c gardenXray_StatusTemporaryClosure = new CAMPX__Garden__c(
            Name = 'gardenXray_StatusTemporaryClosure', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 0, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 0
        );

        gardens.add(gardenXray_StatusTemporaryClosure);

        CAMPX__Garden__c gardenWhiskey_StatusOverCapacity = new CAMPX__Garden__c(
            Name = 'gardenWhiskey_StatusOverCapacity', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 101, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 0
        );

        gardens.add(gardenWhiskey_StatusOverCapacity);

        CAMPX__Garden__c gardenVictor_StatusAwaitingResourcesCapacity = new CAMPX__Garden__c(
            Name = 'gardenVictor_StatusAwaitingResourcesCapacity', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 50, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 0
        );

        gardens.add(gardenVictor_StatusAwaitingResourcesCapacity);

        CAMPX__Garden__c gardenUniform_StatusAwaitingResourcesHealth = new CAMPX__Garden__c(
            Name = 'gardenUniform_StatusAwaitingResourcesHealth', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 70, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 50
        );

        gardens.add(gardenUniform_StatusAwaitingResourcesHealth);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_setGardenStatus_on_update() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenZulu_StatusPermanentClosure = new CAMPX__Garden__c(
            Name = 'gardenZulu_StatusPermanentClosure', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Status__c = 'Permanent Closure'
        );

        gardens.add(gardenZulu_StatusPermanentClosure);

        CAMPX__Garden__c gardenYankee_StatusOperational = new CAMPX__Garden__c(
            Name = 'gardenYankee_StatusOperational', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1
        );

        gardens.add(gardenYankee_StatusOperational);

        CAMPX__Garden__c gardenXray_StatusTemporaryClosure = new CAMPX__Garden__c(
            Name = 'gardenXray_StatusTemporaryClosure', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1
        );

        gardens.add(gardenXray_StatusTemporaryClosure);

        CAMPX__Garden__c gardenWhiskey_StatusOverCapacity = new CAMPX__Garden__c(
            Name = 'gardenWhiskey_StatusOverCapacity', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1
        );

        gardens.add(gardenWhiskey_StatusOverCapacity);

        CAMPX__Garden__c gardenVictor_StatusAwaitingResourcesCapacity = new CAMPX__Garden__c(
            Name = 'gardenVictor_StatusAwaitingResourcesCapacity', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1
        );

        gardens.add(gardenVictor_StatusAwaitingResourcesCapacity);

        CAMPX__Garden__c gardenUniform_StatusAwaitingResourcesHealth = new CAMPX__Garden__c(
            Name = 'gardenUniform_StatusAwaitingResourcesHealth', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1
        );

        gardens.add(gardenUniform_StatusAwaitingResourcesHealth);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_validateNegativeValue_on_insert() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenZulu_Min = new CAMPX__Garden__c(
            Name = 'gardenZulu_Min', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = -1, 
            CAMPX__Total_Plant_Count__c = 0, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 0
        );

        gardens.add(gardenZulu_Min);

        CAMPX__Garden__c gardenYankee_Total = new CAMPX__Garden__c(
            Name = 'gardenYankee_Total', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = -1, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 0
        );

        gardens.add(gardenYankee_Total);

        CAMPX__Garden__c gardenXray_Unhealthy = new CAMPX__Garden__c(
            Name = 'gardenXray_Unhealthy', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 0, 
            CAMPX__Total_Unhealthy_Plant_Count__c = -1
        );

        gardens.add(gardenXray_Unhealthy);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_validateNegativeValue_on_update() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenZulu_Min = new CAMPX__Garden__c(
            Name = 'gardenZulu_Min', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 0, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 0
        );

        gardens.add(gardenZulu_Min);

        CAMPX__Garden__c gardenYankee_Total = new CAMPX__Garden__c(
            Name = 'gardenYankee_Total', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 0, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 0
        );

        gardens.add(gardenYankee_Total);

        CAMPX__Garden__c gardenXray_Unhealthy = new CAMPX__Garden__c(
            Name = 'gardenXray_Unhealthy', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 0, 
            CAMPX__Total_Unhealthy_Plant_Count__c = 0
        );

        gardens.add(gardenXray_Unhealthy);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_validateBlankValue_on_update() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenZulu_Max = new CAMPX__Garden__c(
            Name = 'gardenZulu_Max', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 1
        );

        gardens.add(gardenZulu_Max);

        CAMPX__Garden__c gardenYankee_Min = new CAMPX__Garden__c(
            Name = 'gardenYankee_Min', 
            CAMPX__Max_Plant_Count__c = 100, 
            CAMPX__Minimum_Plant_Count__c = 1, 
            CAMPX__Total_Plant_Count__c = 1
        );

        gardens.add(gardenYankee_Min);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Garden__c> createGardens_setup_PlantTest() {
        List<CAMPX__Garden__c> gardens = new List<CAMPX__Garden__c>();

        CAMPX__Garden__c gardenAlpha_PartialShade = new CAMPX__Garden__c(
            Name = 'gardenAlpha_PartialShade', 
            CAMPX__Sun_Exposure__c = 'Partial Shade'
        );

        gardens.add(gardenAlpha_PartialShade);

        CAMPX__Garden__c gardenBravo_FullSun = new CAMPX__Garden__c(
            Name = 'gardenBravo_FullSun', 
            CAMPX__Sun_Exposure__c = 'Full Sun'
        );

        gardens.add(gardenBravo_FullSun);

        CAMPX__Garden__c gardenCharlie_FullShade = new CAMPX__Garden__c(
            Name = 'gardenCharlie_FullShade', 
            CAMPX__Sun_Exposure__c = 'Full Shade'
        );

        gardens.add(gardenCharlie_FullShade);

        CAMPX__Garden__c gardenDelta_FullSun = new CAMPX__Garden__c(
            Name = 'gardenDelta_FullSun', 
            CAMPX__Sun_Exposure__c = 'Full Sun'
        );

        gardens.add(gardenDelta_FullSun);

        CAMPX__Garden__c gardenEcho_PartialShade = new CAMPX__Garden__c(
            Name = 'gardenEcho_PartialShade', 
            CAMPX__Sun_Exposure__c = 'Partial Shade'
        );

        gardens.add(gardenEcho_PartialShade);

        CAMPX__Garden__c gardenFoxtrot_FullShade = new CAMPX__Garden__c(
            Name = 'gardenFoxtrot_FullShade', 
            CAMPX__Sun_Exposure__c = 'Full Shade'
        );

        gardens.add(gardenFoxtrot_FullShade);

        CAMPX__Garden__c gardenGolf = new CAMPX__Garden__c(Name = 'gardenGolf');

        gardens.add(gardenGolf);

        CAMPX__Garden__c gardenHotel = new CAMPX__Garden__c(Name = 'gardenHotel');

        gardens.add(gardenHotel);

        return gardens;
    }

    @TestVisible
    private List<CAMPX__Plant__c> createPlants_setup(
        Id gardenDelta_FullSunId, 
        Id gardenEcho_PartialShadeId, 
        Id gardenFoxtrot_FullShadeId, 
        Id gardenGolfId, 
        Id gardenHotelId
    ) {
        List<CAMPX__Plant__c> plants = new List<CAMPX__Plant__c>();

        CAMPX__Plant__c plantAlpha_null = new CAMPX__Plant__c(
            Name = 'plantAlpha_null'
        );

        plants.add(plantAlpha_null);

        CAMPX__Plant__c plantBravo_FullSun = new CAMPX__Plant__c(
            Name = 'plantBravo_FullSun', 
            CAMPX__Sunlight__c = 'Full Sun', 
            CAMPX__Garden__c = gardenDelta_FullSunId
        );

        plants.add(plantBravo_FullSun);

        CAMPX__Plant__c plantCharlie_FullSun = new CAMPX__Plant__c(
            Name = 'plantCharlie_FullSun', 
            CAMPX__Sunlight__c = 'Full Sun', 
            CAMPX__Garden__c = gardenDelta_FullSunId
        );

        plants.add(plantCharlie_FullSun);

        CAMPX__Plant__c plantDelta_PartialShade = new CAMPX__Plant__c(
            Name = 'plantDelta_PartialShade', 
            CAMPX__Sunlight__c = 'Partial Shade', 
            CAMPX__Garden__c = gardenEcho_PartialShadeId
        );

        plants.add(plantDelta_PartialShade);

        CAMPX__Plant__c plantEcho_FullShade = new CAMPX__Plant__c(
            Name = 'plantEcho_FullShade', 
            CAMPX__Sunlight__c = 'Full Shade', 
            CAMPX__Garden__c = gardenFoxtrot_FullShadeId
        );

        plants.add(plantEcho_FullShade);

        CAMPX__Plant__c plantFoxtrot_Healthy = new CAMPX__Plant__c(
            Name = 'plantFoxtrot_Healthy', 
            CAMPX__Status__c = 'Healthy', 
            CAMPX__Garden__c = gardenGolfId
        );

        plants.add(plantFoxtrot_Healthy);

        CAMPX__Plant__c plantGolf_Healthy = new CAMPX__Plant__c(
            Name = 'plantGolf_Healthy', 
            CAMPX__Status__c = 'Healthy', 
            CAMPX__Garden__c = gardenGolfId
        );

        plants.add(plantGolf_Healthy);

        CAMPX__Plant__c plantHotel_Sick = new CAMPX__Plant__c(
            Name = 'plantHotel_Sick', 
            CAMPX__Status__c = 'Sick', 
            CAMPX__Garden__c = gardenGolfId
        );

        plants.add(plantHotel_Sick);

        CAMPX__Plant__c plantIndia_Wilting = new CAMPX__Plant__c(
            Name = 'plantIndia_Wilting', 
            CAMPX__Status__c = 'Wilting', 
            CAMPX__Garden__c = gardenGolfId
        );

        plants.add(plantIndia_Wilting);

        CAMPX__Plant__c plantJuliet_Deceased = new CAMPX__Plant__c(
            Name = 'plantJuliet_Deceased', 
            CAMPX__Status__c = 'Deceased', 
            CAMPX__Garden__c = gardenGolfId
        );

        plants.add(plantJuliet_Deceased);

        CAMPX__Plant__c plantKilo_Wilting = new CAMPX__Plant__c(
            Name = 'plantKilo_Wilting', 
            CAMPX__Status__c = 'Wilting', 
            CAMPX__Garden__c = gardenHotelId
        );

        plants.add(plantKilo_Wilting);

        return plants;
    }

    @TestVisible
    private List<CAMPX__Plant__c> createPlants_initializeField(Id gardenAlpha_PartialShadeId) {
        List<CAMPX__Plant__c> plants = new List<CAMPX__Plant__c>();

        CAMPX__Plant__c plantZulu_null = new CAMPX__Plant__c(
            Name = 'plantZulu_null'
        );

        plants.add(plantZulu_null);

        CAMPX__Plant__c plantYankee_FullSun = new CAMPX__Plant__c(
            Name = 'plantYankee_FullSun', 
            CAMPX__Sunlight__c = 'Full Sun'
        );

        plants.add(plantYankee_FullSun);

        CAMPX__Plant__c plantXray_PartialShade = new CAMPX__Plant__c(
            Name = 'plantXray_PartialShade', 
            CAMPX__Garden__c = gardenAlpha_PartialShadeId
        );

        plants.add(plantXray_PartialShade);

        CAMPX__Plant__c plantWhiskey_FullShade = new CAMPX__Plant__c(
            Name = 'plantWhiskey_FullShade', 
            CAMPX__Sunlight__c = 'Full Shade', 
            CAMPX__Garden__c = gardenAlpha_PartialShadeId
        );

        plants.add(plantWhiskey_FullShade);

        return plants;
    }

    @TestVisible
    private List<CAMPX__Plant__c> createPlants_aggregateTotalPlantCount(Id gardenAlpha_PartialShadeId) {
        List<CAMPX__Plant__c> plants = new List<CAMPX__Plant__c>();

        CAMPX__Plant__c plantZulu_null = new CAMPX__Plant__c(
            Name = 'plantZulu_null'
        );

        plants.add(plantZulu_null);

        CAMPX__Plant__c plantYankee_FullSun = new CAMPX__Plant__c(
            Name = 'plantYankee_FullSun', 
            CAMPX__Sunlight__c = 'Full Sun'
        );

        plants.add(plantYankee_FullSun);

        CAMPX__Plant__c plantXray_PartialShade = new CAMPX__Plant__c(
            Name = 'plantXray_PartialShade', 
            CAMPX__Garden__c = gardenAlpha_PartialShadeId
        );

        plants.add(plantXray_PartialShade);

        CAMPX__Plant__c plantWhiskey_FullShade = new CAMPX__Plant__c(
            Name = 'plantWhiskey_FullShade', 
            CAMPX__Sunlight__c = 'Full Shade', 
            CAMPX__Garden__c = gardenAlpha_PartialShadeId
        );

        plants.add(plantWhiskey_FullShade);

        return plants;
    }

    @TestVisible
    private List<CAMPX__Plant__c> createPlants_aggregateUnhealthyPlantCount(Id gardenAlpha_PartialShadeId) {
        List<CAMPX__Plant__c> plants = new List<CAMPX__Plant__c>();

        CAMPX__Plant__c plantZulu_null = new CAMPX__Plant__c(
            Name = 'plantZulu_null'
        );

        plants.add(plantZulu_null);

        CAMPX__Plant__c plantYankee_Healthy = new CAMPX__Plant__c(
            Name = 'plantYankee_Healthy', 
            CAMPX__Status__c = 'Healthy', 
            CAMPX__Garden__c = gardenAlpha_PartialShadeId
        );

        plants.add(plantYankee_Healthy);

        CAMPX__Plant__c plantXray_Sick = new CAMPX__Plant__c(
            Name = 'plantXray_Sick', 
            CAMPX__Status__c = 'Sick', 
            CAMPX__Garden__c = gardenAlpha_PartialShadeId
        );

        plants.add(plantXray_Sick);

        CAMPX__Plant__c plantWhiskey_Wilting = new CAMPX__Plant__c(
            Name = 'plantWhiskey_Wilting', 
            CAMPX__Status__c = 'Wilting', 
            CAMPX__Garden__c = gardenAlpha_PartialShadeId
        );

        plants.add(plantWhiskey_Wilting);

        CAMPX__Plant__c plantVictor_Deceased = new CAMPX__Plant__c(
            Name = 'plantVictor_Deceased', 
            CAMPX__Status__c = 'Deceased', 
            CAMPX__Garden__c = gardenAlpha_PartialShadeId
        );

        plants.add(plantVictor_Deceased);

        return plants;
    }
}