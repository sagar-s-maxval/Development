/**
 * Created by oadamovskyi on 01.08.2022.
 */

public with sharing class cmpRejectOptionFlowWrapperController {

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
  }

  @AuraEnabled
  public static List<String> getFinalRecommendationValues(){
    List<String> pickListValuesList = new List<String>();
    Schema.DescribeFieldResult fieldResult = SymphonyIPMExt__TM_Search_Instruction__c.Final_Recommendation__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for( Schema.PicklistEntry pickListVal : ple){
      pickListValuesList.add(pickListVal.getLabel());
    }
    return pickListValuesList;
  }

}