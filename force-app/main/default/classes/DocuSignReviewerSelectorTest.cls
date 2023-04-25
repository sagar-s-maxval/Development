@IsTest
public with sharing class DocuSignReviewerSelectorTest {
    @TestSetup
    static void setup() {
        SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name = 'test', SymphonyIPM__FirstName__c = 'test', SymphonyIPM__LastName__c = 'testLastName', SymphonyIPM__Email__c = 'abc@ex.com', Is_External_Person__c = true, External_Comments__c = 'never gonna give you up');
        insert inventor;

        SymphonyIPM__Patent__c patent = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'TestPatent', SymphonyIPM__Docket_No__c = 'TP100029DEEPV2');
        insert patent;

        DocuSignReviewer__c docuSignReviewer = new DocuSignReviewer__c(Patent__c = patent.Id, Person__c = inventor.Id);
        insert docuSignReviewer;
    }

    @IsTest
    static void testGetReviewersPatentOrInvDiscId() {
        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];
        System.assertEquals(1, patents.size());

        List<DocuSignReviewer__c> docuSignReviewers = DocuSignSendEnvelopeController.getReviewers(patents[0].Id);
        List<DocuSignReviewer__c> docuSignReviewersNew = DocuSignReviewerSelector.getReviewersPatentOrInvDiscId(patents[0].Id);
        System.assert(!docuSignReviewers.isEmpty());
        System.assert(!docuSignReviewersNew.isEmpty());
    }

    @IsTest
    static void testGetSelectedReviewers() {
        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];
        System.assertEquals(1, patents.size());

        List<DocuSignReviewer__c> docuSignReviewersSelected = [SELECT Id, Person__r.Id FROM DocuSignReviewer__c];
        System.assert(!docuSignReviewersSelected.isEmpty());

        List<Id> selectedId = new List<Id>();
        selectedId.add(docuSignReviewersSelected[0].Person__r.Id);

        List<DocuSignReviewer__c> docuSignReviewers = DocuSignReviewerSelector.getSelectedReviewers(patents[0].Id, selectedId);
        System.assert(!docuSignReviewers.isEmpty());
    }

    @IsTest
    static void testDeleteReviewer() {
        List<DocuSignReviewer__c> docuSignReviewersSelected = [SELECT Id FROM DocuSignReviewer__c];
        System.assert(!docuSignReviewersSelected.isEmpty());

        DocuSignSendEnvelopeController.deleteReviewer(docuSignReviewersSelected[0].Id);
        System.assert([SELECT Id FROM DocuSignReviewer__c].isEmpty());
    }

}