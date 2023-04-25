@IsTest
public with sharing class AssetInventorSelectorTest {
    @TestSetup
    static void setup() {
        SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name = 'test', SymphonyIPM__FirstName__c = 'test', SymphonyIPM__LastName__c = 'testLastName', SymphonyIPM__Email__c = 'abc@ex.com', Is_External_Person__c = true, External_Comments__c = 'never gonna give you up');
        insert inventor;

        SymphonyIPM__Patent__c patent = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'TestPatent', SymphonyIPM__Docket_No__c = 'TP100029DEEPV2');
        insert patent;

        SymphonyIPM__Asset_Inventor_v1__c assetInventor = new SymphonyIPM__Asset_Inventor_v1__c(Name = 'Test', SymphonyIPM__Asset__c = patent.Id, SymphonyIPM__Inventor__c = inventor.Id);
        insert assetInventor;
    }

    @IsTest
    static void testGetAssetInventorsByPatentId() {
        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];
        System.assertEquals(1, patents.size());

        List<SymphonyIPM__Asset_Inventor_v1__c> assetInventors = AssetInventorSelector.getAssetInventorsByPatentId(patents[0].Id);
        System.assert(!assetInventors.isEmpty());
    }
}