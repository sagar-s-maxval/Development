public without sharing class forceDeleteRecordController {
    @AuraEnabled
    public static void deleteEmailMessage(String id) {
        try { delete [SELECT Id FROM EmailMessage WHERE Id = :id]; } catch (Exception e) { throw e; }
    }

    @AuraEnabled
    public static String getRelatedTo(String id) {
        return [SELECT Id, RelatedToId FROM EmailMessage WHERE Id = :id].RelatedToId;
    }
}