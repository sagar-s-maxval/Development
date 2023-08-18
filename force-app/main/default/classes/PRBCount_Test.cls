@isTest
public class PRBCount_Test {

@isTest
public static void methos1()
{

SymphonyIPM__Invention_Disclosure_New__c inv = new SymphonyIPM__Invention_Disclosure_New__c();
       inv.SymphonyIPM__Title__c = 'test12';
         inv.Funding_Source__c = 'PRB/Central Budget';
    //      inv.Law_Firm__c = LF.id;
		 inv.Managing_Segment_New__c = 'UnitedHealth Group';
		 inv.SymphonyIPM__Disclosure_Status__c = 'submitted';
	//	 inv.SymphonyIPM__Hierarchy__c = pathid;
	//	 inv.SymphonyIPM__Primary_Inventor__c = inventorid;
		 inv.Is_Prior_Submissions__c = false;
		 inv.Is_Public_Disclosure__c = false;
		 inv.Is_Current_Commercisl__c = false;
		 inv.Is_External__c = false;
		 inv.Is_Third_Party_Confidentiality__c = false;
		 inv.Is_Future_Implementation__c = false;
		 inv.Is_Competing_Products_Solutions__c = false;
		 inv.Is_Third_Party_Contribution__c = false;
		 inv.Current_Stage_of_Invention__c = 'Ready to Deploy';
		 
		 insert inv;
Date d = date.today();
SymphonyIPM__PRC_Meeting__c prb = new SymphonyIPM__PRC_Meeting__c();

         prb.name = 'Test Meeting';
		 prb.SymphonyIPM__Meeting_Date__c = d;
         prb.SymphonyIPM__Start_Time__c = '10:00';
    
		 insert prb;
		 
SymphonyIPM__IDF_Review__c rate = new SymphonyIPM__IDF_Review__c();
        
         rate.PRC_Meeting_ID__c = 	prb.id;
		 rate.SymphonyIPM__Base_Invention_Disclosure__c = inv.id;
		 
		 insert rate;
}


}