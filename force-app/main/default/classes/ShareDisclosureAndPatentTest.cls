@isTest
public class ShareDisclosureAndPatentTest {
    public static testMethod void IDFShareTest(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Inventor'].Id,
            LastName = 'lasdst',
            Email ='eg@gmail.com',
            Username ='puser006ama@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'tistle',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        insert u;
        
        User uduplicate = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Inventor'].Id,
            LastName = 'lasdst',
            Email ='eg@gmail.com',
            Username ='puser006ama@mam.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'tistle',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        insert uduplicate;
        RecordType rcd = [SELECT Id FROM RecordType WHERE SObjectType = 'SymphonyIPM__Inventor__c' AND DeveloperName = 'Inventor' LIMIT 1];
        //RecordType rcd=[Select Id from RecordType where name='Inventor' limit 1];
        SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name='Jvr',SymphonyIPM__Email__c='eg@gmail.com',RecordTypeId=rcd.id,SymphonyIPM__User__c=u.id,SymphonyIPM__RecordTypeName__c ='Inventor');
        insert inventor;
        
        SymphonyIPM__Inventor__c inventor1 = new SymphonyIPM__Inventor__c(Name='JvrSana',SymphonyIPM__Email__c='fyz@gmail.com',RecordTypeId=rcd.id,SymphonyIPM__User__c=uduplicate.id,SymphonyIPM__RecordTypeName__c ='Inventor');
       
        insert inventor1;
        
        SymphonyIPM__Invention_Disclosure_New__c inv= new SymphonyIPM__Invention_Disclosure_New__c();
        inv.SymphonyIPM__Title__c ='Test disclosure';
        inv.SymphonyIPM__Primary_Inventor__c=inventor.id;
        insert inv;
        
        SymphonyIPM__Additional_Inventor__c objAdditionalInv = new SymphonyIPM__Additional_Inventor__c();
        objAdditionalInv.SymphonyIPM__Invention_Disclosure_New__c = inv.id;
        objAdditionalInv.SymphonyIPM__Inventor__c = inventor.id;
        INSERT objAdditionalInv;
        
       
        
        SymphonyIPM__Patent__c pat= new SymphonyIPM__Patent__c();
        pat.SymphonyIPM__Inventor__c = inventor1.id;
        pat.SymphonyIPM__Title_of_Invention__c ='tstt';
        pat.Name ='ds';
        insert pat;
        
        SymphonyIPM__Asset_Inventor_v1__c asset= new SymphonyIPM__Asset_Inventor_v1__c();
        asset.SymphonyIPM__Asset__c =pat.id;
        asset.SymphonyIPM__Inventor__c= inventor1.id;
        insert asset;
                
		inventor.SymphonyIPM__User__c = uduplicate.id;
        inventor1.SymphonyIPM__User__c = u.id;
        test.startTest();
        update inventor; 
        update inventor1; 
        test.stopTest();
        
        
    }
        
}