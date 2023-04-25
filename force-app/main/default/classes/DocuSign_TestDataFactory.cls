/*
classes with @IsTest annotation:
 1. can be called in test context only
 2. test coverage is not needed
 */

//@IsTest
public class DocuSign_TestDataFactory {

    public static List<SymphonyIPM__Patent__c> createPatents(Integer numRecords, Boolean toInsert) {
        List<SymphonyIPM__Patent__c> records = new List<SymphonyIPM__Patent__c>();
        for (Integer i = 0; i < numRecords; i++) {
            SymphonyIPM__Patent__c temp = new SymphonyIPM__Patent__c(
                    SymphonyIPM__Title_of_Invention__c = 'Test Patent Invention ' + i
            );
            records.add(temp);
        }
        if (toInsert) {
            insert records;
        }
        return records;
    }

    public static List<SymphonyIPM__Invention_Disclosure_New__c> createDisclosures(Integer numRecords, Boolean toInsert) {
        List<SymphonyIPM__Invention_Disclosure_New__c> records = new List<SymphonyIPM__Invention_Disclosure_New__c>();
        for (Integer i = 0; i < numRecords; i++) {
            SymphonyIPM__Invention_Disclosure_New__c temp = new SymphonyIPM__Invention_Disclosure_New__c(
                    Name = 'Test Invention Disclosure ' + i
            );
            records.add(temp);
        }
        if (toInsert) {
            insert records;
        }
        return records;
    }

    public static List<SymphonyIPM__Inventor__c> createPersons(Integer numRecords, Boolean toInsert) {
        List<SymphonyIPM__Inventor__c> records = new List<SymphonyIPM__Inventor__c>();
        for (Integer i = 0; i < numRecords; i++) {
            SymphonyIPM__Inventor__c temp = new SymphonyIPM__Inventor__c(
                    Name = 'Test Inventor ' + i,
                    SymphonyIPM__Email__c = 'test@email.com',
                    SymphonyIPM__Employment_status__c = 'Active'
            );
            records.add(temp);
        }
        if (toInsert) {
            insert records;
        }
        return records;
    }

    public static List<DocuSignReviewer__c> createDocuSignReviewers(Id patentId, Id inventorId, Integer numRecords, Boolean toInsert) {
        List<DocuSignReviewer__c> records = new List<DocuSignReviewer__c>();
        for (Integer i = 0; i < numRecords; i++) {
            DocuSignReviewer__c temp = new DocuSignReviewer__c(
                    Person__c = inventorId,
                    Patent__c = patentId
            );
            records.add(temp);
        }
        if (toInsert) {
            insert records;
        }
        return records;
    }

    public static List<SDOC__SDTemplate__c> createSDocTemplate(Integer numRecords, Boolean toInsert) {
        List<SDOC__SDTemplate__c> records = new List<SDOC__SDTemplate__c>();
        for (Integer i = 0; i < numRecords; i++) {
            SDOC__SDTemplate__c temp = new SDOC__SDTemplate__c(
                    SDOC__Template_Format__c = 'PDF',
                    Name = 'Test Template ' + i
            );
            records.add(temp);
        }
        if (toInsert) {
            insert records;
        }
        return records;
    }

    public static List<DocuSignTab__c> createDocuSignTab(Id templateId, String tabs, Integer numRecords, Boolean toInsert) {
        List<DocuSignTab__c> records = new List<DocuSignTab__c>();
        for (Integer i = 0; i < numRecords; i++) {
            DocuSignTab__c temp = new DocuSignTab__c(
                    SDoc_Template__c = templateId,
                    Tabs__c = tabs
            );
            records.add(temp);
        }
        if (toInsert) {
            insert records;
        }
        return records;
    }

    public static List<SDOC__SDoc__c> createSDoc(Id templateId, Integer numRecords, Boolean toInsert) {
        List<SDOC__SDoc__c> records = new List<SDOC__SDoc__c>();
        for (Integer i = 0; i < numRecords; i++) {
            SDOC__SDoc__c temp = new SDOC__SDoc__c(
                    SDOC__SDTemplate__c = templateId
            );
            records.add(temp);
        }
        if (toInsert) {
            insert records;
        }
        return records;
    }

    public static List<ContentDocument> createContentDocument(Id sDocId, Integer numRecords, Boolean toInsert) {
        List<ContentVersion> records = new List<ContentVersion>();
        SDOC__SDoc__c sDoc = [SELECT Id, SDOC__File_ID__c FROM SDOC__SDoc__c WHERE Id = :sDocId];
        for (Integer i = 0; i < numRecords; i++) {
            ContentVersion temp = new ContentVersion(
                    Title = 'Test Document',
                    Description = sDocId,
                    PathOnClient = 'TestDocument.pdf',
                    VersionData = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            records.add(temp);
        }
        if (toInsert) {
            insert records;
            sDoc.SDOC__File_ID__c = records[0].Id;
            update sDoc;
        }

        return [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
    }

    public static List<ContentDocumentLink> createContentDocumentLink(Id patentId, Id documentId, Integer numRecords, Boolean toInsert) {
        List<ContentDocumentLink> records = new List<ContentDocumentLink>();

        for (Integer i = 0; i < numRecords; i++) {
            ContentDocumentLink temp = new ContentDocumentLink(
                    LinkedEntityId = patentId,
                    ContentDocumentId = documentId,
                    Visibility = 'AllUsers',
                    ShareType = 'V');
            records.add(temp);
        }
        if (toInsert) {
            insert records;
        }
        return records;
    }
}