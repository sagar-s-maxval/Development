public with sharing class DocuSignEnvelopeSelector {
    public static List<DocuSignEnvelope__c> getEnvelopes(Id parentId) {
        return [
                SELECT Id, EnvelopeId__c, Name, Status__c, CompletedDate__c, SentDate__c, (
                        SELECT Id, Name, Status__c, Email__c,CompletedDate__c,SentDate__c
                        FROM DocuSignRecipients__r
                        ORDER BY Name
                )
                FROM DocuSignEnvelope__c
                WHERE (Patent__c = :parentId OR Invention_Disclosure__c = :parentId)
                ORDER BY SentDate__c DESC
        ];
    }
//
//    public static List<ContentDocumentLink> getDocLinks(Id entityId) {
//        return [SELECT Id, ContentDocumentId, ContentDocument.Title, ContentDocument.CreatedDate FROM ContentDocumentLink WHERE LinkedEntityId = :entityId];
//    }
//
//    public static List<ContentVersion> getFilesByDocumentId(List<Id> documentId) {
//        return [
//                SELECT Id, Title, FileExtension, VersionData
//                FROM ContentVersion
//                WHERE ContentDocumentId = :documentId
//                ORDER BY VersionNumber DESC
//                LIMIT 1
//        ];
//    }
}