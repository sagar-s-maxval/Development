@IsTest
public with sharing class InventionRatingControllerTest {

    @TestSetup
    public static void testSetup() {
        SymphonyIPM__Invention_Disclosure_New__c idf = new SymphonyIPM__Invention_Disclosure_New__c(Name = 'Test', SymphonyIPM__Title__c = 'Test');
        insert idf;

        insert new SymphonyIPM__IDF_Review__c(SymphonyIPM__Base_Invention_Disclosure__c = idf.Id);
    }

    @IsTest
    public static void testGetReviews() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c LIMIT 1]?.Id;

        Test.startTest();
        SymphonyIPM__Invention_Disclosure_New__c dis=[select id from SymphonyIPM__Invention_Disclosure_New__c limit 1];
        InventionRatingController.checkuseraccess(string.valueof(dis.id));
        List<List<InventionRatingController.HeaderWrapper>> result = InventionRatingController.getReviews(idfId);
        InventionRatingController.getRecommendationOptions();
        Test.stopTest();
        

       // System.assertEquals(1, result.size());
    }

    @IsTest
    public static void testGetReview() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c LIMIT 1]?.Id;

        Test.startTest();
        SymphonyIPM__IDF_Review__c result = InventionRatingController.getReview(idfId, UserInfo.getUserId());
        Test.stopTest();

        System.assert(result != null);
    }
}