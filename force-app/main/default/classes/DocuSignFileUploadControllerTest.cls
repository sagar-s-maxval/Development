@IsTest
public with sharing class DocuSignFileUploadControllerTest {
    @TestSetup
    static void setup() {
        DocuSign_TestDataFactory.createPatents(1, true);
        insert new ContentVersion(Title = 'ABC', PathOnClient = 'test', VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body'));
    }

    @IsTest
    static void testSaveFile() {

        String fileName = 'Test Name';
        SymphonyIPM__Patent__c patent = [SELECT Id FROM SymphonyIPM__Patent__c LIMIT 1];
        ContentVersion contentVersionTest = [SELECT Id FROM ContentVersion];

        DocuSignFileUploadController.saveFile(fileName, patent.Id, contentVersionTest.Id);

        SDOC__SDoc__c sDoc = [SELECT Id, SDOC__File_ID__c FROM SDOC__SDoc__c];
        ContentVersion contentVersion = [SELECT Id FROM ContentVersion WHERE Id = :sDoc.SDOC__File_ID__c];

        System.assert(sDoc != null);
        System.assertEquals(contentVersion.Id, sDoc.SDOC__File_ID__c);
    }
}