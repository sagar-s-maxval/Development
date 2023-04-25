@istest
public class scheduledBatchTempIFWRelatedDocActTest{
    public static testMethod void testschedule() {    
        Test.StartTest();
        scheduledBatchTempIFWRelatedDocAct sh1 = new scheduledBatchTempIFWRelatedDocAct();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
    public static testMethod void testschedule1() {    
        Test.StartTest();
        DAReport__c dr = NEW DAReport__c();
        dr.ExecuteBatchInFinish__c = true;
        dr.No_of_Days__c = 1;
        insert dr;
        scheduledBatchTempIFWRelatedDocAct sh1 = new scheduledBatchTempIFWRelatedDocAct();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
}