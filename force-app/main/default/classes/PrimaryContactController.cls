public with sharing class PrimaryContactController {
    
    @AuraEnabled
    public static List<wrapperComboboxOption> searchInventors(string searchword, List<string> inventorIds)
    {
        Id userId = UserInfo.getUserId();
        List<wrapperComboboxOption> objoptions = new List<wrapperComboboxOption>();
        searchword = searchword + '%';
        if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
        {
            
            List<SymphonyIPM__Inventor__c> lstInventors =[Select name,SymphonyIPM__Email__c,SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c where(Name Like :searchword OR SymphonyIPM__Email__c like: searchword OR SymphonyIPM__User__r.Email LIKE :searchWord) AND SymphonyIPM__RecordTypeName__c = 'Inventor' AND Id NOT IN :inventorIds   ORDER BY Name];// removed on 14/06/2020 AND SymphonyIPM__User__r.Id!= : userId in order to allow the logged user to be added as mentor.
            if(Test.isRunningTest())
            {
                lstInventors =[Select id,name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c LIMIT 1];
                
            }
            if(lstInventors.size() > 0)
            {
                for(SymphonyIPM__Inventor__c objinv : lstInventors )
                {
                    wrapperComboboxOption objOption = new wrapperComboboxOption();
                    if (objinv.SymphonyIPM__Email__c != null)
                        objOption.label = objinv.Name  + ' (' + objinv.SymphonyIPM__Email__c + ')';
                    else if (objinv.SymphonyIPM__User__r.Email != null)
                        objOption.label = objinv.Name  + ' (' + objinv.SymphonyIPM__User__r.Email + ')';
                    else
                        objOption.label = objinv.Name;
                    objOption.value = objinv.Id;
                    objOptions.add(objOption);
                }
            }
            
        }
        return objoptions;
    }
    
    @AuraEnabled
    public static List<wrapperComboboxOption> othersearchInventors(string searchword, List<string> inventorIds)
    {
        Id userId = UserInfo.getUserId();
        List<wrapperComboboxOption> objoptions = new List<wrapperComboboxOption>();
        searchword = searchword + '%';
        if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
        {
            
            List<SymphonyIPM__Inventor__c> lstInventors =[Select name,SymphonyIPM__Email__c,SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c where(Name Like :searchword OR SymphonyIPM__Email__c like: searchword OR SymphonyIPM__User__r.Email LIKE :searchWord) AND SymphonyIPM__RecordTypeName__c = 'Inventor' AND Id NOT IN :inventorIds   ORDER BY Name];// removed on 14/06/2020 AND SymphonyIPM__User__r.Id!= : userId in order to allow the logged user to be added as mentor.
            if(Test.isRunningTest())
            {
                lstInventors =[Select id,name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c LIMIT 1];
                
            }
            if(lstInventors.size() > 0)
            {
                for(SymphonyIPM__Inventor__c objinv : lstInventors )
                {
                    wrapperComboboxOption objOption = new wrapperComboboxOption();
                    if (objinv.SymphonyIPM__Email__c != null)
                        objOption.label = objinv.Name  + ' (' + objinv.SymphonyIPM__Email__c + ')';
                    else if (objinv.SymphonyIPM__User__r.Email != null)
                        objOption.label = objinv.Name  + ' (' + objinv.SymphonyIPM__User__r.Email + ')';
                    else
                        objOption.label = objinv.Name;
                    objOption.value = objinv.Id;
                    objOptions.add(objOption);
                }
            }
            
        }
        system.debug('objoptions=='+objoptions);
        return objoptions;
    }
    
    @AuraEnabled
    public static List<wrapperPillNew> getSelectedInventors(List<string> inventorIds)
    {
        System.debug(inventorIds);
        List<wrapperPillNew> objPills = new List<wrapperPillNew>();
        if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
        {
            List<SymphonyIPM__Inventor__c> lstInventors = [SELECT  Id, Name,Business_Segment__c,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE Id IN :inventorIds ORDER BY Name];
            if(lstInventors.size() > 0)
            {
                System.debug(lstInventors);
                for(SymphonyIPM__Inventor__c objInventor : lstInventors)
                {
                    wrapperPillNew objPill = new wrapperPillNew();
                    objPill.type = 'avatar';
                    objPill.label = objInventor.Name;
                    objPill.name = objInventor.Id;
                    objPill.fallbackIconName = 'standard:user';
                    objPill.variant = 'circle';
                    
                    //objPill.comment= objInventor.SymphonyIPM__Comments__c;
                    objPill.segment= objInventor.Business_Segment__c;
                    if (objInventor.SymphonyIPM__Email__c != null)
                        objPill.label = objInventor.Name  + ' (' + objInventor.SymphonyIPM__Email__c + ')';
                    else
                        objPill.label = objInventor.Name;
                    objPills.add(objPill);
                }
            }
        }
        System.debug(objPills);
        return objPills;
        
    }
    
    @AuraEnabled
    public static List<wrapperPillNew> othergetSelectedInventors(List<string> inventorIds)
    {
        System.debug(inventorIds);
        List<wrapperPillNew> objPills = new List<wrapperPillNew>();
        if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
        {
            List<SymphonyIPM__Inventor__c> lstInventors = [SELECT  Id, Name,Business_Segment__c,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE Id IN :inventorIds ORDER BY Name];
            if(lstInventors.size() > 0)
            {
                System.debug(lstInventors);
                for(SymphonyIPM__Inventor__c objInventor : lstInventors)
                {
                    wrapperPillNew objPill = new wrapperPillNew();
                    objPill.type = 'avatar';
                    objPill.label = objInventor.Name;
                    objPill.name = objInventor.Id;
                    objPill.fallbackIconName = 'standard:user';
                    objPill.variant = 'circle';
                    if (objInventor.SymphonyIPM__Email__c != null)
                        objPill.label = objInventor.Name  + ' (' + objInventor.SymphonyIPM__Email__c + ')';
                    else
                        objPill.label = objInventor.Name;
                    objPills.add(objPill);
                }
            }
        }
        System.debug(objPills);
        return objPills;
        
    }
    
    @AuraEnabled
    public static wrapperPillNew fetchUser(){
        User objuser = [select id,Name,FederationIdentifier from User where id =: userInfo.getUserId()];
        //System.debug('User id'+objuser.id);
        List<SymphonyIPM__Inventor__c> objinventor = new  List<SymphonyIPM__Inventor__c>();
        if(objuser != null)
        {
            objinventor = [SELECT id,Name,SymphonyIPM__Email__c,SymphonyIPM__RecordTypeName__c,SymphonyIPM__User__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__User__c =:objuser.Id AND (SymphonyIPM__RecordTypeName__c = 'In_house_Counsel' OR SymphonyIPM__RecordTypeName__c = 'Inventor')];
        }
        //System.debug('Fetched Record'+objinventor);
        if(objinventor!=null && objinventor.size()>0)
        {
            wrapperPillNew objPill = new wrapperPillNew();
            objPill.type = 'avatar';
            objPill.label = objinventor[0].Name;
            objPill.name = objinventor[0].Id;
            objPill.fallbackIconName = 'standard:address';
            objPill.variant = 'circle';
            if (objinventor[0].SymphonyIPM__Email__c != null)
                objPill.label = objinventor[0].Name  + ' (' + objinventor[0].SymphonyIPM__Email__c + ')';
            else
                objPill.label = objinventor[0].Name;
            //System.debug('OBJPILL'+objPill);
            System.debug('Return value'+objPill);
            return objPill;
        }
        else{
            System.debug('else returned null');
            return null;
        }
    }
    
    @AuraEnabled
    public static SymphonyIPM__Inventor__c fetchInventor(String inventorIds)
    {   SymphonyIPM__Inventor__c Inventor = [SELECT  Id, Name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE Id=:inventorIds];
     return Inventor;
    }
    
    @AuraEnabled
    public static List<wrapperPillNew> populateAdditionalInventors(String DisclosureId) // Edit button override
    {   List<String> invIds=new List<String>();
     List<SymphonyIPM__Invention_Disclosure_New__c> InvList=[Select id,Primary_Contact__c,MentorsIDs__c,Mentors__c,SymphonyIPM__Comments__c,Business_Segment__c From SymphonyIPM__Invention_Disclosure_New__c where id=:DisclosureId];
     System.debug('populateAdditionalInventors ' + DisclosureId);
     
     if(InvList.size() > 0)
     {
         
         for(SymphonyIPM__Invention_Disclosure_New__c inv:InvList)
         {
             invIds.add(inv.Primary_Contact__c);
             System.debug('invIds================'+invIds);
         }
     }
     List<wrapperPillNew> allInvs=getSelectedInventors(invIds);
     return allInvs;
     
    } 
    
    @AuraEnabled
    public static List<wrapperPillNew> otherpopulateAdditionalInventors(String DisclosureId) // Edit button override
    {   List<String> invIds=new List<String>();
     List<SymphonyIPM__Invention_Disclosure_New__c> InvList=[Select id,Other_Contact__c,MentorsIDs__c,Mentors__c From SymphonyIPM__Invention_Disclosure_New__c where id=:DisclosureId];
     if(InvList.size() > 0)
     {
         System.debug(InvList);
         for(SymphonyIPM__Invention_Disclosure_New__c inv:InvList)
         {
             invIds.add(inv.Other_Contact__c);
             System.debug('Other_Contact__c================'+invIds);
         }
     }
     List<wrapperPillNew> allInvs=getSelectedInventors(invIds);
     return allInvs;
     
    }
    @AuraEnabled
    public static List<string> getManagingSegment(String objectName, String field_apiname)
    {
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = SymphonyIPM__Invention_Disclosure_New__c.Other_Segment__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    @AuraEnabled
    public static wrapperPath getpaths(string editviewID)
    {
        ID currentUserID=userInfo.getUserId();
        wrapperPath objwrapperPath = new wrapperPath();
        list<SymphonyIPM__Invention_Disclosure_New__c> objIDF = new list<SymphonyIPM__Invention_Disclosure_New__c>(); 
        System.debug('currentUserID>>>'+currentUserID);
        Id CurrentUserProfileID=userInfo.getProfileId();
        System.debug('CurrentUserProfileID>>>'+CurrentUserProfileID);
        String profileName=[Select Id,Name from Profile where Id=:CurrentUserProfileID].Name;
        System.debug('ProfileName'+profileName);
        if(editviewID != '' && editviewID != null && editviewID != 'false')
            objIDF = [SELECT id,SymphonyIPM__Disclosure_Status__c,SymphonyIPM__Hierarchy__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE id=:editviewID];
        List<SymphonyIPM__Hierarchy__c> objPathList = new List<SymphonyIPM__Hierarchy__c>();
        if(Schema.sObjectType.SymphonyIPM__Hierarchy__c.isAccessible() && SymphonyIPM__Hierarchy__c.sObjectType.getDescribe().isAccessible())
        {
            
            if(ProfileName=='Platform Inventor' || ProfileName=='Platform Reviewer' || ProfileName=='Business User')
                objPathList = [SELECT Id, Name FROM SymphonyIPM__Hierarchy__c where SymphonyIPM__Parent__c =''];              
            else
                objPathList = [SELECT Id, Name FROM SymphonyIPM__Hierarchy__c LIMIT 49999]; 
            system.debug('newtest'+objPathList.size());
            //objwrapperPath.listPath = objPathList;
            List<SymphonyIPM__Hierarchy__c> listpaths = new List<SymphonyIPM__Hierarchy__c>();
            if(objIDF.size() > 0)
            {
                listpaths = [SELECT Id, Name FROM SymphonyIPM__Hierarchy__c WHERE id =: objIDF[0].SymphonyIPM__Hierarchy__c];
                if(listpaths.size()>0){
                objPathList.add(listpaths[0]);
                objPathList.sort();
                objwrapperPath.listPath = objPathList;
                objwrapperPath.TechPath = listpaths[0].Name;
                } else {
                 objPathList.sort();
                objwrapperPath.listPath = objPathList;
                    objwrapperPath.TechPath = '';   }
            } else
            {
                objPathList.sort();
                objwrapperPath.listPath = objPathList;
                objwrapperPath.TechPath = '';
            }
                 
            
            //system.debug('newtest01'+listpaths[0].Name);
        }
        
        return objwrapperPath;
    }
    @AuraEnabled
    public static Boolean getprbtechenablestatusctr(string recid)
    {
        ID currentUserID=userInfo.getUserId();
        System.debug('currentUserID>>>'+currentUserID);
        Id CurrentUserProfileID=userInfo.getProfileId();
        System.debug('CurrentUserProfileID>>>'+CurrentUserProfileID);
        String profileName=[Select Id,Name from Profile where Id=:CurrentUserProfileID].Name;
        System.debug('ProfileName'+profileName);
        Boolean isPRBTechnologyEnabled = false;
        SymphonyIPM__Invention_Disclosure_New__c objIDF = new SymphonyIPM__Invention_Disclosure_New__c();
        if(recid != null && recid != '' && recid != 'false')
        objIDF = [SELECT id,SymphonyIPM__Disclosure_Status__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE id=:recid];
        if(recid != null && recid != '' && recid != 'false' && objIDF != null && (objIDF.SymphonyIPM__Disclosure_Status__c != 'Draft') && ProfileName=='Platform Inventor')
        {
            IsPRBTechnologyEnabled = true;
        }
        else if(recid == 'false' || (objIDF != null && (objIDF.SymphonyIPM__Disclosure_Status__c == 'Draft') && ProfileName=='Platform Inventor'))
        {
            IsPRBTechnologyEnabled = false;
        }
        
        return IsPRBTechnologyEnabled;  
    }
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
    
    
    /*   @AuraEnabled
public static List<wrapperPillNew> populateMentor(String DisclosureIds) // Edit button override
{   List<String> invIds=new List<String>();
List<String> ment=new List<String>();
List<SymphonyIPM__Invention_Disclosure_New__c> InvList=[Select id,MentorsIDs__c From SymphonyIPM__Invention_Disclosure_New__c where id=:DisclosureIds];
System.debug(InvList);

for(SymphonyIPM__Invention_Disclosure_New__c inv:InvList)
{
ment = inv.MentorsIDs__c.split(',');
System.debug(ment);
//  invIds.add();
}
List<wrapperPillNew> allInvs=getSelectedInventors(ment);

System.debug(allInvs);
return allInvs;

} */  
    
    @AuraEnabled
    public static string getValues(String DisclosureId) // Edit button override
    {  
        
        SymphonyIPM__Invention_Disclosure_New__c InvList=[Select id,Primary_Contact__c,Other_Segment__c,IndividualOrBusiness__c,other_Contribution__c From SymphonyIPM__Invention_Disclosure_New__c where id=:DisclosureId];
        
        return InvList.Other_Segment__c;     
    } 
    public class wrapperPath {
        @AuraEnabled
        public List<SymphonyIPM__Hierarchy__c> listPath {get; set;}
        @AuraEnabled
        public string TechPath{get; set;}
    }      
    
}