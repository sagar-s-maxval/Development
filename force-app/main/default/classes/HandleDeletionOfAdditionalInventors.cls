public without sharing class HandleDeletionOfAdditionalInventors 
{
	@invocablemethod
    public static void DeleteAdditionalInventors(List<string> InputFromApex)
    {
        List<SymphonyIPM__Additional_Inventor__c> ListAdditionalInventors = new List<SymphonyIPM__Additional_Inventor__c>();
        List<SymphonyIPM__Additional_Inventor__c> ListAdditionalInventorsToDelete = new List<SymphonyIPM__Additional_Inventor__c>();
        List<string> listInventorInfo = new List<string>();
        List<string> temp = new List<string>();
        List<string> listInventorIds = new List<string>();
        map<string,string> mapOfInventorIdsAndInfo = new map<string,string>();
        map<string,SymphonyIPM__Additional_Inventor__c> mapofadditionalinventor = new map<string,SymphonyIPM__Additional_Inventor__c>();
        List<string> value = InputFromApex[0].trim().split('-',2);
        system.debug(value[0]);
        system.debug(value[1]);
        if(value[0] != '')
        {
            ListAdditionalInventors = [SELECT Id,Inventors_Display_Order__c,SymphonyIPM__Invention_Disclosure_New__c,SymphonyIPM__Inventor_Email_Id__c,SymphonyIPM__Inventor_Email__c,SymphonyIPM__Inventor__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Invention_Disclosure_New__c =:value[0]];
            System.debug('ListAdditionalInventors size'+ListAdditionalInventors.size());            
        }
        if(value.size() > 1)
            {                
                if(value[1] != '')  
                 {    
                listInventorInfo = value[1].trim().split('<###>'); //, was removed.
                 }                
            }
        if(listInventorInfo.size() > 0)
            {
                for(String str : listInventorInfo)
                {
                    temp = str.trim().split('<#>',2); //: was removed.
                    System.debug('temp'+temp);
                    //List<string> valu = temp[1].trim().split(':',1);
                    //System.debug('valu'+valu);
                    //mapOfInventorIdsAndInfo.put(temp[0],temp[1]);
                    listInventorIds.add(temp[0]);
                }
            }
        if(ListAdditionalInventors.size() > 0)
            {
                for(SymphonyIPM__Additional_Inventor__c inventor : ListAdditionalInventors){
                    mapofadditionalinventor.put(inventor.ID,inventor);
                     if(!listInventorIds.contains(inventor.SymphonyIPM__Inventor__c)){
                        ListAdditionalInventorsToDelete.add(inventor);
                     }
                }
            }
        if(ListAdditionalInventorsToDelete.size() > 0)
            {
                 DELETE ListAdditionalInventorsToDelete;
            }
    }
}