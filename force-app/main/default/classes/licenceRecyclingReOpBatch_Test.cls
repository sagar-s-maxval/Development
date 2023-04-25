@isTest
public class licenceRecyclingReOpBatch_Test {
    @testSetup
    public static void setupData(){
        List<Licence_Recycling_JIT__c> licenseList = New List<Licence_Recycling_JIT__c>();
        for(Integer i=1;i<11;i++){
            Licence_Recycling_JIT__c setting = new Licence_Recycling_JIT__c();
            If(i == 1){
                setting.Name = 'Platform Inventor';
            }else If(i == 2){
                setting.Name = 'Platform Reviewer';
            }else{
                setting.Name = 'test'+i;
            }
            setting.Licence_Type__c = 'Salesforce Platform';
            setting.Number_of_Available_Licenses__c = 10;
            setting.Deactivation_Criteria__c = 2;
            setting.Re_order_email__c = 'test@test.com';
            setting.Reorder_point__c = 45;
            setting.Reorder_Quantity__c = 200;
            setting.Total_Number_of_Licences__c = 20;
            setting.Used_Licenses__c = 10.0; 
             setting.Usage_Recycling__c = 40;
            licenseList.add(setting);
        }
        insert licenseList; 
    }
    
    public static testMethod void Method1() { 
        //String jobId = System.schedule('ScheduleApexClassTest',  '0 0 0 15 3 ? *', new licenceRecyclingReorderOpScheduler());
        User userData = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Inventor'].Id,
         LastName = 'name',
         Email = 'usertestmail@testdata.com',
         Username = 'usertestmail1@testdata.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         //UserRoleId = r.Id
         );
        try{
            insert userData;}catch(Exception e){}        
        List<User> lstUser = new List<User>{userData}; 
            Set<Id> usrIdSet = new Set<Id>{userData.id};
        Map<Id,Integer> mpLstLogin = new Map<Id,Integer>();
        String lstProf = 'Platform Inventor';
        mpLstLogin.put(userData.id,2); 
        Test.startTest();
        licenceRecyclingReorderOpBatch b = new licenceRecyclingReorderOpBatch(lstProf,lstUser,usrIdSet,mpLstLogin,true);
        Database.executebatch(b);
        //licenseRecyclingDetails lr = new licenseRecyclingDetails();
        licenseRecyclingDetails.getUserList('Platform Inventor',usrIdSet);
        licenseRecyclingDetails.getLastLoginDetails('Platform Inventor'); 
        Test.stopTest();
        
        system.assertEquals('usertestmail@testdata.com', userData.Email);
            
    }
}