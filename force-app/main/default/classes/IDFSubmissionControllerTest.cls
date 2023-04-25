@IsTest
public with sharing class IDFSubmissionControllerTest {

    @TestSetup
    public static void testSetup() {
        SymphonyIPM__Invention_Disclosure_New__c idf = new SymphonyIPM__Invention_Disclosure_New__c(Name = 'Test', SymphonyIPM__Title__c = 'Test');
        insert idf;

        SymphonyIPM__Inventor__c primary = new SymphonyIPM__Inventor__c(Name = 'Test Inventor', SymphonyIPM__Email__c = 'test1@test.com');
        insert primary;

        SymphonyIPM__Inventor__c additional = new SymphonyIPM__Inventor__c(Name = 'Additional Inventor', SymphonyIPM__Email__c = 'test2@test.com');
        insert additional;

        SymphonyIPM__Additional_Inventor__c idInventors = new SymphonyIPM__Additional_Inventor__c(SymphonyIPM__Inventor__c = additional.Id, SymphonyIPM__Invention_Disclosure_New__c = idf.Id);
        insert idInventors;
    }

    @IsTest
    public static void testGetInventionDisclosure() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c LIMIT 1]?.Id;

        Test.startTest();
        SymphonyIPM__Invention_Disclosure_New__c idf = IDFSubmissionController.getInventionDisclosure(idfId);
        Test.stopTest();

        System.assertEquals(idfId, idf.Id);
    }

    @IsTest
    public static void testGetInventors() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c LIMIT 1]?.Id;

        Test.startTest();
        List<SymphonyIPM__Inventor__c> result = IDFSubmissionController.getInventors(idfId);
        Test.stopTest();

        System.assertEquals(0, result.size());
    }

    @IsTest
    public static void testGetSelectedInventors() {
        Id inventorId = [SELECT Id FROM SymphonyIPM__Inventor__c LIMIT 1]?.Id;

        Test.startTest();
        List<SymphonyIPM__Inventor__c> result = IDFSubmissionController.getSelectedInventors(new List<Id> {inventorId});
        Test.stopTest();

        System.assertEquals(1, result.size());
    }

    @IsTest
    public static void testGetInventorsList() {
        Id inventorId = [SELECT Id FROM SymphonyIPM__Inventor__c LIMIT 1]?.Id;

        Test.startTest();
        List<SymphonyIPM__Inventor__c> result = IDFSubmissionController.getInventorsList(new List<Id> {inventorId});
        Test.stopTest();

        System.assertEquals(1, result.size());
    }
}