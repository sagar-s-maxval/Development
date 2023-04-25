@IsTest
class TrademarkDocketingActivityControllerTest {

    @IsTest
    static void getDocketingActivities_ByTrademarkId() {
        SymphonyIPM__Trademark_New__c trademarkNew = new SymphonyIPM__Trademark_New__c(Name = 'Test');
        insert trademarkNew;
        SymphonyIPM__Trademark_Docketing_Activity__c  activity = new SymphonyIPM__Trademark_Docketing_Activity__c(SymphonyIPM__Trademark__c = trademarkNew.Id);
        insert activity;

        List<SymphonyIPM__Trademark_Docketing_Activity__c> docketingActivities = TrademarkDocketingActivityController.getDocketingActivities(trademarkNew.Id);

        System.assert(!docketingActivities.isEmpty());
    }

    @IsTest
    static void getDODocketingActivities_ByDOId() {
        SymphonyIPM__Trademark_New__c trademarkNew = new SymphonyIPM__Trademark_New__c(Name = 'Test');
        insert trademarkNew;
        SymphonyIPMExt__Dispute_Opposition__c disputeOpposition = new SymphonyIPMExt__Dispute_Opposition__c(SymphonyIPMExt__Status__c = 'Active');
        insert disputeOpposition;
        SymphonyIPMExt__D_O_Docketing_Activity__c  activity = new SymphonyIPMExt__D_O_Docketing_Activity__c(SymphonyIPMExt__Dispute_Opposition__c = disputeOpposition.Id);
        insert activity;

        List<SymphonyIPMExt__D_O_Docketing_Activity__c> docketingActivities = TrademarkDocketingActivityController.getDODocketingActivities(disputeOpposition.Id);

        System.assert(!docketingActivities.isEmpty());
    }
}