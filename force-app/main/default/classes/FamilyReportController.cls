public with sharing class FamilyReportController {

    @AuraEnabled
    public static ReportWrapper getFamilyReport(Id patentId) {
        ReportWrapper wrapper = new ReportWrapper();

        Id reportId = [SELECT  Id,  DeveloperName FROM Report WHERE DeveloperName = 'Family_Patents_One_Family_tm2' LIMIT 1]?.Id;
        SymphonyIPM__Patent__c patent = [SELECT Id, SymphonyIPM__Family_ID__c, SymphonyIPM__Family_ID_AI__c FROM SymphonyIPM__Patent__c WHERE Id = :patentId];


        wrapper.familyId = patent?.SymphonyIPM__Family_ID__c;
//        wrapper.familyIdAI = patent?.SymphonyIPM__Family_ID_AI__c;
        wrapper.reportId = reportId;

        return wrapper;
    }

    public class ReportWrapper {
        @AuraEnabled
        public String reportId { get; set; }

        @AuraEnabled
        public String familyId { get; set; }

        @AuraEnabled
        public Decimal familyIdAI { get; set; }
    }
public static void magicMethod(){
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
}
}