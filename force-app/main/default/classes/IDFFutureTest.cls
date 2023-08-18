@isTest
public class IDFFutureTest {
    @istest
    public static void met1(){
        test.startTest();
        /*User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Inventor'].Id,
            LastName = 'last',
            Email ='abc@gmail.com',
            Username ='puser0067@amamama@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        insert u;
       
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Reviewer'].Id,
            LastName = 'reviewer321',
            Email ='abciop123@gmail.com',
            Username ='puser0067@amamama@amamamamam.com.tes' + System.currentTimeMillis(),
            CompanyName = 'TEST432123',
            Title = 'title12543',
            Alias = 'alias341',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US',
IsActive = true);
        insert u1;

        User u2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Inventor'].Id,
            LastName = 'last2',
            Email ='abc2@gmail.com',
            Username ='puser00672@amamama@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'title2',
            Alias = 'alias2',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        insert u2;

User u3 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'In-house Counsel'].Id,
            LastName = 'last3',
            Email ='abc3@gmail.com',
            Username ='puser00673@amamama@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'title3',
            Alias = 'alias3',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        insert u3;
        
        User u4 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'In-house Counsel'].Id,
            LastName = 'addinvuser',
            Email ='abc3@gmail.com',
            Username ='puser00673@amamama@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'title3',
            Alias = 'alias3',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        insert u4;
RecordType rTypeInventor = [SELECT Id FROM RecordType WHERE sObjectType = 'SymphonyIPM__Inventor__c' AND Name = 'Inventor'];
        SymphonyIPM__Inventor__c objInventor = new SymphonyIPM__Inventor__c();
        objInventor.RecordTypeId=rTypeInventor.id;
        objInventor.Name = 'Test Inventor';
        objInventor.SymphonyIPM__Email__c = 'testinventor@test.com';
        objInventor.SymphonyIPM__User__c =u.id;
        INSERT objInventor;
       
        SymphonyIPM__Inventor__c objInventor1 = new SymphonyIPM__Inventor__c();
        objInventor1.RecordTypeId=rTypeInventor.id;
        objInventor1.Name = 'Test Inventor1';
        objInventor1.SymphonyIPM__Email__c = 'testinventor@test.com';
        objInventor1.SymphonyIPM__User__c =u.id;
        INSERT objInventor1;

SymphonyIPM__Inventor__c objInventor2 = new SymphonyIPM__Inventor__c();
        objInventor2.Name = 'Test Inventor2';
        objInventor2.SymphonyIPM__Email__c = 'testinventor2@test.com';
        objInventor2.SymphonyIPM__User__c =u2.id;
        INSERT objInventor2;
       
   SymphonyIPM__Law_Firm__c objlawfirm = new SymphonyIPM__Law_Firm__c();
objlawfirm.Name = 'Law firm';
INSERT objlawfirm;
 
SymphonyIPM__Inventor__c objInventor3 = new SymphonyIPM__Inventor__c();
        objInventor3.Name = 'Test Inventor3';
        objInventor3.SymphonyIPM__Email__c = 'testinventor2@test.com';
        objInventor3.SymphonyIPM__User__c =u3.id;
objInventor3.SymphonyIPM__Law_Firm__c =objlawfirm.id;
        INSERT objInventor3;
        
        SymphonyIPM__Inventor__c objInventor4 = new SymphonyIPM__Inventor__c();
        objInventor4.RecordTypeId=rTypeInventor.id;
        objInventor4.Name = 'Add_Inv';
        objInventor4.SymphonyIPM__Email__c = 'additionalinventor@test.com';
        objInventor4.SymphonyIPM__User__c =u4.id;
        INSERT objInventor4;
        
       
 
        SymphonyIPM__Hierarchy__c path = new SymphonyIPM__Hierarchy__c();
        path.name = 'Test Path123';
        INSERT path;
       
        SymphonyIPM__Hierarchy__c path1 = new SymphonyIPM__Hierarchy__c();
        path1.name = 'Test123 Path123';
        INSERT path1;
       
        SymphonyIPM__Hierarchy_Role__c Hierarchyrole1 = new SymphonyIPM__Hierarchy_Role__c();
        Hierarchyrole1.SymphonyIPM__User__c = u1.id;
        Hierarchyrole1.SymphonyIPM__Hierarchy_Path__c= path.id;
Hierarchyrole1.SymphonyIPM__isPrimary__c = true;
Hierarchyrole1.SymphonyIPM__Role__c ='UHG IP Legal';
        insert Hierarchyrole1;

SymphonyIPM__Hierarchy_Role__c Hierarchyrole = new SymphonyIPM__Hierarchy_Role__c();
        Hierarchyrole.SymphonyIPM__User__c = u3.id;
        Hierarchyrole.SymphonyIPM__Hierarchy_Path__c= path1.id;
        insert Hierarchyrole;

SymphonyIPM__Invention_Disclosure_New__c objInventionDisclosure = new SymphonyIPM__Invention_Disclosure_New__c();
        objInventionDisclosure.SymphonyIPM__Title__c = 'Test IDF132';
        //objInventionDisclosure.PRB_Decision__c = 'IOT';
objInventionDisclosure.SymphonyIPM__Primary_Inventor__c= objInventor.id;
        objInventionDisclosure.SymphonyIPM__Hierarchy__c = path.id;
        objInventionDisclosure.Primary_Contact__c=objInventor.id;
         objInventionDisclosure.MentorsIDs__c=objInventor4.id;
        INSERT objInventionDisclosure;
        
        String myJSON_Old = JSON.serialize(objInventionDisclosure);
       SymphonyIPM__Patent__c pat= new SymphonyIPM__Patent__c();
        pat.SymphonyIPM__Inventor__c = objInventor.id;
        pat.SymphonyIPM__Title_of_Invention__c ='tstt';
        pat.Name ='ds';
        insert pat;
        
        objInventionDisclosure.SymphonyIPM__Primary_Inventor__c= objInventor1.id;
        objInventionDisclosure.SymphonyIPM__Hierarchy__c = path1.id;
        objInventionDisclosure.SymphonyIPM__Related_Patent__c=pat.Id;
        objInventionDisclosure.Law_Firm__c = objlawfirm.Id;
        objInventionDisclosure.Other_Contact__c = objInventor4.Id;
        update objInventionDisclosure;*/
        
        IDFFuture.dummyMethod();
        test.stopTest();
    }
}