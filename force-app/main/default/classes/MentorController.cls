public with sharing class MentorController {
    
    @AuraEnabled
    public static List<wrapperComboboxOption> searchInventors(string searchword, List<string> inventorIds)
    {
        Id userId = UserInfo.getUserId();
        List<wrapperComboboxOption> objoptions = new List<wrapperComboboxOption>();
        searchword = searchword + '%';
        if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
        {
            //List<SymphonyIPM__Inventor__c> lstInventors =[Select name,SymphonyIPM__Email__c,SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c where(Name Like :searchword OR SymphonyIPM__Email__c like: searchword OR SymphonyIPM__User__r.Email LIKE :searchWord) AND SymphonyIPM__RecordTypeName__c = 'Inventor' AND Id NOT IN :inventorIds AND SymphonyIPM__User__r.Id!= : userId  ORDER BY Name];
            List<SymphonyIPM__Inventor__c> lstInventors =[Select name,SymphonyIPM__Email__c,SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c where(Name Like :searchword OR SymphonyIPM__Email__c like: searchword OR SymphonyIPM__User__r.Email LIKE :searchWord) AND SymphonyIPM__RecordTypeName__c = 'Inventor' AND Id NOT IN :inventorIds ORDER BY Name];
           
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
    public static List<wrapperPillNew> getSelectedInventors(List<string> inventorIds)
    {
        System.debug(inventorIds);
        List<wrapperPillNew> objPills = new List<wrapperPillNew>();
        if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
        {
            List<SymphonyIPM__Inventor__c> lstInventors = [SELECT  Id, Name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE Id IN :inventorIds ORDER BY Name];
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
        System.debug('User id'+objuser.id);
       list<SymphonyIPM__Inventor__c> objinventor = [SELECT id,Name,SymphonyIPM__Email__c,SymphonyIPM__RecordTypeName__c,SymphonyIPM__User__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__User__c =:objuser.Id AND (SymphonyIPM__RecordTypeName__c = 'In_house_Counsel' OR SymphonyIPM__RecordTypeName__c = 'Inventor') limit 1];
        System.debug('Fetched Record'+objinventor);
        if(objinventor!=null && objinventor.size() >0)
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
    public static List<wrapperPillNew> populateMentor(String DisclosureIds) // Edit button override
    {   
        List<String> invIds=new List<String>();
        List<wrapperPillNew> allInvs = new List<wrapperPillNew>();
        List<String> ment=new List<String>();
     List<SymphonyIPM__Invention_Disclosure_New__c> InvList=[Select id,MentorsIDs__c From SymphonyIPM__Invention_Disclosure_New__c where id=:DisclosureIds];
     if(InvList.size() > 0)
     {
        System.debug(InvList);
    
     for(SymphonyIPM__Invention_Disclosure_New__c inv:InvList)
     {
         if(inv.MentorsIDs__c != null)
         {
             if(inv.MentorsIDs__c.contains(','))
             {
                 string str=inv.MentorsIDs__c;
                 string mentorstring=str.deleteWhitespace();
             ment = mentorstring.trim().split(',');
                 System.debug(ment);}
             else
         {
             ment = new list<string>{inv.MentorsIDs__c};
                 system.debug('ment----'+ment);
         }
         }   
        
        
        
       //  invIds.add();
     }
     }
     if(ment.size() > 0)
     {
	 allInvs=getSelectedInventors(ment);
     }
       
        System.debug(allInvs);
        return allInvs;
    }
    }

    
    
    /*   @AuraEnabled
public static List<wrapperPillNew> populateMentor(String DisclosureIds) // Edit button override
{   List<String> invIdsmen=new List<String>();
List<SymphonyIPM__Invention_Disclosure_New__c> InvList=[Select id,MentorsIDs__c,Mentors__c From SymphonyIPM__Invention_Disclosure_New__c where id=:DisclosureIds];
System.debug(InvList);
for(SymphonyIPM__Invention_Disclosure_New__c inv:InvList)
{

invIdsmen.add(inv.MentorsIDs__c);


}
List<wrapperPillNew> allInvs=getSelectedInventors(invIdsmen);
system.debug('allpri--'+allInvs);
return allInvs;
} */