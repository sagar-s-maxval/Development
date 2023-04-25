@istest
public class inventionDisclosureRolesTgrTest {
     @IsTest(SeeAllData = true)
     public static  void test1(){
         Profile p = [SELECT Id FROM Profile WHERE Name='In-house Counsel'];
        User u = new User(Alias = 'standt', Email='testuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='newuser008@testorg.com');
        insert u;
         SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name='Test Inventor', SymphonyIPM__Employee_ID__c='12345',SymphonyIPM__User__c=u.id);
    insert inventor;
        list<User> lstusr =[select Id, firstname, lastname, email,FederationIdentifier, Profile.Name from user where ProfileId!=NUll AND FederationIdentifier!=Null];
        set<Id>UserId = New set<Id>();
        string usrId;
         string fedId;
        for(User usr : lstusr)
        {
            UserId.add(usr.id);
            fedId = usr.FederationIdentifier;
            usrId = usr.Id;
            
        }
          SymphonyIPM__Inventor__c per= [SELECT User_Id__c FROM SymphonyIPM__Inventor__c WHERE name like '%system%' limit 1];
        SymphonyIPM__Inventor__c Inv = New SymphonyIPM__Inventor__c();
        Inv.Name='Test Name';
        inv.SymphonyIPM__CitizenshipPicklist__c='None';
        inv.SymphonyIPM__Location__c='None';
        inv.SymphonyIPM__Email__c='test@testmail.com';
        inv.SymphonyIPM__RecordTypeName__c='In house Counsel';
        inv.RecordTypeId='0124W000000SElXQAW';
        Insert Inv;
        inv.SymphonyIPM__User__c = usrId;
        update Inv;
      
         SymphonyIPM__Invention_Disclosure_New__c idf = new SymphonyIPM__Invention_Disclosure_New__c(Name = 'Test', SymphonyIPM__Title__c = 'Test');
        insert idf;
        SymphonyIPM__Inventor__c person=[select id from SymphonyIPM__Inventor__c limit 1];
         SymphonyIPM__Inventor__c primary = new SymphonyIPM__Inventor__c(Name = 'Test Inventor', SymphonyIPM__Email__c = 'test1@test.com');
        insert primary;
        Invention_Disclosure_Role__c invrole = new Invention_Disclosure_Role__c();
        invrole.Invention_Disclosure__c=idf.id;
        invrole.Person__c=per.id;
        invrole.Role__c='IP Responsible Manager';
        insert invrole;
        
        Invention_Disclosure_Role__c invrole2 = new Invention_Disclosure_Role__c();
        invrole2.Invention_Disclosure__c=idf.id;
        invrole2.Person__c=per.id;
        invrole2.Role__c='IP Partner';
        insert invrole2;
        Invention_Disclosure_Role__c invrole3 = new Invention_Disclosure_Role__c();
        invrole3.Invention_Disclosure__c=idf.id;
        invrole3.Person__c=per.id;
        invrole3.Role__c='Docketing';
        insert invrole3;
       
             Delete invrole;
        
       
        
        
        
    }
    
     @IsTest
    static void test2() {
        inventionDisclosureRolesTriggerHelper.magicMethod();
    }

}