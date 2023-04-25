@IsTest
public with sharing class DocuSignSendEnvelopeControllerTest {
//    @TestSetup
//    static void setup() {
//        List<SymphonyIPM__Inventor__c> inventors = new List<SymphonyIPM__Inventor__c>();
//        for (Integer i = 0; i < 3; i++) {
//            SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name = 'test' + i, SymphonyIPM__FirstName__c = 'test', SymphonyIPM__LastName__c = 'testLastName', SymphonyIPM__Email__c = 'abc@ex.com', Is_External_Person__c = true, External_Comments__c = 'never gonna give you up');
//            inventors.add(inventor);
//        }
//        insert inventors;
//
//        SymphonyIPM__Patent__c patent = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'TestPatent', SymphonyIPM__Docket_No__c = 'TP100029DEEPV2');
//        insert patent;
//
//    }

//    @IsTest
//    static void testGetDocumentLinks() {
//        List<SymphonyIPM__Entity__c> entities = [SELECT Id FROM SymphonyIPM__Entity__c];
//        System.assertEquals(1, entities.size());
//
//        List<ContentDocumentLink> contentDocumentLinks = DocuSignSendEnvelopeController.getDocumentLinks(entities[0].Id);
//        System.assert(!contentDocumentLinks.isEmpty());
//    }

//    @IsTest
//    static void testGetPerson() {
//        List<SymphonyIPM__Inventor__c> inventors = [SELECT Id, Name FROM SymphonyIPM__Inventor__c];
//        System.assert(!inventors.isEmpty());
//
//        String idsStr = '';
//
//        for (SymphonyIPM__Inventor__c inventor : inventors) {
//            idsStr += inventor.Name + ',';
//        }
//        idsStr = idsStr.substring(0, idsStr.length() - 1);
//        System.debug(idsStr);
//
//
//        List<SymphonyIPM__Inventor__c> names = DocuSignSendEnvelopeController.getPersons(idsStr);
//        System.assert(names != null);
//    }

}