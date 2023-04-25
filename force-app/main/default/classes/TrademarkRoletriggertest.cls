@istest
public class TrademarkRoletriggertest {

    public static testMethod void test1(){
         Profile p = [SELECT Id FROM Profile WHERE Name='Platform Inventor'];
        User u = new User(Alias = 'standt', Email='testuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='newuser008@testorg.com');
        insert u;
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
        inv.SymphonyIPM__RecordTypeName__c='In house Counsel';
        inv.RecordTypeId='0124W000000SElXQAW';
        Insert Inv;
        inv.SymphonyIPM__User__c = usrId;
        update Inv;
         SymphonyIPM__Inventor__c Inv2 = New SymphonyIPM__Inventor__c();
        Inv2.Name='Test Name';
        inv2.SymphonyIPM__CitizenshipPicklist__c='None';
        inv2.SymphonyIPM__Location__c='None';
        inv2.SymphonyIPM__Email__c='test@testmail.com';
        inv2.SymphonyIPM__RecordTypeName__c='In house Counsel';
        inv2.RecordTypeId='0124W000000SElXQAW';
        Insert Inv2;
        inv2.SymphonyIPM__User__c = usrId;
        update Inv2;
      //  SymphonyIPM__Invention_Disclosure_New__c idf1 = New SymphonyIPM__Invention_Disclosure_New__c();
     //   idf1.SymphonyIPM__Primary_Inventor__c=inv.id;
      //   idf1.SymphonyIPM__Primary_Inventor__c=inv.id;
     //   idf1.SymphonyIPM__Internal_Counsel__c=usrId;
       // insert idf1;
         SymphonyIPM__Trademark_New__c idf1 = new SymphonyIPM__Trademark_New__c(Name = 'Test');
        SymphonyIPMExt__Dispute_Opposition__c diso = new SymphonyIPMExt__Dispute_Opposition__c();
        insert idf1;
        insert diso;
        SymphonyIPM__Law_Firm__c LawFirm = new SymphonyIPM__Law_Firm__c(Name ='LLB');
        insert LawFirm;
        SymphonyIPM__Inventor__c person=[select id from SymphonyIPM__Inventor__c limit 1];
         SymphonyIPM__Inventor__c primary = new SymphonyIPM__Inventor__c(Name = 'Test Inventor', SymphonyIPM__Email__c = 'test1@test.com');
        insert primary;
        Trademark_Role__c invrole = new Trademark_Role__c();
        Dispute_Opposition_Role__c disrole = new Dispute_Opposition_Role__c(Trademark_Role__c='TM IP Paralegal');
        invrole.Trademark__c=idf1.id;
        disrole.Dispute_Opposition__c =diso.id;
        system.debug(person.id);
        invrole.Person__c=person.id;
        disrole.Person__c=person.id;
        invrole.Role__c='IP Responsible Manager';
        disrole.Role__c='IP Responsible Manager';
        insert invrole;
        insert disrole;
        
  
        Trademark_Role__c invrole2 = new Trademark_Role__c();
         Dispute_Opposition_Role__c disrole2 = new Dispute_Opposition_Role__c();
        invrole2.Trademark__c=idf1.id;
        disrole2.Dispute_Opposition__c=diso.id;
        system.debug(person.id);
        invrole2.Person__c=person.id;
        disrole2.Person__c=person.id;
        invrole2.Role__c='Outside Counsel Firm';
        disrole2.Role__c='Outside Counsel Firm';
        insert invrole2;
        insert disrole2;
        Delete invrole;
        delete disrole2;
        SymphonyIPM__Inventor__c per = new SymphonyIPM__Inventor__c();
        insert per;
        SymphonyIPM__Inventor__c per4 = new SymphonyIPM__Inventor__c();
        insert per4;
        SymphonyIPM__Inventor__c per6 = new SymphonyIPM__Inventor__c();
        insert per6;
        SymphonyIPMExt__Dispute_Opposition__c disoo = new SymphonyIPMExt__Dispute_Opposition__c(); 
        insert disoo;
        Dispute_Opposition_Role__c disr = new Dispute_Opposition_Role__c(Dispute_Opposition__c=disoo.id,Trademark_Role__c='TM IP Paralegal',Person__c=per.id);
        insert disr;
       
         Dispute_Opposition_Role__c disr1 = new Dispute_Opposition_Role__c(Dispute_Opposition__c=disoo.id,Trademark_Role__c='TM IP Paralegal',Person__c=per.id);
        insert disr1;
        Dispute_Opposition_Role__c disr2 = new Dispute_Opposition_Role__c(Dispute_Opposition__c=disoo.id,Trademark_Role__c='CN TM Attorney 1',Person__c=per.id);
        insert disr2;
        disr2.Trademark_Role__c='CN TM Attorney 2';
        update disr2;
        Dispute_Opposition_Role__c disr3 = new Dispute_Opposition_Role__c(Dispute_Opposition__c=disoo.id,Trademark_Role__c='CN TM Attorney 1',Person__c=per.id);
        insert disr3;  
         Dispute_Opposition_Role__c disr5 = new Dispute_Opposition_Role__c(Dispute_Opposition__c=disoo.id,Trademark_Role__c='CN TM Attorney 2',Person__c=per4.id);
        insert disr5; 
        Dispute_Opposition_Role__c disr4 = new Dispute_Opposition_Role__c(Dispute_Opposition__c=disoo.id,Trademark_Role__c='CN TM Attorney 1',Person__c=per4.id);
        insert disr4;
         Dispute_Opposition_Role__c disr6 = new Dispute_Opposition_Role__c(Dispute_Opposition__c=disoo.id,Trademark_Role__c='TM IP Associate 1',Person__c=per6.id);
        insert disr6;
        Dispute_Opposition_Role__c disr7 = new Dispute_Opposition_Role__c(Dispute_Opposition__c=disoo.id,Trademark_Role__c='Outside Counsel Firm',Person__c=per6.id);
        insert disr7;
        Dispute_Opposition_Role__c disr8 = new Dispute_Opposition_Role__c(Dispute_Opposition__c=disoo.id,Trademark_Role__c='Agent',Person__c=per6.id);
        insert disr8;
        disr6.Trademark_Role__c='TM IP Associate 2';
        update disr6;
        disr6.Trademark_Role__c='TM Docketer';
        update disr6;
        disr6.Trademark_Role__c='TM IP Responsible Manager';
        update disr6;
        disr6.Trademark_Role__c='Agent';
        update disr6;
        disr6.Trademark_Role__c='TM IP Partner';
        update disr6;
        disr6.Trademark_Role__c='Outside Counsel Firm';
        update disr6;
        delete disr4;
        
        
       
       
        
    }
    
}