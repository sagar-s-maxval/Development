@isTest
public class ShareDiscosureWithOutsideCounselTest
{
    @isTest
   public static void test1()
   {
      Test.startTest(); 
   SymphonyIPM__Law_Firm__c LF = new SymphonyIPM__Law_Firm__c();
   LF.Name = 'TestLF1';
   insert LF;
       
       SymphonyIPM__Law_Firm__c LFnew = new SymphonyIPM__Law_Firm__c();
   LFnew.Name = 'TestLFnew1';
   insert LFnew;
    
   Profile prof1 = [SELECT Id,Name FROM Profile where name = 'Platform Outside Counsel'];
   id prof = prof1.id;
       
     user ui = [select id, name from user where ProfileId =:prof and isactive=true limit 1];  
       
       Id devRecordTypeId = Schema.SObjectType.SymphonyIPM__Inventor__c.getRecordTypeInfosByName().get('Inventor').getRecordTypeId();
    Id devRecordTypeIdoc = Schema.SObjectType.SymphonyIPM__Inventor__c.getRecordTypeInfosByName().get('OC').getRecordTypeId();
  /* user Ocuser = new user();
   Ocuser.Alias = 'teus1568';
   Ocuser.Username = 'test58641@yopmail.com.tes';
   Ocuser.Email = 'kir19687@yopmail.com';
   Ocuser.FirstName = 'Kiran16812';
   Ocuser.LastName = 'testki36';
   Ocuser.LocaleSidKey = 'en_US';
     Ocuser.LanguageLocaleKey = 'en_US';
   Ocuser.EmailEncodingKey = 'ISO-8859-1';
   Ocuser.TimeZoneSidKey = 'GMT';
   Ocuser.ProfileId = prof;
    
        
   insert Ocuser; 
*/
   
   SymphonyIPM__Inventor__c OcRec = new SymphonyIPM__Inventor__c();
  // OcRec.Nick_Name__c = 'TOC1';
     OcRec.First_Name__c = 'Tes684';
       OcRec.Last_Name__c = 'OC';
      OcRec.Name = 'Tes967';
   //    OcRec.SymphonyIPM__RecordTypeName__c = 'OC';
   OcRec.SymphonyIPM__User__c = ui.id;
   OcRec.SymphonyIPM__Law_Firm__c = LF.id;
  //    OcRec.Backend_Role_Field__c = '(OC)'; 
   OcRec.RecordTypeId = devRecordTypeIdoc;
   insert OcRec;
   
   SymphonyIPM__Inventor__c InvRec = new SymphonyIPM__Inventor__c();
 // InvRec.Nick_Name__c = 'TestInv';
        InvRec.First_Name__c = 'kiran562';
       InvRec.Last_Name__c = 'i';
      InvRec.Name = 'kiran1 i684';
   InvRec.SymphonyIPM__RecordTypeName__c = 'Inventor';
   //    InvRec.Backend_Role_Field__c = '(PRB)'; 
    //   InvRec.RecordTypeId = devRecordTypeId;
  
  insert InvRec;
   
   SymphonyIPM__Inventor__c inventor = [select id from SymphonyIPM__Inventor__c where First_Name__c =: 'kiran562' limit 1];
   
   id inventorid = inventor.id; 
    
     //  SymphonyIPM__Inventor__c inventor1 = [select id from SymphonyIPM__Inventor__c where SymphonyIPM__RecordTypeName__c =: 'Inventor' limit 1];
   SymphonyIPM__Inventor__c oc1 = [select id from SymphonyIPM__Inventor__c where SymphonyIPM__RecordTypeName__c =: 'OC' limit 1];
   
   SymphonyIPM__Hierarchy__c hiera = new SymphonyIPM__Hierarchy__c();
   
   hiera.Name = 'Test1 Hierarchy';
   insert hiera;
   
   SymphonyIPM__Hierarchy__c path = [select id from SymphonyIPM__Hierarchy__c where name =: 'Test1 Hierarchy'];
   id pathid = path.id;
   
   SymphonyIPM__Invention_Disclosure_New__c inv = new SymphonyIPM__Invention_Disclosure_New__c();
       inv.SymphonyIPM__Title__c = 'test132';
       inv.Outside_Counsel__c = ui.id;
         inv.Funding_Source__c = 'PRB/Central Budget';
          inv.Law_Firm__c = LF.id;
		 inv.Managing_Segment_New__c = 'UnitedHealth Group';
		 inv.SymphonyIPM__Disclosure_Status__c = 'submitted';
		 inv.SymphonyIPM__Hierarchy__c = pathid;
		 inv.SymphonyIPM__Primary_Inventor__c = inventorid;
		 inv.Is_Prior_Submissions__c = false;
		 inv.Is_Public_Disclosure__c = false;
		 inv.Is_Current_Commercisl__c = false;
		 inv.Is_External__c = false;
		 inv.Is_Third_Party_Confidentiality__c = false;
		 inv.Is_Future_Implementation__c = false;
		 inv.Is_Competing_Products_Solutions__c = false;
		 inv.Is_Third_Party_Contribution__c = false;
		 inv.Current_Stage_of_Invention__c = 'Ready to Deploy';
     //  inv.Name = 'testdis21';
		 
		 insert inv;
		 
		 
		 inv.Law_Firm__c = LFnew.id;
		 update inv;
       
		Test.stopTest(); 
		 
   }
   }