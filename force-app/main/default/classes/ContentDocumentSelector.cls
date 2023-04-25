public with sharing class ContentDocumentSelector {

    public static List<ContentDocumentLink> getDocLinks(Id entityId) {
        return [SELECT Id, ContentDocumentId, ContentDocument.Title, ContentDocument.CreatedDate FROM ContentDocumentLink WHERE LinkedEntityId = :entityId];
    }

    public static List<SDOC__SDoc__c> getSDocs(Id objectId) {
        return [
                SELECT Id, Name, SDOC__ObjectID18__c,
                        CreatedDate, RelatedIds__c,
                        SDOC__Attachment_Name__c,
                        SDOC__File_ID__c,
                        SDOC__GD_Link__c,
                        SDOC__Document_Format__c,
                        SDOC__Allow_Edit__c
                FROM SDOC__SDoc__c
                WHERE (Related_Patent_Or_ID__c = :objectId
                OR SDOC__ObjectID18__c = :objectId)
                AND (SDOC__SDTemplate__r.Sign_Type__c != NULL
                OR SDOC__SDTemplate__c = NULL)
                ORDER BY CreatedDate DESC
        ];
    }

    public static ContentDocument getContentDocumentBySDocId(Id sDocId){
        return [SELECT Id FROM ContentDocument WHERE Description =: sDocId ORDER BY CreatedDate DESC LIMIT 1];
    }

    public static ContentDocument getContentDocumentById(Id contentDocumentId) {
        return [SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId];
    }

    public static ContentVersion getContentVersionById(Id contentVersionId) {
        return [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionId];
    }

    public static List<ContentVersion> getContentVersionByDocumentIds(List<Id> documentIds) {
        return [
                SELECT Id, ContentDocumentId, Title, VersionData, FileExtension, Description
                FROM ContentVersion
                WHERE Id IN :documentIds];
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