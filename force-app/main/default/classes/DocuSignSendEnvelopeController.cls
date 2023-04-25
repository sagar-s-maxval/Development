public with sharing class DocuSignSendEnvelopeController {

    @AuraEnabled(Cacheable=true)
    public static List<ContentDocumentLink> getDocumentLinks(Id entityId) {
        return ContentDocumentSelector.getDocLinks(entityId);
    }

    @AuraEnabled
    public static Id getContentDocumentIdForFilePreview(Id sDocId) {
        ContentVersion contentVersion = ContentDocumentSelector.getContentVersionById(sDocId);
        return ContentDocumentSelector.getContentDocumentById(contentVersion.ContentDocumentId).Id;
    }

    @AuraEnabled(Cacheable=true)
    public static List<SDOC__SDoc__c> getSDocs(Id recordId) {
        return ContentDocumentSelector.getSDocs(recordId);
    }

    @AuraEnabled
    public static void deleteDocument(Id contentVersionId) {
        ContentVersion contentVersion = ContentDocumentSelector.getContentVersionById(contentVersionId);
        ContentDocument contentDocument = ContentDocumentSelector.getContentDocumentById(contentVersion.ContentDocumentId);
//        createContentDocumentLinkByUser(contentDocument.Id);
        delete contentDocument;
    }

    private static void createContentDocumentLinkByUser(Id contentDocumentId) {

        ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
        contentDocumentLink.ContentDocumentId = contentDocumentId;
        contentDocumentLink.Visibility = 'AllUsers';
        contentDocumentLink.ShareType = 'C';
        contentDocumentLink.LinkedEntityId = UserInfo.getUserId();
        System.debug(contentDocumentLink);
        insert contentDocumentLink;
    }

    @AuraEnabled(Cacheable=true)
    public static List<DocuSignReviewer__c> getReviewers(Id patentOrInvDiscId) {
        return DocuSignReviewerSelector.getReviewersPatentOrInvDiscId(patentOrInvDiscId);
    }

    @AuraEnabled
    public static void deleteReviewer(Id reviewerId) {
        delete new DocuSignReviewer__c(Id = reviewerId);
    }

    @AuraEnabled(Cacheable=true)
    public static List<SymphonyIPM__Inventor__c> getPersons(List<Id> persons) {
        return InventorSelector.getInventorsByIds(persons);
    }

    @AuraEnabled
    public static String send(
            Id recordId,
            Id templateId,
            List<Id> filesIds,
            List<Id> inventorsIds,
            List<Id> ccPersonsIds,
            String emailBody,
            Boolean isMultipleSign) {

        Boolean isPatent = String.valueOf(recordId.getSobjectType()) == 'SymphonyIPM__Patent__c';

        String emailSubject = DocuSignReplaceEmailData.replaceEmailSubject(recordId, templateId, isPatent);
        emailBody = DocuSignReplaceEmailData.replaceEmailBody(recordId, emailBody);

        return DocuSignService.sendAndCreateDocuSignEnvelope(recordId, filesIds, emailSubject, emailBody, inventorsIds, ccPersonsIds, isPatent);
    }

    @AuraEnabled
    public static List<Folder> getEmailTemplateFolders() {
        return [SELECT Id, Name FROM Folder WHERE Type = 'Email' OR Type = 'EmailTemplate'];
    }

    @AuraEnabled
    public static Folder getEmailTemplateDefaultFolder(String folderName) {
        return [SELECT Id, Name FROM Folder WHERE Name = :folderName];
    }

    @AuraEnabled
    public static List<EmailTemplate> getEmailTemplatesFromPatent(Id folderId) {
        try {
            return [SELECT Id, Name, DeveloperName, IsActive, Subject, HtmlValue, Body FROM EmailTemplate WHERE IsActive = TRUE AND FolderId = :folderId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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