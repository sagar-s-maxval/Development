@isTest
private class HRIntegrationTest { 
     @isTest static void testCalloutForEmpo() {
        //Custom Setting mock data
        HRIntegration__c hrobj=new HRIntegration__c ();
        hrobj.Name='Prerequisites';
        hrobj.Client_ID__c='TestClientID';
        hrobj.Client_Secret__c='TestClientSecret';
        hrobj.API_URL__c='http/testurl';
        insert hrobj;
        HRIntegration__c hrobj1=new HRIntegration__c ();
        hrobj1.Name='EmployeeDetailsAPI';
        hrobj1.Client_ID__c='TestClientID';
        hrobj1.Client_Secret__c='TestClientSecret';
        hrobj1.API_URL__c='http/testurl';
        insert hrobj1;
        HRIntegration__c hrobj2=new HRIntegration__c ();
        hrobj2.Name='EmployeeIdsAPI';
        hrobj2.Client_ID__c='TestClientID';
        hrobj2.Client_Secret__c='TestClientSecret';
        hrobj2.API_URL__c='http/testurl';
        insert hrobj2;
        HRIntegration.WrapperEmployees empW = new HRIntegration.WrapperEmployees();  
        String Acesstoken='Testtoken';
        List<String> empids =new List<String>{'001571772','000704292'};
        Test.startTest();
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HttpMockupGenerator());
        HRIntegration hr =new HRIntegration();
        String  token = hr.getOAuthToken();
        List<String>  res = hr.getAllEmployeesIDS(Acesstoken); 
        List<HRIntegration.WrapperEmployees> lstemp=hr.getEmployeeDetails(Acesstoken,empids);
        Test.stopTest();

    }
   
}