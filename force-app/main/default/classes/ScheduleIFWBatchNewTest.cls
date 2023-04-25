@istest
public class ScheduleIFWBatchNewTest {
    @istest
    public static void method1(){
        Test.StartTest();
        ScheduleIFWBatchNew sh1 = new ScheduleIFWBatchNew();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test IFW Batch', sch, sh1);
        Test.stopTest();
    }
    
   
}