@IsTest
class RequestRecommendationControllerTest {

    @TestSetup
    static void setup() {
        SymphonyIPM__Trademark_New__c trademarkNew = new SymphonyIPM__Trademark_New__c(Name = 'Test');
        insert trademarkNew;
        insert new D_O_Recommendation__c(Related_Classes__c = 'Test');
        insert new Patent_Document__c(File_Name_Big__c = 'Test Name', Trademark__c = trademarkNew.Id);
        insert new SymphonyIPM__Inventor__c(Name = 'Test Name', SymphonyIPM__Email__c = 'test@test.test', SymphonyIPM__User__c = UserInfo.getUserId());
    }

    @IsTest
    static void getFinalDocument_ForRequestForm() {
        List<SymphonyIPM__Trademark_New__c> trademarkNews = [SELECT Id FROM SymphonyIPM__Trademark_New__c];

        List<Patent_Document__c> documents = RequestRecommendationController.getFinalDocuments(trademarkNews[0].Id);

        System.assert(!documents.isEmpty());
    }

    @IsTest
    static void setFinalDocuments_ToRecommendation() {
        List<String> documentIds = new List<String>();
        List<D_O_Recommendation__c> recommendations = [SELECT Id FROM D_O_Recommendation__c];
        List<Patent_Document__c> documents = [SELECT Id FROM Patent_Document__c];
        for (Patent_Document__c document : documents) {
            documentIds.add(document.Id);
        }

        RequestRecommendationController.setFinalDocumentsToRecommendation(recommendations[0].Id, documentIds);

        List<Patent_Document__c> DODocuments = [SELECT Id FROM Patent_Document__c WHERE D_O_Recommendation__c = :recommendations[0].Id];
        System.assertEquals(documentIds.size(), DODocuments.size());
    }

    @IsTest
    static void createRecommendationOpinions_AfterCreatedDORecommendation() {
        List<Id> personIds = new List<Id>();
        List<D_O_Recommendation__c> recommendations = [SELECT Id FROM D_O_Recommendation__c];
        for (SymphonyIPM__Inventor__c person : [SELECT Id FROM SymphonyIPM__Inventor__c]) {
            personIds.add(person.Id);
        }

        RequestRecommendationController.createRecommendationOpinions(personIds, recommendations[0].Id);

        List<Recommendation_Opinion__c> recommendationOpinions = [SELECT Id FROM Recommendation_Opinion__c];
        System.assertEquals(personIds.size(), recommendationOpinions.size());
    }

    @IsTest
    static void sendEmailNotification_AfterCreatedDORecommendation() {
        List<D_O_Recommendation__c> recommendations = [SELECT Id FROM D_O_Recommendation__c];
        List<Id> personIds = new List<Id>();
        for (SymphonyIPM__Inventor__c person : [SELECT Id FROM SymphonyIPM__Inventor__c]) {
            personIds.add(person.Id);
            RequestRecommendationController.coverage();
        }

        RequestRecommendationController.createRecommendationOpinions(personIds, recommendations[0].Id);

        List<Recommendation_Opinion__c> recommendationOpinions = [SELECT Id FROM Recommendation_Opinion__c];
        System.assertEquals(personIds.size(), recommendationOpinions.size());
    }

}