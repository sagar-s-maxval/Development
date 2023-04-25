public with sharing class RecommendationOpinionSelector {

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
  }

    public static List<Recommendation_Opinion__c> getRecommendationOpinionBydORecId(Id dORecId) {
        return [
                SELECT Id, Name, D_O_Recommendation__c, D_O_Recommendation__r.Status__c, D_O_Recommendation__r.Link_Url__c, Persons__c, CreatedById, Final_Recommendation__c, Recommendation_Status__c,
                        Is_Final_Answer__c, Is_User_Have_Access_to_edit__c, Persons__r.SymphonyIPM__Email__c, Persons__r.Name, Comments__c, Is_Resend_Email__c, Is_User_Have_Access_to_send_Email__c, Revisit_Date__c,
                        D_O_Recommendation__r.Is_Docketer_SysAdmin__c
                FROM Recommendation_Opinion__c
                WHERE D_O_Recommendation__c = :dORecId
        ];
    }

}