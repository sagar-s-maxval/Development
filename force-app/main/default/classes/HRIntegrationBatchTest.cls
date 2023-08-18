@isTest global class HRIntegrationBatchTest {
 @testSetup 
 global static void setup() {

        HRIntegration__c hr = new HRIntegration__c(Name='Prerequisites', API_URL__c = 'http/testurl',
                              Client_Secret__c='testClientSecret', Client_ID__c='testClientID');
        insert hr; 
        HRIntegration__c hr1 = new HRIntegration__c(Name='EmployeeDetailsAPI', API_URL__c = 'http/testurl',
                              Client_Secret__c='testClientSecret', Client_ID__c='testClientID');
        insert hr1;
        HRIntegration__c hr2 = new HRIntegration__c(Name='EmployeeIdsAPI', API_URL__c = 'http/testurl',
                              Client_Secret__c='testClientSecret', Client_ID__c='testClientID');
        insert hr2;
        //HRIntegration hrclass=new HRIntegration();
    }
    @isTest global static void TestRun() {         
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpMockupGenerator());
        Database.executeBatch(new HRIntegrationBatch());
        Test.stopTest();

    }

}