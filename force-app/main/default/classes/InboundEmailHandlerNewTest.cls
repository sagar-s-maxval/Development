@IsTest
public with sharing class InboundEmailHandlerNewTest {

    @TestSetup
    static void setup() {
        SymphonyIPM__Hierarchy__c hierarchy = new SymphonyIPM__Hierarchy__c(Name = 'testBU');
        insert hierarchy;

        insert new SymphonyIPM__Inventor__c(Name = 'test', SymphonyIPM__FirstName__c = 'test', SymphonyIPM__LastName__c = 'testLastName', SymphonyIPM__Email__c = 'abc@ex.com', Is_External_Person__c = true, External_Comments__c = 'never gonna give you up');

        // Create Email Matching Rule
        List<SymphonyIPM__Incoming_Email_Config_Rule__c> emailConfigRules = new List<SymphonyIPM__Incoming_Email_Config_Rule__c>();
        emailConfigRules.add(new SymphonyIPM__Incoming_Email_Config_Rule__c(SymphonyIPM__Subject_Contains_Field__c = 'Name', SymphonyIPM__Match_Email_To__c = 'SymphonyIPM__Invention_Disclosure_New__c'));
        emailConfigRules.add(new SymphonyIPM__Incoming_Email_Config_Rule__c(SymphonyIPM__Subject_Contains_Field__c = 'SymphonyIPM__Docket_No__c', SymphonyIPM__Match_Email_To__c = 'SymphonyIPM__Patent__c'));
        emailConfigRules.add(new SymphonyIPM__Incoming_Email_Config_Rule__c(SymphonyIPM__Subject_Contains_Field__c = 'Symphonyipm__Patent_Number__c', SymphonyIPM__Match_Email_To__c = 'SymphonyIPM__Patent__c'));
        emailConfigRules.add(new SymphonyIPM__Incoming_Email_Config_Rule__c(SymphonyIPM__Subject_Contains_Field__c = 'Symphonyipm__Application_Number__c', SymphonyIPM__Match_Email_To__c = 'SymphonyIPM__Patent__c'));
        emailConfigRules.add(new SymphonyIPM__Incoming_Email_Config_Rule__c(SymphonyIPM__Subject_Contains_Field__c = 'SymphonyIPM__Docket_Number__c', SymphonyIPM__Match_Email_To__c = 'SymphonyIPM__Trademark_New__c'));
        insert emailConfigRules;

        insert new SymphonyIPM__Invention_Disclosure_New__c(Name = 'Test', SymphonyIPM__Title__c = 'Test');

        insert new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'TestPatent', SymphonyIPM__Docket_No__c = 'TP100029DEEPV2');
        
		insert new SymphonyIPM__Trademark_New__c(Name = 'TestTrademark',SymphonyIPM__Docket_Number__c = 'TM100142USPRI1');

        insert new SymphonyIPM__Entity__c(Name = 'testEntity');
    }

    @IsTest
    static void AttachmentSaved_when_InboundEmail() {
        // Given
        Contact con = new Contact();
        con.LastName = 'sample';
        con.Email = 'someaddress@email.com';
        insert con;

        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        email.subject = '[TP100029DEEPV2] - unit test';
        email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'email body';
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = Blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[]{
                attachment
        };

        // When
        Messaging.InboundEmailHandler testInbound = new InboundEmailHandlerNew();
        testInbound.handleInboundEmail(email, env);

        // Then
        Attachment[] attachments = [SELECT Id, ParentId FROM Attachment];

        EmailMessage[] emailMessages = [SELECT Id, FromName, HasAttachment FROM EmailMessage];


        System.assert(!attachments.isEmpty());
    }
    
//    @IsTest
//    static void TrademarkEmail() {
//        // Given
//        Contact con = new Contact();
//        con.LastName = 'sample';
//        con.Email = 'someaddress@email.com';
//        insert con;
//
//        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
//        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
//
//        email.subject = '[TM100142USPRI1] - unit test';
//        email.fromAddress = 'someaddress@email.com';
//        email.plainTextBody = 'email body';
//        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
//        attachment.body = Blob.valueOf('my attachment text');
//        attachment.fileName = 'textfileone.txt';
//        attachment.mimeTypeSubType = 'text/plain';
//        email.binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[]{
//                attachment
//        };
//
//        // When
//        Messaging.InboundEmailHandler testInbound = new InboundEmailHandlerNew();
//        testInbound.handleInboundEmail(email, env);
//
//        // Then
//        Attachment[] attachments = [SELECT Id, ParentId FROM Attachment];
//
////        EmailMessage emailMessage = [SELECT Id, FromName, HasAttachment FROM EmailMessage WHERE Subject = '[TM100142USPRI1] - unit test' Limit 1];
//
//
//        System.assert(true);
//    }
}