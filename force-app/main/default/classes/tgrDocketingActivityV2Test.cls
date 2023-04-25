@IsTest
public class tgrDocketingActivityV2Test {
    
     @IsTest
    public static void testMyClass() {
     SymphonyIPM__Docketing_Activity_v2__c dockActivity = new SymphonyIPM__Docketing_Activity_v2__c();
    insert dockActivity;

    Test.startTest();

    dockActivity.SymphonyIPM__Actions__c='Test Action';
        dockActivity.SymphonyIPM__Comments__c='Test';
    update dockActivity;

        Test.stopTest();}

}