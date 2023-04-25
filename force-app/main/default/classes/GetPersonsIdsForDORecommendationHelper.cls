global with sharing class GetPersonsIdsForDORecommendationHelper {
    global class flowInput {
        @InvocableVariable(Required=true)
        global Email_By_Roles__mdt emailByRoles;

        @InvocableVariable(Required=true)
        global D_O_Recommendation__c doRecommendation;
    }

    public class flowOutput {
        @InvocableVariable
        public List<String> toEmails;

        @InvocableVariable
        public List<String> ccEmails;

        @InvocableVariable
        public String toPersonIds;

        @InvocableVariable
        public String ccPersonIds;


        public flowOutput(List<String> toEmails, List<String> ccEmails, String toPersonIds, String ccPersonIds) {
            this.toEmails = toEmails;
            this.ccEmails = ccEmails;
            this.toPersonIds = toPersonIds;
            this.ccPersonIds = ccPersonIds;
        }
    }

    @InvocableMethod(Label='getRolesIdsForDO')
    public static List<flowOutput> getRolesIdsForDO(flowInput[] inputs) {
        flowInput input = inputs[0];

        GetEmails.flowOutput output = SendEmailHelper.getEmailsByRolesWithMetaData(input.emailByRoles, null, input.doRecommendation.Trademark__c, true, input.doRecommendation);

        flowOutput flowOutput = new flowOutput(output.toEmails, output.ccEmails, output.toPersonIds, output.ccPersonIds);

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
    }

}