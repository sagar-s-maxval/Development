trigger SDocTrigger on SDOC__SDoc__c (before insert) {
    SDocTriggerHandler.handle(Trigger.operationType, Trigger.new);
}