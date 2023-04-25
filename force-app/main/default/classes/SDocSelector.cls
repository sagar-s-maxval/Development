public with sharing class SDocSelector {
    public static List<SDOC__SDoc__c> getSDocByContentDocumentId(List<String> contentDocIds) {
        return [SELECT Id FROM SDOC__SDoc__c WHERE Id IN :contentDocIds];
    }
}