public with sharing class IDFRecordDetailPageController 
{
	@AuraEnabled
    public static WrapperRecordDetails GetRecordDetails(Id IDFRecordId)
    {
        List<string> ListMentorIds = new List<string>();
        List<SymphonyIPM__Inventor__c> lstMentors = new List<SymphonyIPM__Inventor__c>();
        //set<SymphonyIPM__Additional_Inventor__c> lstAdditionalInventors = new set<SymphonyIPM__Additional_Inventor__c>();
        SymphonyIPM__Additional_Inventor__c objadditionalinvTemp = new SymphonyIPM__Additional_Inventor__c();
        SymphonyIPM__Invention_Disclosure_New__c ObjInventionDisclosure = [SELECT ID,Name,business_Segment__c,SymphonyIPM__Title__c,SymphonyIPM__Submitted_Date__c,SymphonyIPM__Hierarchy__c,SymphonyIPM__Primary_Inventor__c,
                                                                          SymphonyIPM__Primary_Inventor__r.Name,Invention_Program__c,Current_Stage_of_Invention__c,Primary_Contact__c,Primary_Contact__r.Name,Mentor__c,
                                                                          Invention_Description__c,SymphonyIPM__Detailed_Description__c,SymphonyIPM__Inventive_Features__c,SymphonyIPM__Alternative_Implementations_New__c,
                                                                          Is_Prior_Submissions__c,Prior_Submission_Description__c,Mentor__r.Name,Is_Public_Disclosure__c,Public_Disclosure__c,Public_Disclosure_Date__c,
                                                                          Is_Current_Commercisl__c,Current_Commercial_Use__c,Is_External__c,Business_Program__c,Funding_Source__c,External_Use__c,Is_Future_Implementation__c,Future_Implementation__c,
                                                                          Is_Competing_Products_Solutions__c,Competing_Products_Solutions__c,Is_Third_Party_Contribution__c,Third_Party_Contribution__c,Managing_Segment_New__c,
                                                                          Is_Reverse_Engineering__c,Reverse_Engineering__c,Is_Testing_a_competitive_solution__c,Testing_a_competitive_solution__c,Is_Reading_Product_literature__c,
                                                                          Reading_Product_literature__c,Impossible_unless_3rd_party_admitted_use__c,Don_t_know__c,Other__c,Others__c,Is_Third_Party_Confidentiality__c,Third_Party_Confidentiality__c,
                                                                          SymphonyIPM__Hierarchy__r.Name,SymphonyIPM__Disclosure_Status__c,CreatedDate,Mentors__c,MentorsIDs__c,Other_Contact__c,Other_Contact__r.name,Other_Contribution__c,Other_Segment__c,IndividualOrBusiness__c,
                                                                          UHG_Summary__c,UHG_Business_Value__c,UHG_First_Use_Date__c,UHG_First_External_Use_Date__c,UHG_Future_Use_Date__c
                                                                          FROM SymphonyIPM__Invention_Disclosure_New__c
                                                                          WHERE Id =: IDFRecordId];
        
        
        List<SymphonyIPM__Additional_Inventor__c> lstAdditionalInventors = [SELECT Id,Name,SymphonyIPM__Invention_Disclosure_New__c,SymphonyIPM__Invention_Disclosure_New__r.SymphonyIPM__Primary_Inventor__c,SymphonyIPM__Inventor__c,SymphonyIPM__Inventor__r.Name,SymphonyIPM__Inventor_Email__c,
                                                                            Role_In_Conception__c,Is_Primary__c,CreatedDate,Inventors_Display_Order__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Invention_Disclosure_New__c =: IDFRecordId ORDER BY Inventors_Display_Order__c ASC];
         
    	/*Integer i =0;
        for(SymphonyIPM__Additional_Inventor__c objAdditionalInventor : lstAdditionalInventorsRecords)
        {
        	
            if(objAdditionalInventor.SymphonyIPM__Inventor__c == objAdditionalInventor.SymphonyIPM__Invention_Disclosure_New__r.SymphonyIPM__Primary_Inventor__c)
            {
                lstAdditionalInventors.add(objAdditionalInventor);
                break;
            }
            i = i + 1;
        }
        lstAdditionalInventorsRecords.remove(i);
        lstAdditionalInventors.addAll(lstAdditionalInventorsRecords);*/
        System.debug('lstAdditionalInventors'+lstAdditionalInventors);
        string mentorids = ObjInventionDisclosure.MentorsIDs__c;
        if(mentorids!= null && mentorids!='')
        {
        string stri=mentorids.deleteWhitespace();
        if(stri != null && stri.contains(','))
        {
            System.debug('Mentors ---'+stri.split(','));
            ListMentorIds = stri.trim().split(',');
        }
            else if(stri!=null){
                ListMentorIds= new list<string>{stri};
            }
        }
        if(ListMentorIds.size() > 0)
        {
        	lstMentors = [SELECT id,Name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE id IN: ListMentorIds];
        }
        WrapperRecordDetails objWrapperRecordDetails = new WrapperRecordDetails(ObjInventionDisclosure, lstAdditionalInventors, lstMentors);
        return objWrapperRecordDetails;
    }


    public class WrapperRecordDetails
    {
        @AuraEnabled
        public SymphonyIPM__Invention_Disclosure_New__c InventionDisclosure{get;set;}
        @AuraEnabled
        public List<SymphonyIPM__Additional_Inventor__c> ListAdditionalInventors{get;set;}
        @AuraEnabled
        public List<SymphonyIPM__Inventor__c> ListInventors{get;set;}
        
        public WrapperRecordDetails(SymphonyIPM__Invention_Disclosure_New__c InventionDisclosureRecord, List<SymphonyIPM__Additional_Inventor__c> AdditionalInventors, List<SymphonyIPM__Inventor__c> ListMentorRecords)
        {
            InventionDisclosure = InventionDisclosureRecord;
            ListAdditionalInventors = AdditionalInventors;
            ListInventors = ListMentorRecords; 
        }
    }
}