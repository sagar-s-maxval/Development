@IsTest
public with sharing class ContentDocumentSelectorTest {
    @TestSetup
    public static void setup() {

        SymphonyIPM__Inventor__c inv = new SymphonyIPM__Inventor__c();
        insert inv;

        SymphonyIPM__Invention_Disclosure_New__c inventionDisclosureNew = new SymphonyIPM__Invention_Disclosure_New__c();
        insert inventionDisclosureNew;

        SymphonyIPM__Additional_Inventor__c addInv = new SymphonyIPM__Additional_Inventor__c(SymphonyIPM__Inventor__c = inv.Id, SymphonyIPM__Invention_Disclosure_New__c = inventionDisclosureNew.Id);
        insert addInv;

        SDOC__SDTemplate__c template = new SDOC__SDTemplate__c(SDOC__Template_Format__c = 'PDF', SDOC__Base_Object__c = 'SymphonyIPM__Additional_Inventor__c');
        insert template;

        SDOC__SDoc__c doc = new SDOC__SDoc__c(SDOC__SDTemplate__c = template.Id, SDOC__ObjectID18__c = addInv.Id);
        insert doc;

        ContentVersion contentVersion = new ContentVersion(Title = 'test', PathOnClient = 'test', VersionData = Blob.valueOf('test'), Description = doc.Id);
        insert contentVersion;

        ContentVersion full = [SELECT Title, PathOnClient, VersionData, ContentDocumentId FROM ContentVersion LIMIT 1];

        ContentDocumentLink link = new ContentDocumentLink(ContentDocumentId = full.ContentDocumentId, LinkedEntityId = inventionDisclosureNew.Id);
        insert link;
    }

    @IsTest
    public static void testGetSDocsAndGetContentDocumentIdForFilePreview() {

        SymphonyIPM__Additional_Inventor__c additionalInventor = [SELECT Id FROM SymphonyIPM__Additional_Inventor__c LIMIT 1];

        Test.startTest();
        List<SDOC__SDoc__c> docs = DocuSignSendEnvelopeController.getSDocs(additionalInventor.Id);
        Id contentDocumentId = DocuSignSendEnvelopeController.getContentDocumentIdForFilePreview(docs.get(0).Id);
        Test.stopTest();

        System.assertEquals(additionalInventor.Id, docs.get(0).SDOC__ObjectID18__c);
        System.assertEquals(false, contentDocumentId == null);
    }

    @IsTest
    public static void testGetDocLinks(){

        SymphonyIPM__Invention_Disclosure_New__c inventionDisclosureNew = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c LIMIT 1];

        Test.startTest();
        List<ContentDocumentLink> links = DocuSignSendEnvelopeController.getDocumentLinks(inventionDisclosureNew.Id);
        Test.stopTest();

        System.assertEquals('test', links.get(0).ContentDocument.Title);
    }
}