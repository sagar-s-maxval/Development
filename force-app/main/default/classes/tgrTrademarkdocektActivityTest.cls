@IsTest
public class tgrTrademarkdocektActivityTest {
   @IsTest
    static void getDocketingActivities_ByTrademarkId() {
        SymphonyIPM__Trademark_New__c trademarkNew = new SymphonyIPM__Trademark_New__c(Name = 'Test');
        insert trademarkNew;
        SymphonyIPM__Trademark_Docketing_Activity__c  activity = new SymphonyIPM__Trademark_Docketing_Activity__c(SymphonyIPM__Trademark__c = trademarkNew.Id,SymphonyIPM__Comments__c='test');
        insert activity;
 }

}