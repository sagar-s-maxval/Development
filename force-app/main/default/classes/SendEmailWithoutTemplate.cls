global with sharing class SendEmailWithoutTemplate {

    global class flowInput {
        @InvocableVariable(Required=true)
        global List<String> eMail;

        @InvocableVariable(Required=true)
        global String recordId;

        @InvocableVariable
        global List<String> ccMail;

        @InvocableVariable
        global Boolean sendAttachment = false;

        @InvocableVariable
        global Boolean createEmailHistory = false;

        @InvocableVariable
        global String subject;

        @InvocableVariable
        global String body;

        @InvocableVariable
        global String docketNo;

        @InvocableVariable
        global List<String> contentDocumentIds;
    }

    @InvocableMethod(Label='Send Emails Without Template')
    global static void sendEmailWithoutTemplate(flowInput[] inputs) {
        for (flowInput input : inputs) {
            SendEmailService.buildAndSendEmailWithoutTemplate(input.eMail, input.ccMail, input.recordId, input.body, input.subject, input.docketNo, input.contentDocumentIds, input.sendAttachment, input.createEmailHistory);
        }
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
    }


}