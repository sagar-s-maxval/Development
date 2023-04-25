public with sharing class TrademarkDocketingActivityController {
    @AuraEnabled(Cacheable=true)
    public static List<SymphonyIPM__Trademark_Docketing_Activity__c> getDocketingActivities(String recordId) {
        return TrademarkDocketingActivitySelector.getDocketingActivitiesByTrademarkId(recordId);
    }

    @AuraEnabled(Cacheable=true)
    public static List<SymphonyIPMExt__D_O_Docketing_Activity__c> getDODocketingActivities(String recordId) {
        return TrademarkDocketingActivitySelector.getDocketingActivitiesByDOId(recordId);
    }
}