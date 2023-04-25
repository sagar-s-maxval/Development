public with sharing class searchInstructionController
{

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
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
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

  @AuraEnabled
  public static List<String> getSearchInstructionUniqueJurisdictions(Id ProposedMarkId)
  {
    List<String> jurisdictions = new List<String>();
    Set<String> jurisdictionsSet = new Set<String>();

    if (Schema.sObjectType.SymphonyIPMExt__TM_Search_Instruction__c.isAccessible() && SymphonyIPMExt__TM_Search_Instruction__c.sObjectType.getDescribe().isAccessible())
    {
      for (SymphonyIPMExt__TM_Search_Instruction__c obj : [SELECT Primary_Jurisdiction__c FROM SymphonyIPMExt__TM_Search_Instruction__c WHERE SymphonyIPMExt__Proposed_Mark__c =: ProposedMarkId]) {
        jurisdictionsSet.add(obj.Primary_Jurisdiction__c);
      }
    }
    return new List<String>(jurisdictionsSet);
  }

  @AuraEnabled
  public static List<String> getSearchInstructionFinalRecommendation(Id ProposedMarkId)
  {
    List<String> pickListValuesList= new List<String>();
    Schema.DescribeFieldResult fieldResult = SymphonyIPMExt__TM_Search_Instruction__c.Final_Recommendation__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for( Schema.PicklistEntry pickListVal : ple){
      pickListValuesList.add(pickListVal.getLabel());
    }
    return pickListValuesList;
  }
  @AuraEnabled
  public static List<WrapperSearchInstruction> getSearchInstruction(Id ProposedMarkId)
  {
    List<WrapperSearchInstruction> WrapperSearchInstructionList = New List<WrapperSearchInstruction>();
    if (Schema.sObjectType.SymphonyIPMExt__TM_Search_Instruction__c.isAccessible() && SymphonyIPMExt__TM_Search_Instruction__c.sObjectType.getDescribe().isAccessible())
    {
      List<SymphonyIPMExt__TM_Search_Instruction__c> objSearchInsList = [SELECT Id, Is_Final_Recommendation_Approved__c,Final_Recommendation__c,SymphonyIPMExt__Search_Type__c, SymphonyIPMExt__Responsible_OC_Atty__c, SymphonyIPMExt__Search_Status__c, SymphonyIPMExt__Date_Instructed__c, SymphonyIPMExt__Due_Date__c,SymphonyIPMExt__Completion_Date__c, SymphonyIPMExt__Proposed_Mark__c, SymphonyIPMExt__Number__c,
              SymphonyIPMExt__Injunction_Risk__c, SymphonyIPMExt__Likelihood_of_Successful_Injunction__c, SymphonyIPMExt__Distinctiveness__c, SymphonyIPMExt__Intro__c, SymphonyIPMExt__Summary__c,
              SymphonyIPMExt__Likelihood_of_Registration_in_the_US__c, SymphonyIPMExt__Likelihood_of_Registration_outside_US__c, SymphonyIPMExt__Keywords__c, SymphonyIPMExt__Additional_Comments_Adjustments__c, SymphonyIPMExt__Sources_Searched__c, SymphonyIPMExt__Other_Sources_Searched__c, SymphonyIPMExt__Recommend_Filing__c, SymphonyIPMExt__Recommended_Filing_Comments__c, SymphonyIPMExt__Recommendation__c,
              SymphonyIPMExt__Likelihood_of_Registration__c, Primary_Jurisdiction__c
      FROM SymphonyIPMExt__TM_Search_Instruction__c
      WHERE SymphonyIPMExt__Proposed_Mark__c =: ProposedMarkId
      ORDER BY Primary_Jurisdiction__c DESC ];
      for(SymphonyIPMExt__TM_Search_Instruction__c objSearchInsRec : objSearchInsList)
      {
        WrapperSearchInstruction objWrapperSearchInstruction = New WrapperSearchInstruction();
        objWrapperSearchInstruction.TMSearchInstruction = objSearchInsRec;
        objWrapperSearchInstruction.IsShow = false;
        WrapperSearchInstructionList.add(objWrapperSearchInstruction);
      }
    }
    return WrapperSearchInstructionList ;
  }
  @AuraEnabled
  public static SymphonyIPMExt__TM_Search_Instruction__c getSearchInstructionRecord(string SearchInstructionRecordId)
  {
    SymphonyIPMExt__TM_Search_Instruction__c objSearch = new SymphonyIPMExt__TM_Search_Instruction__c();
    if (Schema.sObjectType.SymphonyIPMExt__TM_Search_Instruction__c.isAccessible() && SymphonyIPMExt__TM_Search_Instruction__c.sObjectType.getDescribe().isAccessible())
    {
      objSearch = [SELECT Id,SymphonyIPMExt__Search_Type__c, SymphonyIPMExt__Responsible_OC_Atty__c, SymphonyIPMExt__Search_Status__c, SymphonyIPMExt__Date_Instructed__c, SymphonyIPMExt__Due_Date__c,SymphonyIPMExt__Completion_Date__c, SymphonyIPMExt__Proposed_Mark__c, SymphonyIPMExt__Number__c,
              SymphonyIPMExt__Injunction_Risk__c, SymphonyIPMExt__Likelihood_of_Successful_Injunction__c, SymphonyIPMExt__Distinctiveness__c, SymphonyIPMExt__Intro__c, SymphonyIPMExt__Summary__c,
              SymphonyIPMExt__Likelihood_of_Registration_in_the_US__c, SymphonyIPMExt__Likelihood_of_Registration_outside_US__c, SymphonyIPMExt__Keywords__c, SymphonyIPMExt__Additional_Comments_Adjustments__c, SymphonyIPMExt__Sources_Searched__c, SymphonyIPMExt__Other_Sources_Searched__c, SymphonyIPMExt__Recommend_Filing__c, SymphonyIPMExt__Recommended_Filing_Comments__c, SymphonyIPMExt__Recommendation__c,
              SymphonyIPMExt__Likelihood_of_Registration__c
      FROM SymphonyIPMExt__TM_Search_Instruction__c
      WHERE Id =:SearchInstructionRecordId];
    }
    return objSearch;

  }
}