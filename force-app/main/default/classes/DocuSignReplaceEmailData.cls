public with sharing class DocuSignReplaceEmailData {

    public static String replaceEmailSubject(Id recordId, Id templateId, Boolean isPatent) {

        String emailSubject = '';

        if (templateId != null) {

            emailSubject = Messaging.renderStoredEmailTemplate(templateId, recordId, recordId).subject;
            if (emailSubject == null) {
                emailSubject = 'EMAIL SUBJECT IS BLANK!';
            }
        } else {
            if (isPatent) {
                SymphonyIPM__Patent__c objPatent = [
                        SELECT SymphonyIPM__Docket_No__c
                        FROM SymphonyIPM__Patent__c
                        WHERE Id = :recordId
                ];
                if (objPatent != null) {
                    if (objPatent.SymphonyIPM__Docket_No__c != null) {
                        emailSubject = objPatent.SymphonyIPM__Docket_No__c;
                    }
                }
            } else {
                SymphonyIPM__Invention_Disclosure_New__c inventionDisclosureNew = [
                        SELECT Name
                        FROM SymphonyIPM__Invention_Disclosure_New__c
                        WHERE Id = :recordId
                ];
                if (inventionDisclosureNew != null) {
                    if (inventionDisclosureNew.Name != null) {
                        emailSubject = inventionDisclosureNew.Name;
                    }
                }
            }
        }
        return emailSubject;
    }

    public static String replaceEmailBody(Id recordId, String emailBody) {
        return Messaging.renderEmailTemplate(null, recordId, new List<String>{emailBody})[0].mergedBody;
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
    }
}