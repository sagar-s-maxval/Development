@isTest
public class tgrUserTest1{
    @isTest
 public static void tgrUserTestMethod()
    {       
       
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Platform Inventor'];
        User u1 = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p1.Id,isActive=true,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='newuser8822992@testorg.com');
        insert u1;
         user u5=[select id,LastName from user where id=:u1.id]; 
        u5.isActive=true;
        update u5; 
        
         Profile p = [SELECT Id FROM Profile WHERE Name='In-house Counsel'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='newuser68436569@testorg.com');
        insert u;
       
        User thisUser = [ select Id from User where Id = :u1.id ];
    System.runAs ( thisuser) {
           test.starttest();
          RecordType rt=[select id,Name from RecordType where SobjectType='SymphonyIPM__Inventor__c' AND Name='Inventor' limit 1];
           SymphonyIPM__Inventor__c inv1=new SymphonyIPM__Inventor__c();
           inv1.Name='test1';
           //inv1.EID__c='6737';
          // inv1.Home_Country__c='abca';
           inv1.SymphonyIPM__Email__c='abc@a.com'; 
           inv1.SymphonyIPM__User__c=u1.id; 
          // inv1.SymphonyIPM__RecordTypeName__c='Inventor';
           inv1.RecordTypeId=rt.id;
           insert inv1;
          /* IC_Routing__c icr = New IC_Routing__c();
           icr.Name ='IC_Routing';
           icr.Email__c='test2474654@text.com';
           icr.Order_Of_IC__c=1;
           insert icr; 
           
           IC_Routing__c ic = New IC_Routing__c();
           ic.Name ='IC_Routing';
           ic.Email__c='test24746a54@text.com';
           ic.Order_Of_IC__c=2;
           insert ic; */
           
           
          List<SymphonyIPM__Invention_Disclosure_New__c> lst=new list<SymphonyIPM__Invention_Disclosure_New__c>();
           SymphonyIPM__Invention_Disclosure_New__c idf = New SymphonyIPM__Invention_Disclosure_New__c();
            idf.SymphonyIPM__Disclosure_State__c = 'Not Applicable';
            idf.SymphonyIPM__Primary_Inventor__c=inv1.id;
            idf.SymphonyIPM__Internal_Counsel__c=u.id;
            insert idf;
    
        /*     trgUserHandler th = new trgUserHandler();
           SymphonyIPM__Additional_Inventor__c ai = New SymphonyIPM__Additional_Inventor__c();
           ai.SymphonyIPM__Invention_Disclosure_New__c=idf.id;
           ai.SymphonyIPM__Inventor__c=inv1.id;
           ai.SymphonyIPM__Inventor_Email__c='test@testmail.com';
           ai.SymphonyIPM__shared__c=True;
           Insert ai;
           
        
        
        SymphonyIPM__Patent__c ast = new SymphonyIPM__Patent__c();
        ast.SymphonyIPM__Application_Number__c='01234';
        ast.SymphonyIPM__Application_Type__c='Reissue';
        ast.SymphonyIPM__Attorney_Docket_Number__c='test1234';
        ast.SymphonyIPM__Internal_Counsel__c=u.id;
        ast.SymphonyIPM__Confirmation_Number__c=1234567890;
        ast.SymphonyIPM__Earliest_Publication_Date__c=Date.valueOf('2008-08-10');
        ast.SymphonyIPM__Earliest_Publication_No__c='test1234';
        ast.SymphonyIPM__Examiner_Name__c='testuser';
        ast.SymphonyIPM__First_Named_Inventor__c=inv1.id;
        ast.SymphonyIPM__Application_Date__c=Date.valueOf('2004-08-10');
        ast.SymphonyIPM__Group_Art_Unit__c=1234567890;
        ast.SymphonyIPM__Location__c='India';
        ast.SymphonyIPM__Patent_Number__c='0123456789123456';
        ast.SymphonyIPM__Issue_Date_of_Patent__c=Date.valueOf('2011-08-10');
        ast.SymphonyIPM__Title_of_Invention__c='mobile phone';
        //ast.SymphonyIPM__First_Named_Inventor__c=iv.id;
        insert ast;
        
        SymphonyIPM__Patent__share patshare = new SymphonyIPM__Patent__share();
        patshare.ParentId=ast.id;
        patshare.UserOrGroupId=u.id;
        patshare.AccessLevel='Edit';
        insert patshare;
        
        SymphonyIPM__Asset_Inventor_v1__c Avi = New SymphonyIPM__Asset_Inventor_v1__c();
        avi.SymphonyIPM__Asset__c = ast.id;
        avi.SymphonyIPM__Inventor__c = inv1.id;
        insert avi;
           
           system.assert(true); */
           
           test.stoptest();
    }
   }
    @isTest
   public static void tgrUserTestMethod2()
    {       
       
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Platform Inventor'];
        User u1 = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p1.Id,isActive=false,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='newuser8822992@testorg.com');
        insert u1;
         user u5=[select id,LastName,isActive from user where id=:u1.id]; 
        u5.isActive=true;
        update u5; 
       
         Profile p = [SELECT Id FROM Profile WHERE Name='In-house Counsel'];
        User u11 = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='newuser68436569@testorg.com');
        insert u11;
        
        
        User thisUser = [ select Id from User where Id = :u1.id ];
    System.runAs ( thisuser) {
           test.starttest();
          RecordType rt=[select id,Name from RecordType where SobjectType='SymphonyIPM__Inventor__c' AND Name='Inventor' limit 1];
           SymphonyIPM__Inventor__c inv1=new SymphonyIPM__Inventor__c();
           inv1.Name='test1';
           //inv1.EID__c='6737';
           //inv1.Home_Country__c='abca';
           inv1.SymphonyIPM__Email__c='abc@a.com'; 
           inv1.SymphonyIPM__User__c=u1.id; 
          // inv1.SymphonyIPM__RecordTypeName__c='Inventor';
           inv1.RecordTypeId=rt.id;
           insert inv1;
          /* IC_Routing__c icr = New IC_Routing__c();
           icr.Name ='IC_Routing';
           icr.Email__c='test2474654@text.com';
           icr.Order_Of_IC__c=1;
           insert icr; 
           
           IC_Routing__c ic = New IC_Routing__c();
           ic.Name ='IC_Routing';
           ic.Email__c='test24746a54@text.com';
           ic.Order_Of_IC__c=2;
           insert ic; */
           
           
            List<SymphonyIPM__Invention_Disclosure_New__c> lst=new list<SymphonyIPM__Invention_Disclosure_New__c>();
           SymphonyIPM__Invention_Disclosure_New__c idf = New SymphonyIPM__Invention_Disclosure_New__c();
            idf.SymphonyIPM__Disclosure_State__c = 'Not Applicable';
            idf.SymphonyIPM__Primary_Inventor__c=inv1.id;
            idf.SymphonyIPM__Internal_Counsel__c=u11.id;
            insert idf;
    
         /*  trgUserHandler th = new trgUserHandler();
           SymphonyIPM__Additional_Inventor__c ai = New SymphonyIPM__Additional_Inventor__c();
           ai.SymphonyIPM__Invention_Disclosure_New__c=idf.id;
           ai.SymphonyIPM__Inventor__c=inv1.id;
           ai.SymphonyIPM__Inventor_Email__c='test@testmail.com';
           ai.SymphonyIPM__shared__c=True;
           Insert ai;
           
        
        
        SymphonyIPM__Patent__c ast = new SymphonyIPM__Patent__c();
        ast.SymphonyIPM__Application_Number__c='01234';
        ast.SymphonyIPM__Application_Type__c='Reissue';
        ast.SymphonyIPM__Attorney_Docket_Number__c='test1234';
        ast.SymphonyIPM__Internal_Counsel__c=u.id;
        ast.SymphonyIPM__Confirmation_Number__c=1234567890;
        ast.SymphonyIPM__Earliest_Publication_Date__c=Date.valueOf('2008-08-10');
        ast.SymphonyIPM__Earliest_Publication_No__c='test1234';
        ast.SymphonyIPM__Examiner_Name__c='testuser';
        ast.SymphonyIPM__First_Named_Inventor__c=inv1.id;
        ast.SymphonyIPM__Application_Date__c=Date.valueOf('2004-08-10');
        ast.SymphonyIPM__Group_Art_Unit__c=1234567890;
        ast.SymphonyIPM__Location__c='India';
        ast.SymphonyIPM__Patent_Number__c='0123456789123456';
        ast.SymphonyIPM__Issue_Date_of_Patent__c=Date.valueOf('2011-08-10');
        ast.SymphonyIPM__Title_of_Invention__c='mobile phone';
        //ast.SymphonyIPM__First_Named_Inventor__c=iv.id;
        insert ast;
        
        SymphonyIPM__Patent__share patshare = new SymphonyIPM__Patent__share();
        patshare.ParentId=ast.id;
        patshare.UserOrGroupId=u.id;
        patshare.AccessLevel='Edit';
        insert patshare;
        
        SymphonyIPM__Asset_Inventor_v1__c Avi = New SymphonyIPM__Asset_Inventor_v1__c();
        avi.SymphonyIPM__Asset__c = ast.id;
        avi.SymphonyIPM__Inventor__c = inv1.id;
        insert avi;
           
           system.assert(true); */
           
           test.stoptest();
    }
   }
}