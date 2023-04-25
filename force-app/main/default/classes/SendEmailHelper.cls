public with sharing class SendEmailHelper {

    public static List<String> setEmails(List<String> eMails) {
        List<String> mails = new List<String>();

        if (eMails != null && !eMails.isEmpty()) {
            for (String email : eMails) {
                if (String.isNotBlank(email)) {
                    mails.add(email);
                }
            }
        }
        return mails;
    }

    public static String renderAndReplaceEmailBody(String templateId, String recordId, List<String> customTemplateValues) {
        EmailTemplate emailTemplate = EmailTemplateSelector.getEmailTemplateByTemplateId(templateId);

        String body = emailTemplate.HtmlValue;

        if (customTemplateValues != null && !customTemplateValues.isEmpty()) {
            for (Integer i = 0; i < customTemplateValues.size(); i++) {
                if (String.isEmpty(customTemplateValues[i])) {
                    customTemplateValues[i] = ' ';
                }
                body = body.replace('{' + i + '}', customTemplateValues[i]);
            }
        }

        body = Messaging.renderEmailTemplate(UserInfo.getUserId(), recordId, new List<String>{
                body
        })[0].mergedBody;

        body = removeTableAndReplaceSpecialSymbol(body);

        return body;
    }

    public static String removeTableAndReplaceSpecialSymbol(String body) {
        body = body.replace(']]>', '');
        String reg = '<table[^>]*>';
        body = body.replaceAll(reg, '');
        body = body.replace('</table>', '');
        return body;
    }

    public static String replaceEmailBodyForTextBody(String body, List<String> templateValues) {
        for (Integer i = 0; i < templateValues.size(); i++) {
            // prevent "null" to be shown in the UI
            if (String.isEmpty(templateValues[i])) {
                templateValues[i] = ' ';
            }
            body = body.replace('{' + i + '}', templateValues[i]);
        }

        return body;
    }

    public static String getEmailSubject(String templateId, String recordId) {
        String subject = Messaging.renderStoredEmailTemplate(templateId, null, recordId).subject;
        return subject;
    }

    public static List<Messaging.EmailFileAttachment> attachFile(List<String> contentDocumentIds) {
        List<ContentVersion> contentVersions = [SELECT Id, VersionData, Title, FileType FROM ContentVersion WHERE ContentDocumentId IN :contentDocumentIds];
        List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>();

        if (!contentVersions.isEmpty()) {
            for (ContentVersion contentVersion : contentVersions) {
                Messaging.EmailFileAttachment emailFileAttachment = new Messaging.EmailFileAttachment();
                emailFileAttachment.setFileName(contentVersion.Title + '.' + contentVersion.FileType);
                emailFileAttachment.setBody(contentVersion.VersionData);
                emailFileAttachments.add(emailFileAttachment);
            }
        }
        return emailFileAttachments;
    }

    @Future
    public static void createEmailHistory(String recordId, String body, String subject, String docketNo, List<String> toEmails, List<String> ccEmails) {
        Id id = recordId;
        SObjectType sObjectType = id.getSobjectType();

        String emailToString = listToString(toEmails, ccEmails);

        EmailAuditTrail__c emailAuditTrail = new EmailAuditTrail__c();
        emailAuditTrail.Name = docketNo != null ? docketNo + ' - ' + subject : subject;
        emailAuditTrail.Body__c = body;
        emailAuditTrail.EmailSubject__c = docketNo != null ? docketNo + ' - ' + subject : subject;
        emailAuditTrail.From__c = UserInfo.getUserEmail();
        emailAuditTrail.EmailAddresses__c = emailToString;

        emailAuditTrail.Trademark__c = String.valueOf(sObjectType) == 'SymphonyIPM__Trademark_New__c' ? id : null;
        emailAuditTrail.TM_Search_Instruction_Ref__c = String.valueOf(sObjectType) == 'SymphonyIPMExt__TM_Search_Instruction__c' ? id : null;
        emailAuditTrail.Search_Project__c = String.valueOf(sObjectType) == 'SymphonyIPMExt__Trademark_Search__c' ? id : null;
        emailAuditTrail.D_O_Recommendation__c = String.valueOf(sObjectType) == 'D_O_Recommendation__c' ? id : null;

        insert emailAuditTrail;
    }

    private static String listToString(List<String> toEmails, List<String> ccEmails) {
        String emailToString = '';

        for (String email : toEmails) {
            emailToString += email + ';';
        }

        for (String email : ccEmails) {
            emailToString += email + ';';
        }

        return emailToString;
    }

    public static GetEmails.flowOutput getEmailsByRolesWithMetaData(Email_By_Roles__mdt emailByRoles, SymphonyIPMExt__Trademark_Search__c searchProject, String trademarkId, Boolean relatedToDORecommendation, D_O_Recommendation__c doRecommendation) {
        List<String> toEmails = new List<String>();
        List<String> toFields = new List<String>();
        List<String> ccEmails = new List<String>();
        List<String> ccFields = new List<String>();
        String toPersonIds = '';
        String ccPersonIds = '';

        List<String> toRoles = emailByRoles.To_Roles__c != null ? emailByRoles.To_Roles__c.split(',') : new List<String>();

        List<String> ccRoles = emailByRoles.CC_Roles__c != null ? emailByRoles.CC_Roles__c.split(',') : new List<String>();

        if (!relatedToDORecommendation) {

            toEmails.addAll(GetEmailsSelector.getRolesEmails(searchProject.Id, toRoles));
            ccEmails.addAll(GetEmailsSelector.getRolesEmails(searchProject.Id, ccRoles));
            toPersonIds += GetEmailsSelector.getRolesPersonIds(searchProject.Id, toRoles);
            ccPersonIds += GetEmailsSelector.getRolesPersonIds(searchProject.Id, ccRoles);

            toFields = getFields(toRoles, toFields);
            String toFieldsString = String.join(toFields, ',');

            ccFields = getFields(ccRoles, ccFields);
            String ccFieldsString = String.join(ccFields, ',');

            if (String.isNotBlank(toFieldsString)) {
                EmailsDataOutput emailsData = personIdsToString(toPersonIds, toFieldsString, emailByRoles.Object_API_Name__c, searchProject.Id, toFields);
                toEmails.addAll(emailsData.emails);
                toPersonIds = emailsData.personIds;
            }

            if (String.isNotBlank(ccFieldsString)) {
                EmailsDataOutput emailsData = personIdsToString(ccPersonIds, ccFieldsString, emailByRoles.Object_API_Name__c, searchProject.Id, ccFields);
                ccEmails.addAll(emailsData.emails);
                ccPersonIds = emailsData.personIds;
            }
        }

        if (relatedToDORecommendation) {

            toEmails.addAll(GetEmailsSelector.getRolesEmailsForTrademark(trademarkId, toRoles));
            ccEmails.addAll(GetEmailsSelector.getRolesEmailsForTrademark(trademarkId, ccRoles));
            toPersonIds += GetEmailsSelector.getRolesPersonIdsForTrademark(trademarkId, toRoles);
            ccPersonIds += GetEmailsSelector.getRolesPersonIdsForTrademark(trademarkId, ccRoles);

            toFields = getFields(toRoles, toFields);
            String toFieldsString = String.join(toFields, ',');

            ccFields = getFields(ccRoles, ccFields);
            String ccFieldsString = String.join(ccFields, ',');

            if (String.isNotBlank(toFieldsString)) {
                EmailsDataOutput emailsData = personIdsToString(toPersonIds, toFieldsString, emailByRoles.Object_API_Name__c, doRecommendation.Id, toFields);
                toEmails.addAll(emailsData.emails);
                toPersonIds = emailsData.personIds;
            }

            if (String.isNotBlank(ccFieldsString)) {
                EmailsDataOutput emailsData = personIdsToString(ccPersonIds, ccFieldsString, emailByRoles.Object_API_Name__c, doRecommendation.Id, ccFields);
                ccEmails.addAll(emailsData.emails);
                ccPersonIds = emailsData.personIds;
            }
        }

        GetEmails.flowOutput output = new GetEmails.flowOutput(toEmails, ccEmails, toPersonIds, ccPersonIds);

        return output;
    }

    public static List<String> getFields(List<String> roles, List<String> fields) {
        for (String field : roles) {
            if (field.contains('__c')) {
                fields.add(field);
            }
        }
        return fields;
    }

    public static EmailsDataOutput personIdsToString(String personIds, String fieldsString, String objectAPIName, String recordId, List<String> fields) {
        List<String> emails = new List<String>();

        String query = new QueryBuilder()
                .selectFields(fieldsString)
                .fromObject(objectAPIName)
                .whereClause('Id = \'' + recordId + '\'')
                .buildQuery();

        SObject toSobj = Database.query(query)[0];

        System.debug(toSobj);

        for (String field : fields) {
            if (!field.contains('__r')) {
                personIds = toSobj.get(field) == null ? personIds : personIds + ',' + toSobj.get(field);
            }

            Object fieldValue = getFieldValue(toSobj, field);

            if (fieldValue != null) {
                emails.add(fieldValue.toString());
            }
        }

        return new EmailsDataOutput(emails, personIds);
    }

    public static Object getFieldValue(SObject record, String field) {
        if (record == null) {
            return null;
        }
        if (field.contains('.')) {
            return getFieldValue(record.getSObject(field.substringBefore('.')), field.substringAfter('.'));
        }
        return record.get(field);
    }

    public class EmailsDataOutput {
        public List<String> emails;
        public String personIds { get; set; }

        public EmailsDataOutput(List<String> emails, String personIds) {
            this.emails = emails;
            this.personIds = personIds;
        }
    }
}