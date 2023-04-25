@IsTest
public with sharing class AdditionalInventorSelectorTest {
    @TestSetup
    static void setup() {
        SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name = 'test', SymphonyIPM__FirstName__c = 'test', SymphonyIPM__LastName__c = 'testLastName', SymphonyIPM__Email__c = 'abc@ex.com', Is_External_Person__c = true, External_Comments__c = 'never gonna give you up');
        insert inventor;

        SymphonyIPM__Invention_Disclosure_New__c inventionDisclosureNew = new SymphonyIPM__Invention_Disclosure_New__c(Name = 'Test', SymphonyIPM__Title__c = 'Test');
        insert inventionDisclosureNew;

        SymphonyIPM__Additional_Inventor__c additionalInventor = new SymphonyIPM__Additional_Inventor__c(SymphonyIPM__Inventor__c = inventor.Id, SymphonyIPM__Invention_Disclosure_New__c = inventionDisclosureNew.Id);
        insert additionalInventor;
    }

    @IsTest
    static void testGetAdditionalInventorsById() {
        List<SymphonyIPM__Additional_Inventor__c> additionalInventors = [SELECT Id FROM SymphonyIPM__Additional_Inventor__c];
        System.assertEquals(1, additionalInventors.size());

        SymphonyIPM__Additional_Inventor__c additionalInventor = AdditionalInventorSelector.getAdditionalInventorsById(additionalInventors[0].Id);
        System.assertNotEquals(null, additionalInventor);
    }

    @IsTest
    static void testGetAdditionalInventorsByInvDiscId() {
        List<SymphonyIPM__Invention_Disclosure_New__c> inventionDisclosureNews = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c];
        System.assertEquals(1, inventionDisclosureNews.size());

        List<SymphonyIPM__Additional_Inventor__c> additionalInventors = AdditionalInventorSelector.getAdditionalInventorsByInvDiscId(inventionDisclosureNews[0].Id);
        System.assert(additionalInventors.isEmpty());
    }
}