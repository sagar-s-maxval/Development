trigger DocuSignRecipientTrigger on DocuSignRecipient__c (before insert, before update, after insert, after update) {

    if (Trigger.isBefore) {
        new DocuSignRecipientTriggerHelper().beforeHandler(Trigger.new, Trigger.oldMap);
    }
}