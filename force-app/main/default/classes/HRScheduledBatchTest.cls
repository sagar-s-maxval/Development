@isTest
public class HRScheduledBatchTest{
    private static testMethod void method1(){
        HRIntegration__c hr = new HRIntegration__c(Name='Prerequisites', API_URL__c = 'http/testurl',
                              Client_Secret__c='testClientSecret', Client_ID__c='testClientID');
        insert hr; 
        HRIntegration__c hr1 = new HRIntegration__c(Name='EmployeeDetailsAPI', API_URL__c = 'http/testurl',
                              Client_Secret__c='testClientSecret', Client_ID__c='testClientID');
        insert hr1;
        HRIntegration__c hr2 = new HRIntegration__c(Name='EmployeeIdsAPI', API_URL__c = 'http/testurl',
                              Client_Secret__c='testClientSecret', Client_ID__c='testClientID');
        insert hr2;
        String CRON_EXP = '0 0 0 ? * * *';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpMockupGenerator());
        String jobId = System.schedule('HR Integration',CRON_EXP,new HrIntegrationScheduleClass ());
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP,ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0,ct.TimesTriggered);
        // Verify the next time the job will run
        System.assertEquals('2023-07-27 00:00:00',String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}