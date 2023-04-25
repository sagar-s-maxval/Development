@isTest
public class licenseRecyclingDetailsTest {    
    
    @testSetup
    public static void testSetup() {      
        
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
            setting.Number_of_Available_Licenses__c = 0;
            setting.Re_order_email__c = 'test@test.com';
            setting.Reorder_point__c = i*10;
            setting.Reorder_Quantity__c = 200;
            setting.Total_Number_of_Licences__c = 0;
            setting.Used_Licenses__c = 0.0; 
            licenseList.add(setting);
        }
        insert licenseList; 
      
    }
    
    
    static testMethod void createUser_AccountFound_CreateUserForExistingContact_PositiveCase1() {
       
       /* final String ACCOUNT_SUPPORT_ALIAS = 'accountSupportAlias';
        final String CONTACT_LAST_NAME = 'lastName';
        final String CONTACT_EMAIL = 'test@example.com'; */
        final Id samlSsoProviderId = '0LE000000000000';
        final Id communityId = null;
        final Id portalId = null;
        final String federationIdentifier = 'federationIdentifier';
        final String assertion = 'assertion';
        final Map<String, String> attributes = new Map<String, String>();
        //String jobId = System.schedule('ScheduleApexClassTest',  '0 0 0 15 3 ? *', new licenceRecyclingReorderOpScheduler());
        //user userData =UtilityTestDataClass.createUser('Radha',false);  
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        // user 
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
         LocaleSidKey = 'en_US',   
         UserRoleId = r.Id);
         insert userData;
        List<User> lstUser = new List<User>{userData};  
        Map<Id,Integer> mpLstLogin = new Map<Id,Integer>();
        mpLstLogin.put(userData.id,2);
        
        attributes.put('User.Username','axiomsuser5@test.com');
        //attributes.put('User.FederationIdentifier',federationIdentifier);
        attributes.put('User.Phone','9090909090');
        attributes.put('User.Email', 'usertest@salesforce.com');
        attributes.put('User.FirstName','Firstname');
        attributes.put('User.LastName','LAstname');
        attributes.put('User.Title','title');
        attributes.put('User.CompanyName','CompanyName');
        attributes.put('User.AboutMe','AboutMe');
        attributes.put('User.Street','Street'); 
        attributes.put('User.State','State');
        attributes.put('User.City','City');
        attributes.put('User.Zip','324758');
        attributes.put('User.Country','Country');
        attributes.put('User.CallCenter',null);
        attributes.put('User.MobilePhone','9584756384');
        attributes.put('User.Department','Department Value');
        attributes.put('User.Division','Division Value');
        attributes.put('User.EmployeeNumber','84395830282');
        attributes.put('User.Extension','1232435462');
        attributes.put('User.Fax','42345343');      
        attributes.put('User.ReceivesAdminInfoEmails','test123@test12.com');
        attributes.put('User.ReceivesInfoEmails','test@test12.com');
        //attributes.put('User.Alias','FLast');
        attributes.put('User.IsActive','true');
        attributes.put('User.ProfileId','Platform Inventor');
        attributes.put('User.UserRoleId','CEO');
        attributes.put('User.CommunityNickname','test');
        attributes.put('User.ForecastEnabled','false');
        
        Test.startTest();
        String profileVal = 'Platform Inventor';
        Set<Id> usrIds = New Set<Id>();
        for(user u : lstUser)
        {
            usrIds.add(u.id);
        }
        licenseRecyclingDetails lrd = New licenseRecyclingDetails();
        licenseRecyclingDetails.getUserList(profileVal,usrIds);
        licenseRecyclingDetails.getLastLoginDetails(profileVal);
        Test.stopTest();
        
    }
    
    static testMethod void createUser_AccountFound_CreateUserForExistingContact_PositiveCase2() {
         
        final Id samlSsoProviderId = '0LE000000000000';
        final Id communityId = null;
        final Id portalId = null;
        final String federationIdentifier = 'federationIdentifier';
        final String assertion = 'assertion';
        final Map<String, String> attributes = new Map<String, String>();
        //String jobId = System.schedule('ScheduleApexClassTest',  '0 0 0 15 3 ? *', new licenceRecyclingReorderOpScheduler());

        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        // user 
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
         LocaleSidKey = 'en_US',
         UserRoleId = r.Id
         );
         insert userData;        
        attributes.put('User.Username','axiomsuser5@test.com');
        attributes.put('User.FederationIdentifier',federationIdentifier);
        attributes.put('User.Phone','9090909090');
        attributes.put('User.Email', 'usertest@salesforce.com');
        attributes.put('User.FirstName',null);
        attributes.put('User.LastName','LAstname');
        attributes.put('User.Title','title');
        attributes.put('User.CompanyName','CompanyName');
        attributes.put('User.AboutMe','AboutMe');
        attributes.put('User.Street','Street'); 
        attributes.put('User.State','State');
        attributes.put('User.City','City');
        attributes.put('User.Zip','324758');
        attributes.put('User.Country','Country');
        attributes.put('User.CallCenter',null);
        attributes.put('User.MobilePhone','9584756384');
        attributes.put('User.Department','Department Value');
        attributes.put('User.Division','Division Value');
        attributes.put('User.EmployeeNumber','84395830282');
        attributes.put('User.Extension','1232435462');
        attributes.put('User.Fax','42345343');      
        attributes.put('User.ReceivesAdminInfoEmails','test123@test12.com');
        attributes.put('User.ReceivesInfoEmails','test@test12.com');
        attributes.put('User.Alias','FLast');
        attributes.put('User.IsActive','true');
        attributes.put('User.ProfileId','Platform Inventor');
        attributes.put('User.UserRoleId','CEO');
        attributes.put('User.CommunityNickname','test');   
        attributes.put('User.LocaleSidKey','en_US');
        attributes.put('User.LanguageLocaleKey','en_US');
        attributes.put('User.TimeZoneSidKey','GMT');
        attributes.put('User.EmailEncodingKey','ISO-8859-1');
        attributes.put('User.ForecastEnabled','false');
        
        
        Test.startTest();
        list<User> lstUser = [SELECT Id,Isactive FROM User WHERE IsActive=True];
        String profileVal = 'Platform Inventor';
        Set<Id> usrIds = New Set<Id>();
        for(user u : lstUser)
        {
            usrIds.add(u.id);
        }
        licenseRecyclingDetails lrd = New licenseRecyclingDetails();
        licenseRecyclingDetails.getUserList(profileVal,usrIds);
        licenseRecyclingDetails.getLastLoginDetails(profileVal);
        Test.stopTest();
    }
}