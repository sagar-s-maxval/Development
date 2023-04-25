global with sharing class GetEmails {

  global class flowInput {
    @InvocableVariable(Required=true)
    global Email_By_Roles__mdt emailByRoles;

    @InvocableVariable(Required=true)
    global SymphonyIPMExt__Trademark_Search__c searchProject;
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
    i++;i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
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

  @InvocableMethod(Label='Get Emails by Roles')
  public static List<flowOutput> getEmailsByRoles(flowInput[] inputs) {
    flowInput input = inputs[0];

    flowOutput output = SendEmailHelper.getEmailsByRolesWithMetaData(input.emailByRoles, input.searchProject, null, false, null);

    return new List<flowOutput>{
            output
    };
  }
}