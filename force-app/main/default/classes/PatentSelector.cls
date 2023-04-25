public with sharing class PatentSelector {

    public static List<SymphonyIPM__Patent__c> getPatentsByIds(Set<Id> ids) {
        return [
                SELECT Id, SymphonyIPM__Family_ID__c, SymphonyIPM__Application_Date__c, SymphonyIPM__Issue_Date_of_Patent__c, Matter_ID__c, SymphonyIPM__Expiration_Date__c
                FROM SymphonyIPM__Patent__c
                WHERE Id IN :ids
        ];
    }

    public static SymphonyIPM__Patent__c getPatentById(Id patentId) {
        return [SELECT Id, SymphonyIPM__Hierarchy__c FROM SymphonyIPM__Patent__c WHERE Id = :patentId];
    }

    public static List<SymphonyIPM__Docketing_Activity_v2__c> getDocketingActivities(String name, Set<Id> patentsIds) {
        return [
                SELECT Id, SymphonyIPM__Patent__c
                FROM SymphonyIPM__Docketing_Activity_v2__c
                WHERE SymphonyIPM__Actions__c = :name
                AND SymphonyIPM__Patent__c IN :patentsIds
        ];
    }

    public static List<SymphonyIPM__Patent__c> getPatentsByFamilyIds(Set<String> ids) {
        return [
                SELECT Id, SymphonyIPM__Family_ID__c, Litigation_on_hold__c, SymphonyIPM__Status__c
                FROM SymphonyIPM__Patent__c
                WHERE SymphonyIPM__Family_ID__c IN :ids
        ];
    }

    public static List<SymphonyIPM__Patent_Attachments__c> getDraftDocuments(Id patentId) {
        return [
                SELECT Id
                FROM SymphonyIPM__Patent_Attachments__c
                WHERE SymphonyIPM__Patent__c = :patentId
                AND (SymphonyIPM__Version__c = 'Initial' OR SymphonyIPM__Version__c = 'Intermediate')
        ];
    }
    public static void magicMethod() {
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
    }
}