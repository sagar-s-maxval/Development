@IsTest
public with sharing class DocuSignEnvelopeSelectorTest {
    @TestSetup
    static void setup() {
        SymphonyIPM__Patent__c patent = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'TestPatent', SymphonyIPM__Docket_No__c = 'TP100029DEEPV2');
        insert patent;

        insert new DocuSignEnvelope__c(Name = 'Test', Patent__c = patent.Id);
    }

    @IsTest
    static void testGetEnvelopes() {
        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];
        System.assertEquals(1, patents.size());

        List<DocuSignEnvelope__c> docuSignEnvelopes = DocuSignEnvelopeSelector.getEnvelopes(patents[0].Id);
        System.assert(!docuSignEnvelopes.isEmpty());
        System.assertEquals(1, docuSignEnvelopes.size());
    }
}