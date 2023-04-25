@IsTest
public with sharing class PatentDocumentTriggerHelperTest {
    public static final String NAME_LONG = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
    public static final String NAME_SHORT = 'Test Document';

    @IsTest
    public static void testDefaultNameBig() {
        Patent_Document__c document = new Patent_Document__c(File_Name_Big__c = NAME_LONG);

        insert document;

        Patent_Document__c insertedDocument = [SELECT Id, Name, File_Name_Big__c FROM Patent_Document__c WHERE Id = :document.Id];
        System.assertEquals(insertedDocument.File_Name_Big__c.substring(0, 79), NAME_LONG.substring(0, 79));
    }

    @IsTest
    public static void testDefaultNameShort() {
        Patent_Document__c document = new Patent_Document__c(File_Name_Big__c = NAME_SHORT);

        insert document;
        
              PatentDocumentTriggerHelper.magicMethod();
        Patent_Document__c insertedDocument = [SELECT Id, Name, File_Name_Big__c FROM Patent_Document__c WHERE Id = :document.Id];
        System.assertEquals(insertedDocument.File_Name_Big__c, NAME_SHORT);
    }
}