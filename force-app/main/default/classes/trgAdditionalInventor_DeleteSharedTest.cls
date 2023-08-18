@isTest
public class trgAdditionalInventor_DeleteSharedTest {

   @TestSetup 
    public static void TestData(){
        
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
     //RecordType rcd = [SELECT Id FROM RecordType WHERE SObjectType = 'SymphonyIPM__Inventor__c' AND DeveloperName = 'Inventor' LIMIT 1];
     RecordType rcd = [SELECT Id FROM RecordType WHERE sObjectType = 'SymphonyIPM__Inventor__c' AND Name = 'Inventor'];
    SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name='JvrSana',SymphonyIPM__Email__c='fzzzz@gmail.com',RecordTypeId=rcd.id,SymphonyIPM__User__c=u.id,SymphonyIPM__RecordTypeName__c ='Inventor');
       
        insert inventor;
        
        SymphonyIPM__Invention_Disclosure_New__c inv= new SymphonyIPM__Invention_Disclosure_New__c();
        inv.SymphonyIPM__Title__c ='Test disclosure';
        inv.SymphonyIPM__Primary_Inventor__c=inventor.id;
        insert inv;
        
        SymphonyIPM__Additional_Inventor__c objAdditionalInv = new SymphonyIPM__Additional_Inventor__c();
        objAdditionalInv.SymphonyIPM__Invention_Disclosure_New__c = inv.id;
        objAdditionalInv.SymphonyIPM__Inventor__c = inventor.id;
        INSERT objAdditionalInv;
        SymphonyIPM__Additional_Inventor__c objAdditionalInv1 = new SymphonyIPM__Additional_Inventor__c();
        objAdditionalInv1.SymphonyIPM__Invention_Disclosure_New__c = inv.id;
        objAdditionalInv1.SymphonyIPM__Inventor__c = inventor.id;
        INSERT objAdditionalInv1;
        delete objAdditionalInv;
    }
     @isTest public static  void Meth1(){
        SymphonyIPM__Additional_Inventor__c idf =[Select id from SymphonyIPM__Additional_Inventor__c limit 1];

     }
}