public with sharing class ContentDocumentTriggerHandler {

    public static void handle(TriggerOperation operationType, List<ContentDocument> deletedDocuments) {

        switch on operationType {
            when AFTER_DELETE {
                deleteSDocWhenContentDocumentDeleted(deletedDocuments);
            }
        }
    }
    private static void deleteSDocWhenContentDocumentDeleted(List<ContentDocument> deletedDocuments) {
        List<String> sDocIds = new List<String>();
        for (ContentDocument contentDocument : deletedDocuments) {
            sDocIds.add(contentDocument.Description);
        }

        List<SDOC__SDoc__c> sDocs = SDocSelector.getSDocByContentDocumentId(sDocIds);
        delete sDocs;
    }
}