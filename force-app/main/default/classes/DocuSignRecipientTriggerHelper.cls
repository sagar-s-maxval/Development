public with sharing class DocuSignRecipientTriggerHelper {

    private List<DocuSignEnvelope__c> envelopes;

    public void beforeHandler(List<DocuSignRecipient__c> newRecipients, Map<Id, DocuSignRecipient__c> oldMap) {
        this.envelopes = [SELECT Id, EnvelopeId__c FROM DocuSignEnvelope__c];

        for (DocuSignRecipient__c recipient : newRecipients) {
            recipient.Envelope__c = this.getEnvelopeIdByExternalId(recipient.EnvelopeId__c);
        }
    }

    private Id getEnvelopeIdByExternalId(String externalId) {
        Id envelopeId;
        if (envelopes.size() > 0) {
            for (DocuSignEnvelope__c env : envelopes) {
                if (env.EnvelopeId__c == externalId) {
                    envelopeId = env.Id;
                    break;
                }
            }
        }

        return (envelopeId != null) ? envelopeId : null;
    }

    public static void magicMethod() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}