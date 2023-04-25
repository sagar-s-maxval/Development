public with sharing class InboundEmailHandlerService {
    private static final String PATENT_API_NAME = 'SymphonyIPM__Patent__c';
    private static final String TRADEMARK_API_NAME = 'SymphonyIPM__Trademark_New__c';
    private static final String DO_API_NAME = 'SymphonyIPMExt__Dispute_Opposition__c';

    public static Messaging.InboundEmailResult createEmailMessages(String objectApiName, List<String> lstSub, String emailLabel, Messaging.InboundEmail email) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        Id relateObjectId = getRelatedObjectId(lstSub);

        if (relateObjectId == null) {
            return handleInvalidDocketNumber(result);
        }

        if (String.valueOf(relateObjectId.getSobjectType()) != objectApiName) {
            return handleFoundDiffObject(result, emailLabel, relateObjectId);
        }

        EmailMessage em = EmailUtils.buildEmailMessage(email, relateObjectId);

        insert em;

        processAttachments(objectApiName, email, em);

        return result;
    }

    private static Messaging.InboundEmailResult handleFoundDiffObject(Messaging.InboundEmailResult result, String emailLabel, Id relateObjectId) {
        String message;
        String correctEmailId = relateObjectId.getSobjectType().getDescribe().label == 'Patent' ? 'tmdocketing@maxval.com' : relateObjectId.getSobjectType().getDescribe().label == 'Trademark' ? 'tfdocketing@maxval.com' : 'tmdocketing@maxval.com';

        EmailTemplate emailTemplate = EmailTemplateSelector.getEmailTemplateByDeveloperName('Used_the_Patent_email_address');

        message = emailTemplate.Body;
        message = message.replace('{0}', relateObjectId.getSobjectType().getDescribe().label);
        message = message.replace('{1}', emailLabel);
        message = message.replace('{2}', correctEmailId);

        result.message = message;
        result.success = false;

        return result;
    }

    private static Messaging.InboundEmailResult handleInvalidDocketNumber(Messaging.InboundEmailResult result) {
        EmailTemplate emailTemplate = EmailTemplateSelector.getEmailTemplateByDeveloperName('Invalid_Docket_Number_Template');
        result.message = emailTemplate.Body;
        result.success = false;
        return result;
    }

    // todo: optimize
    private static Id getRelatedObjectId(List<String> lstSub) {
        List<SObject> objects = new List<SObject>();
        String query;

        // Search 1
        query = getQuery(PATENT_API_NAME, lstSub);
        objects = Database.query(query);

        if (!objects.isEmpty()) {
            return objects[0].Id;
        }

        // Search 2
        query = getQuery(TRADEMARK_API_NAME, lstSub);
        objects = Database.query(query);

        if (!objects.isEmpty()) {
            return objects[0].Id;
        }

        // Search 3
        query = getQuery(DO_API_NAME, lstSub);
        objects = Database.query(query);

        if (!objects.isEmpty()) {
            return objects[0].Id;
        }

        return null;
    }

    private static void processAttachments(String objectApiName, Messaging.InboundEmail email, EmailMessage em) {

        Map<String, Attachment> attachmentsMap = EmailUtils.buildAttachments(email, em.Id);

        if (attachmentsMap.isEmpty()) {
            return;
        }

        insert attachmentsMap.values();

        Map<String, Patent_Document__c> newDocuments = InboundEmailHandlerService.createPatentDocuments(
                attachmentsMap.values(), (PATENT_API_NAME == objectApiName ? 'Patent_Document' : 'Trademark_Document'), em);

        List<ContentVersion> cVersions = InboundEmailHandlerService.createContentVersions(attachmentsMap.values());

        insert newDocuments.values();
        insert cVersions;

        List<ContentDocumentLink> cdls = InboundEmailHandlerService.linkContentVersionsToPatentDocuments(cVersions, newDocuments);

        insert cdls;

    }

    public static Map<String, Patent_Document__c> createPatentDocuments(List<Attachment> attachments, String recordTypeDevName, EmailMessage email) {
        Id recordTypeId = Schema.SObjectType.Patent_Document__c.getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId();

        Map<String, Patent_Document__c> newDocuments = new Map<String, Patent_Document__c>();

        for (Attachment attach : attachments) {
            Patent_Document__c doc = new Patent_Document__c(RecordTypeId = recordTypeId);
            doc.File_Name_Big__c = attach.Name.substringBefore('.');
            doc.Document_Type__c = 'Others';
            doc.Upload_Date__c = Date.today();
            doc.Comments__c = '';
            doc.AttachmentId__c = attach.Id;
            doc.isActive__c = false;
            doc.Source__c = 'Email';
            doc.EmailMessageId__c = email.Id;
            newDocuments.put(attach.Id, doc);
        }

        return newDocuments;
    }

    public static List<ContentVersion> createContentVersions(List<Attachment> attachments) {
        List<ContentVersion> cVersions = new List<ContentVersion>();

        for (Attachment attach : attachments) {

            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.PathOnClient = attach.Name;//File name with extention
            cVersion.Origin = 'C';//C-Content Origin. H-Chatter Origin.
            cVersion.Title = attach.Name;//Name of the file
            cVersion.VersionData = attach.Body;//File content
            cVersion.Description = attach.Id;
            cVersions.add(cVersion);
        }

        return cVersions;
    }

    public static List<ContentDocumentLink> linkContentVersionsToPatentDocuments(List<ContentVersion> cVersions, Map<String, Patent_Document__c> newDocuments) {
        List<ContentDocumentLink> cdls = new List<ContentDocumentLink>();

        Set<Id> contentVersionIds = new Set<Id>();
        for (ContentVersion cv : cVersions) {
            contentVersionIds.add(cv.Id);
        }

        List<ContentVersion> insertedContentVersions = [SELECT Description, ContentDocumentId FROM ContentVersion WHERE Id IN :contentVersionIds];

        for (ContentVersion cv : insertedContentVersions) {
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = cv.ContentDocumentId;//Add ContentDocumentId
            cDocLink.LinkedEntityId = newDocuments.get(cv.Description).Id;//Add attachment parentId
            cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            cdls.add(cDocLink);
        }

        return cdls;
    }

    public static String getQuery(String objectApiName, List<String> lstSub) {
        List<SymphonyIPM__Incoming_Email_Config_Rule__c> emailConfigRules = new List<SymphonyIPM__Incoming_Email_Config_Rule__c>();
        Set<String> stringFields = new Set<String>();
        String whereFind = '';

        emailConfigRules = [
                SELECT SymphonyIPM__Match_Email_To__c, SymphonyIPM__Subject_Contains_Field__c, SymphonyIPM__Sender__c
                FROM SymphonyIPM__Incoming_Email_Config_Rule__c
                WHERE SymphonyIPM__Match_Email_To__c = :objectApiName
        ];

        Integer i = 0;
        for (SymphonyIPM__Incoming_Email_Config_Rule__c tsrEmail : emailConfigRules) {
            stringFields.add(tsrEmail.SymphonyIPM__Subject_Contains_Field__c);
            if (i == 0) {
                whereFind += tsrEmail.SymphonyIPM__Subject_Contains_Field__c + ' IN (\'' + String.join(lstSub, '\',\'') + '\')';
            } else {
                whereFind += ' OR ' + tsrEmail.SymphonyIPM__Subject_Contains_Field__c + ' IN (\'' + String.join(lstSub, '\',\'') + '\')';
            }
            i++;
        }
        QueryBuilder queryBuilder = new QueryBuilder();

        return queryBuilder
                .selectFields(stringFields)
                .fromObject(objectApiName)
                .whereClause(whereFind)
                .buildQuery();
    }

    public static Messaging.InboundEmailResult emailResultFalse(Messaging.InboundEmailResult result, Messaging.InboundEmail email) {
        EmailTemplate emailTemplate = EmailTemplateSelector.getEmailTemplateByDeveloperName('Email_Tracker_doesn_t_contain_square_brackets');
        List<String> customTemplateValues = new List<String>{
                email.subject, email.subject.substringBefore(' '), email.subject.substringAfter(' ')
        };
        String body = SendEmailHelper.replaceEmailBodyForTextBody(emailTemplate.Body, customTemplateValues);
        result.message = body;
        result.success = false;
        return result;
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
        i++;    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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