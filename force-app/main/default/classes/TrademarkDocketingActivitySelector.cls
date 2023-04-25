public with sharing class TrademarkDocketingActivitySelector {

    public static List<SymphonyIPM__Trademark_Docketing_Activity__c> getDocketingActivitiesByTrademarkId(String recordId) {
        return [
                SELECT Name, Id, SymphonyIPM__Actions__c, SymphonyIPM__Action_Date__c, SymphonyIPM__Asset_Type__c, SymphonyIPM__Comments__c, SymphonyIPM__Due_Date__c,
                        SymphonyIPM__Trigger__c, SymphonyIPM__Is_Closed__c, SymphonyIPM__Is_Completed__c, SymphonyIPM__Closed_Date__c, SymphonyIPM__Completion_Date__c, Comments__c
                FROM SymphonyIPM__Trademark_Docketing_Activity__c
                WHERE SymphonyIPM__Trademark__c = :recordId
                WITH SECURITY_ENFORCED
        ];
    }

    public static List<SymphonyIPMExt__D_O_Docketing_Activity__c> getDocketingActivitiesByDOId(String recordId) {
        return [
                SELECT Name, Id, SymphonyIPMExt__Actions__c, SymphonyIPMExt__Action_Date__c, SymphonyIPMExt__Asset_Type__c, SymphonyIPMExt__Comments__c, SymphonyIPMExt__Due_Date__c,
                        SymphonyIPMExt__Trigger__c, SymphonyIPMExt__Is_Closed__c, SymphonyIPMExt__Is_Completed__c, SymphonyIPMExt__Closed_Date__c, SymphonyIPMExt__Completion_Date__c
                FROM SymphonyIPMExt__D_O_Docketing_Activity__c
                WHERE SymphonyIPMExt__Dispute_Opposition__c = :recordId
                WITH SECURITY_ENFORCED
        ];
    }
}