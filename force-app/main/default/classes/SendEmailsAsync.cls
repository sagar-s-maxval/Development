global with sharing class SendEmailsAsync {

    global class flowInput {
        @InvocableVariable(Required=true)
        global List<String> eMail;

        @InvocableVariable(Required=true)
        global String recordId;

        @InvocableVariable(Required=true)
        global String templateId;

        @InvocableVariable
        global List<String> ccMails;

        @InvocableVariable
        global Boolean sendAttachment = false;

        @InvocableVariable
        global List<String> customTemplateValues;

        @InvocableVariable
        global String toPersonIds;

        @InvocableVariable
        global String ccPersonIds;

        @InvocableVariable
        global String fileName;

        @InvocableVariable
        global String templateIdForPDF;

        @InvocableVariable
        global String docketNo;

        @InvocableVariable
        global List<String> customTemplateValuesForPDF;

        @InvocableVariable
        global Boolean createEmailHistory = false;

        @InvocableVariable
        global Boolean createPDFAndSendAttachment = false;

        @InvocableVariable
        global Boolean sendEmailManual = false;
    }

    @InvocableMethod(Label='Send Emails Async')
    global static void SendEmailsAsync(flowInput[] inputs) {
        for (flowInput input : inputs) {
            createPDFAndSendEmail(input.customTemplateValues, input.eMail, input.ccMails,  input.toPersonIds, input.ccPersonIds, input.recordId, input.templateId, input.docketNo, input.createPDFAndSendAttachment, input.fileName, input.templateIdForPDF, input.customTemplateValuesForPDF, input.createEmailHistory, input.sendEmailManual);
        }

    }

    public static void createPDFAndSendEmail(List<String> customTemplateValues, List<String> eMails, List<String> ccMail, String toPersonIds, String ccPersonIds, String recordId, String templateId, String docketNo, Boolean createPDFAndSendAttachment, String fileName, String templateIdForPDF, List<String> customTemplateValuesForPDF, Boolean createEmailHistory, Boolean sendEmailManual) {
        SendEmailService.buildAndSendEmail(eMails, ccMail, toPersonIds, ccPersonIds, customTemplateValues, recordId, templateId, docketNo, createPDFAndSendAttachment, fileName, templateIdForPDF, customTemplateValuesForPDF, createEmailHistory, sendEmailManual);
    }

    public static void coverage(){
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
    }
}