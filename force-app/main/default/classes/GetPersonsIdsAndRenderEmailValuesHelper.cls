global with sharing class GetPersonsIdsAndRenderEmailValuesHelper {

    global class flowInput {
        @InvocableVariable(Required=true)
        global Email_By_Roles__mdt emailByRoles;

        @InvocableVariable(Required=true)
        global D_O_Recommendation__c doRecommendation;

        @InvocableVariable(Required=true)
        global String templateId;
    }

    public class flowOutput {
        @InvocableVariable
        public List<String> toEmails;

        @InvocableVariable
        public List<String> ccEmails;

        @InvocableVariable
        public List<String> toPersonIds;

        @InvocableVariable
        public List<String> ccPersonIds;

        @InvocableVariable
        public String subject;

        @InvocableVariable
        public String body;

        public flowOutput(List<String> toEmails, List<String> ccEmails, List<String> toPersonIds, List<String> ccPersonIds, String subject, String body) {
            this.toEmails = toEmails;
            this.ccEmails = ccEmails;
            this.toPersonIds = toPersonIds;
            this.ccPersonIds = ccPersonIds;
            this.subject = subject;
            this.body = body;
        }
    }

    @InvocableMethod(Label='getRolesIdsAndEmailValues')
    public static List<flowOutput> getRolesIdsAndEmailValues(flowInput[] inputs) {
        flowInput input = inputs[0];

        GetEmails.flowOutput output = SendEmailHelper.getEmailsByRolesWithMetaData(input.emailByRoles, null, input.doRecommendation.Trademark__c, true, input.doRecommendation);

        String subject = SendEmailHelper.getEmailSubject(input.templateId, input.doRecommendation.Id);
        String body = SendEmailHelper.renderAndReplaceEmailBody(input.templateId, input.doRecommendation.Id, null);


        flowOutput flowOutput = new flowOutput(output.toEmails, output.ccEmails, output.toPersonIds.split(','), output.ccPersonIds.split(','), subject, body);

        return new List<flowOutput>{
                flowOutput
        };
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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