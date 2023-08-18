@isTest 
public class createInventorTest
{
   /* public static testMethod void createInventorTestMethod()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Platform Inventor'];
        User u = new User(Alias = 'standt', Email='testuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='newuser008@testorg.com');
        //insert u;
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
        
        SymphonyIPM__Inventor__c Inv = New SymphonyIPM__Inventor__c();
        Inv.Name='Test Name';
        inv.SymphonyIPM__CitizenshipPicklist__c='None';
        inv.SymphonyIPM__Location__c='None';
        inv.SymphonyIPM__Email__c='test@testmail.com';
        inv.EID__c=fedId;
        inv.SymphonyIPM__RecordTypeName__c='Inventor';
        Insert Inv;
        inv.SymphonyIPM__User__c = usrId;
        update Inv;
        //System.AssertEquals(Inv.Name,'Inventorperson');
        
        createInventor ci = New createInventor();
        createInventor.createInventorRecord(UserId);
    }
    public static testMethod void createInventorTestMethod1()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Platform Inventor'];
        User u = new User(Alias = 'standt', Email='testuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='newuser008@testorg.com');
        insert u;
        list<User> lstusr =[select Id, firstname, lastname, email,FederationIdentifier, Profile.Name from user where ProfileId!=NUll AND FederationIdentifier!=Null];
        set<Id>UserId = New set<Id>();
        for(User usr : lstusr)
        {
            UserId.add(usr.id);
           
        }
        
        SymphonyIPM__Inventor__c Inv = New SymphonyIPM__Inventor__c();
        Inv.Name='Test Name';
        inv.SymphonyIPM__CitizenshipPicklist__c='None';
        inv.SymphonyIPM__Location__c='None';
        inv.SymphonyIPM__Email__c='test@testmail.com';
        //inv.EID__c=;
        //inv.SymphonyIPM__User__c = u.id;
        //Insert Inv;
        //System.AssertEquals(Inv.Name,'Inventorperson');
        
        createInventor ci = New createInventor();
        createInventor.createInventorRecord(UserId);
    }*/
    public static testMethod void createInventorTestMethod2()
    {
        profile p=[SELECT Id FROM Profile WHERE Name = 'Platform Inventor'];
User u = new User(
     ProfileId = p.Id,
     LastName = 'lastINV',
     FirstName = 'FirstINV',
     Email = 'jayaram@maxval.com',
     Username = 'puser0lkm00@amamama.com',
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     IsActive = false,
     LocaleSidKey = 'en_US');
     insert u;
     User u1 = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'In-house Counsel'].Id,
     LastName = 'lastIC',
     FirstName = 'FirstIC',
     Email = 'arun@maxval.com',
     Username = 'puser0aaa3q300@amamama.com',
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US');
     insert u1;   
     /*  SymphonyIPM__Inventor__c inv1=new SymphonyIPM__Inventor__c();
       inv1.Name='test1';
       inv1.EID__c='6737';
       inv1.Home_Country__c='abca';
       inv1.SymphonyIPM__RecordTypeName__c='In-house Counsel'; 
       inv1.SymphonyIPM__Email__c='abc@a.com'; 
       inv1.SymphonyIPM__User__c=u.id; 
       insert inv1; */
        user u5=[select id from user where id=:UserInfo.getUserId()];
        system.runas(u5){
       SymphonyIPM__Inventor__c inv=new SymphonyIPM__Inventor__c();
       inv.Name='FirstINV lastINV';
            inv.First_Name__c = 'FirstINV';
            inv.Last_Name__c = 'lastINV';
            inv.Nick_Name__c = 'test';
       inv.EID__c=u.FederationIdentifier;
      // inv.Home_Country__c='Canada';
       inv.SymphonyIPM__RecordTypeName__c='Inventor';
       //inv.Supervisor_EID__c='9000'; 
       inv.SymphonyIPM__Employee_ID__c='899'; 
      // inv.Reporting_IC__c='abc@a.com';
       inv.SymphonyIPM__User__c=u.id; 
       insert inv; 
        list<SymphonyIPM__Inventor__c> lst1 =new list<SymphonyIPM__Inventor__c>();
        lst1.add(inv);
        List<SymphonyIPM__Invention_Disclosure_New__c> lst=new list<SymphonyIPM__Invention_Disclosure_New__c>();
       SymphonyIPM__Invention_Disclosure_New__c idf = New SymphonyIPM__Invention_Disclosure_New__c();
        //idf.SymphonyIPM__Primary_Inventor__c=inv.id;
       // idf.Product_Name__c='CreditWise';
       // idf.Project_Name__c='Conversational AI (Eno) - (low volume)';
        idf.SymphonyIPM__Primary_Inventor__c=inv.id;
        idf.SymphonyIPM__Internal_Counsel__c=u1.id;
        lst.add(idf);
        /*SymphonyIPM__Invention_Disclosure_New__c idf1 = New SymphonyIPM__Invention_Disclosure_New__c();
        idf1.SymphonyIPM__Primary_Inventor__c=inv.id;
        idf1.Product_Name__c='CreditWise';
        idf1.Project_Name__c='Conversational AI (Eno) - (low volume)';
        idf1.SymphonyIPM__Primary_Inventor__c=inv.id;
        idf1.SymphonyIPM__Internal_Counsel__c=u1.id;
        lst.add(idf1);*/
        try{
            insert lst;
        }catch(Exception e){}
        list<User> lstusr =[select Id, firstname, lastname, email,FederationIdentifier, Profile.Name from user where ProfileId!=NUll AND FederationIdentifier!=Null];
        set<Id>UserId = New set<Id>();
        for(User usr : lstusr)
        {
            UserId.add(usr.id);
           
        }
        createInventor ci = New createInventor();
        createInventor.createInventorRecord(UserId);
        createInventor.CreateShareRecords(lst1);
            u.IsActive = true;
            UPDATE u;
            createInventor.shareInventionDisclosure(new set<Id>{u.id}, new set<Id>{inv.id});
            createInventor.sharePatent(new set<Id>{u.id}, new set<Id>{inv.id});
            createInventor.shareInventorAwards(new set<Id>{u.id}, new set<Id>{inv.id});
        createInventor.CalcSSO(1);     
        }
    }
}