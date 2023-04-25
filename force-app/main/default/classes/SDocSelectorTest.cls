@IsTest
public with sharing class SDocSelectorTest {
    @TestSetup
    static void setup() {
        SDOC__SDoc__c sDoc = new SDOC__SDoc__c(SDOC__Attachment_Name__c = 'Test');
        insert sDoc;

        ContentDocument contentDocument = DocuSign_TestDataFactory.createContentDocument(sDoc.Id, 1, true)[0];
    }

    @IsTest
    static void testGetSDocByContentDocumentId() {
        List<ContentDocument> contentDocuments = [SELECT Id, Description FROM ContentDocument];
        System.assert(contentDocuments.size() > 0);

        List<String> ids = new List<String>();

        for (ContentDocument contentDocument : contentDocuments) {
            ids.add(contentDocument.Description);
        }

        List<SDOC__SDoc__c> sDocs = SDocSelector.getSDocByContentDocumentId(ids);
        System.assert(!sDocs.isEmpty());
    }
}