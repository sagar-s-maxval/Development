@isTest 
public class RefreshDashboardControllerTest {

    @isTest(SeeAllData=true)
    static void refreshDashboardMethod(){
        SymphonyIPM__Invention_Disclosure_New__c obj = new SymphonyIPM__Invention_Disclosure_New__c();
        obj.Name ='Test disclosure';
        // obj.SymphonyIPM__Internal_Counsel__c =UserInfo.getUserId();
        obj.SymphonyIPM__Disclosure_Status__c='Draft';
        insert obj;
        
        Set<Id> lstids = new Set<Id>();
        lstids.add(obj.Id);
        
        
        
        List<Dashboard> lstDashboard=[SELECT Id,Title,DeveloperName FROM Dashboard limit 1];
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       // RefreshDashboardController.refreshDashboard(lstids);
        RefreshDashboardController.refreshDashboard(lstDashboard[0].Title);
        String jobId=RefreshDashboardController.refreshDashboardcont(null);
        RefreshDashboardController.refreshDashboardcont(jobId);
        
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'Platform Outside Counsel'];
        User usr=new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = 'abc@test.com', 
                          Username = 'abc@maxuntest.com', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = 'abcd', 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = pf.Id);         
        insert usr;
        System.runAs(usr){
            RefreshDashboardController.refreshDashboardcont(null);
        }
        Test.stopTest();
        
        
        
    }
    
    @isTest(SeeAllData=true)
    static void getRequestMethod(){
        Test.startTest();
        List<Dashboard> lstDashboard=[SELECT Id,Title,DeveloperName FROM Dashboard limit 1];
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        RefreshDashboardController.getRequest(lstDashboard[0].Id);
        Test.stopTest();
    }
}