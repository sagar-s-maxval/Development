public with sharing class IDFController {
    
    @AuraEnabled
    public static List<SymphonyIPM__Hierarchy__c> getpaths()
    {
        ID currentUserID=userInfo.getUserId();
        System.debug('currentUserID>>>'+currentUserID);
        Id CurrentUserProfileID=userInfo.getProfileId();
        System.debug('CurrentUserProfileID>>>'+CurrentUserProfileID);
        String profileName=[Select Id,Name from Profile where Id=:CurrentUserProfileID].Name;
        System.debug('ProfileName'+profileName);
        List<SymphonyIPM__Hierarchy__c> objPathList = new List<SymphonyIPM__Hierarchy__c>();
        if(Schema.sObjectType.SymphonyIPM__Hierarchy__c.isAccessible() && SymphonyIPM__Hierarchy__c.sObjectType.getDescribe().isAccessible())
        {
            if(ProfileName=='Platform Inventor' || ProfileName=='Platform Reviewer' || ProfileName=='Business User')
             objPathList = [SELECT Id, Name FROM SymphonyIPM__Hierarchy__c WHERE SymphonyIPM__Parent__c=''];
            else
              objPathList = [SELECT Id, Name FROM SymphonyIPM__Hierarchy__c LIMIT 49999];  
        }
        return objPathList ;
    }
    
    @AuraEnabled
    public static List<SymphonyIPM__Inventor__c> getinventors()
    {
        List<SymphonyIPM__Inventor__c> lstinv = new List<SymphonyIPM__Inventor__c>();
        if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
        {
            lstinv =[Select ID,Name from SymphonyIPM__Inventor__c LIMIT 49999];
            
        }
        return lstinv;
    }
    
 /*   @AuraEnabled
    public static List<SymphonyIPM__Inventor__c> getmentor()
    {
        List<SymphonyIPM__Inventor__c> lstmen = new List<SymphonyIPM__Inventor__c>();
        if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
        {
            lstmen =[Select ID,Name from SymphonyIPM__Inventor__c LIMIT 49999];
            
        }
        return lstmen;
    }
    
    @AuraEnabled
    public static List<SymphonyIPM__Inventor__c> getprimary()
    {
        List<SymphonyIPM__Inventor__c> lstpri = new List<SymphonyIPM__Inventor__c>();
        if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
        {
            lstpri =[Select ID,Name from SymphonyIPM__Inventor__c LIMIT 49999];
            
        }
        return lstpri;
    } */
    
     @AuraEnabled
    public static List<string> getstage(String objectName, String field_apiname)
    {
         List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = SymphonyIPM__Invention_Disclosure_New__c.Current_Stage_of_Invention__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}     
		return pickListValuesList;
     /*   List<string> lststage = new List<string>();
       List<String> optionlist = new List<String>();
        if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
         
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();      
         for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getValue());
        }
        
        return optionlist;*/
    }
    
    //Managing Segment
    @AuraEnabled
    public static List<string> getBusinessSegment(String objectName, String field_apiname)
    {
         List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = SymphonyIPM__Invention_Disclosure_New__c.Business_Segment__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}     
		return pickListValuesList;
    }
}