trigger ContentDocumentTrigger on ContentDocument (after delete) {
    ContentDocumentTriggerHandler.handle(Trigger.operationType, Trigger.old);
}