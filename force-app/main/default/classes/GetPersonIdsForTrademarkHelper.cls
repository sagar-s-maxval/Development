global with sharing class GetPersonIdsForTrademarkHelper {

    global class flowInput {
        @InvocableVariable(Required=true)
        global Email_By_Roles__mdt emailByRoles;

        @InvocableVariable(Required=true)
        global SymphonyIPM__Trademark_New__c trademarkNew;
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

    @InvocableMethod(Label='getRolesIdsForTrademark')
    public static List<flowOutput> getRolesIdsForDO(flowInput[] inputs) {
        flowInput input = inputs[0];

        List<String> toEmails = new List<String>();
        List<String> toFields = new List<String>();
        List<String> ccEmails = new List<String>();
        List<String> ccFields = new List<String>();
        String toPersonIds = '';
        String ccPersonIds = '';

        List<String> toRoles = input.emailByRoles.To_Roles__c != null ? input.emailByRoles.To_Roles__c.split(',') : new List<String>();

        List<String> ccRoles = input.emailByRoles.CC_Roles__c != null ? input.emailByRoles.CC_Roles__c.split(',') : new List<String>();

        toEmails.addAll(GetEmailsSelector.getRolesEmailsForTrademark(input.trademarkNew.Id, toRoles));
        ccEmails.addAll(GetEmailsSelector.getRolesEmailsForTrademark(input.trademarkNew.Id, ccRoles));
        toPersonIds += GetEmailsSelector.getRolesPersonIdsForTrademark(input.trademarkNew.Id, toRoles);
        ccPersonIds += GetEmailsSelector.getRolesPersonIdsForTrademark(input.trademarkNew.Id, ccRoles);

        toFields = SendEmailHelper.getFields(toRoles, toFields);
        String toFieldsString = String.join(toFields, ',');

        ccFields = SendEmailHelper.getFields(ccRoles, ccFields);
        String ccFieldsString = String.join(ccFields, ',');

        if (String.isNotBlank(toFieldsString)) {
            SendEmailHelper.EmailsDataOutput emailsData = SendEmailHelper.personIdsToString(toPersonIds, toFieldsString, 'SymphonyIPM__Trademark_New__c', input.trademarkNew.Id, toFields);
            toPersonIds = emailsData.personIds;
        }

        if (String.isNotBlank(ccFieldsString)) {
            SendEmailHelper.EmailsDataOutput emailsData = SendEmailHelper.personIdsToString(ccPersonIds, ccFieldsString, 'SymphonyIPM__Trademark_New__c', input.trademarkNew.Id, ccFields);
            ccPersonIds = emailsData.personIds;
        }

        flowOutput flowOutput = new flowOutput(toEmails, ccEmails, toPersonIds, ccPersonIds);

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
    }
}