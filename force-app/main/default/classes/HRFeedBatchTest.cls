@isTest global class HRFeedBatchTest {
    @isTest global static void TestRun() {  
        list<String> lstemployeeids =new list<String>();
         lstemployeeids.add('001');
         lstemployeeids.add('002');
        HRIntegration__c hr = new HRIntegration__c(Name='Prerequisites', API_URL__c = 'http/testurl',
                              Client_Secret__c='testClientSecret', Client_ID__c='testClientID');
        insert hr; 
        HRIntegration__c hr1 = new HRIntegration__c(Name='EmployeeDetailsAPI', API_URL__c = 'http/testurl',
                              Client_Secret__c='testClientSecret', Client_ID__c='testClientID');
        insert hr1;
        HRIntegration__c hr2 = new HRIntegration__c(Name='EmployeeIdsAPI', API_URL__c = 'http/testurl',
                              Client_Secret__c='testClientSecret', Client_ID__c='testClientID');
        insert hr2;
        SymphonyIPM__Inventor__c inv = new SymphonyIPM__Inventor__c();
        inv.First_Name__c='test';
        inv.Last_Name__c ='test inv';
        inv.SymphonyIPM__Employee_ID__c='000690480';
        insert inv;
        Test.startTest();
        HRFeedbatchClass hrclass = new HRFeedbatchClass(lstemployeeids);
        Test.setMock(HttpCalloutMock.class, new HttpMockupGenerator());  
        Database.executeBatch(hrclass);
        Test.stopTest();

    }

}