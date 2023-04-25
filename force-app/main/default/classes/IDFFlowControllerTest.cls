@IsTest
public with sharing class IDFFlowControllerTest {

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
    public static void testGetIdf() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c LIMIT 1]?.Id;
        Test.startTest();
        SymphonyIPM__Invention_Disclosure_New__c idf = IDFFlowController.getIDF(idfId);
        Test.stopTest();

        System.assertEquals(idfId, idf.Id);
    }

    @IsTest
    public static void testGetAdditionalInventors() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c LIMIT 1]?.Id;
        Id primaryId = [SELECT Id FROM SymphonyIPM__Inventor__c WHERE Name = 'Test Inventor' LIMIT 1]?.Id;

        Test.startTest();
        List<SymphonyIPM__Inventor__c> inventors = IDFFlowController.getAdditionalInventors(idfId, primaryId);
        Test.stopTest();

        System.assertEquals(1, inventors.size());
    }

    @IsTest
    public static void testGetTitle() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c LIMIT 1]?.Id;

        Test.startTest();
        String title = IDFFlowController.getTitle(idfId);
        Test.stopTest();

        System.assertEquals('Test', title);
    }

    @IsTest
    public static void testGetPickListValuesIntoList() {

        Test.startTest();
        Map<String, List<String>> result = IDFFlowController.getPickListValuesIntoList();
        Test.stopTest();


        System.assertEquals(2, result.keySet().size());
    }
}