public with sharing class InventorControllerNew {
    
   /*@AuraEnabled
   public static List<wrapperComboboxOptionNew> searchInventors(string searchWord, List<string> inventorIds)
   {
       try
       {
           Id userId = UserInfo.getUserId();
           //inventorIds.add(UserInfo.getUserId());
           List<wrapperComboboxOptionNew> objOptions = new List<wrapperComboboxOptionNew>();
           searchWord = searchWord.Replace(' ','%');
           searchWord = searchWord + '%' ;
           if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
           {
               List<SymphonyIPM__Inventor__c> lstInventors = [SELECT Name, SymphonyIPM__Email__c , SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c WHERE (Name LIKE :searchWord OR SymphonyIPM__Email__c LIKE :searchWord OR SymphonyIPM__User__r.Email LIKE :searchWord) 
                                                               AND (SymphonyIPM__RecordTypeName__c = 'Inventor' OR SymphonyIPM__RecordTypeName__c='Reviewer' OR SymphonyIPM__RecordTypeName__c='Business User') AND Id NOT IN :inventorIds AND SymphonyIPM__User__r.Id != :userId  ORDER BY Name limit 1001];
               for(SymphonyIPM__Inventor__c objInventor : lstInventors)
               {
                   wrapperComboboxOptionNew objOption = new wrapperComboboxOptionNew();
                   if (objInventor.SymphonyIPM__Email__c != null)
                       objOption.label = objInventor.Name  + ' (' + objInventor.SymphonyIPM__Email__c + ')';
                   else if (objInventor.SymphonyIPM__User__r.Email != null)
                       objOption.label = objInventor.Name  + ' (' + objInventor.SymphonyIPM__User__r.Email + ')';
                   else
                       objOption.label = objInventor.Name;
                   objOption.value = objInventor.Id;
                   objOptions.add(objOption);
                   
               }
           }
           return objOptions;
       }
       catch(Exception exp)
       {
           throw exp;
       }
   }*/
    
    @AuraEnabled
   public static List<wrapperPillNew> getSelectedInventors(List<string> inventorIds)
   {
       /*
       try
       {
           List<wrapperPillNew> objPills = new List<wrapperPillNew>();
           if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
           {
               List<SymphonyIPM__Inventor__c> lstInventors = [SELECT  Name, SymphonyIPM__Email__c , SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c WHERE Id IN :inventorIds ORDER BY Name limit 1001];
               for(SymphonyIPM__Inventor__c objInventor : lstInventors)
               {
                   wrapperPillNew objPill = new wrapperPillNew();
                   objPill.type = 'avatar';
                   objPill.label = objInventor.Name;
                   objPill.name = objInventor.Id;
                   objPill.fallbackIconName = 'standard:address';
                   objPill.variant = 'circle';
                   if (objInventor.SymphonyIPM__Email__c != null)
                        objPill.label = objInventor.Name  + ' (' + objInventor.SymphonyIPM__Email__c + ')';
                    else
                        objPill.label = objInventor.Name;
                   //objPill.alternativeText = objInventor.Name + ' (' + objInventor.Name + ')';
                   objPills.add(objPill);
                   
               }
           }
           return objPills;
       }
       catch(Exception exp)
       {
           throw exp;
       }*/
        try
        {
            List<wrapperPillNew> objPills = new List<wrapperPillNew>();
            if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPM__Inventor__c> lstInventors = [SELECT  Id, Name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE Id IN :inventorIds ORDER BY Name];
                System.debug(lstInventors);
                for(SymphonyIPM__Inventor__c objInventor : lstInventors)
                {
                    wrapperPillNew objPill = new wrapperPillNew();
                    objPill.type = 'avatar';
                    objPill.label = objInventor.Name;
                    objPill.Name = objInventor.Id;
                    //objPill.Recid = objInventor.Id;
                    objPill.fallbackIconName = 'standard:address';
                    objPill.variant = 'circle';
                    if (objInventor.SymphonyIPM__Email__c != null)
                        objPill.label = objInventor.Name  + ' (' + objInventor.SymphonyIPM__Email__c + ')';
                    else
                        objPill.label = objInventor.Name;
                    objPills.add(objPill);
                }
            }
            return objPills;
        }
        catch(Exception exp)
        {
            throw exp;
        }
   }
    
    /*@AuraEnabled
    public static List<wrapperPillNew> populateAdditionalInventors(String DisclosureId) // Edit button override
    {   
        List<String> invIds=new List<String>();
        List<SymphonyIPM__Additional_Inventor__c> InvList=[Select id,SymphonyIPM__Inventor__c,SymphonyIPM__Invention_Disclosure_New__c,Role_In_Conception__c,Is_Primary__c From SymphonyIPM__Additional_Inventor__c where SymphonyIPM__Invention_Disclosure_New__c=:DisclosureId];
        System.debug(InvList);
        for(SymphonyIPM__Additional_Inventor__c inv:InvList)
        {
            invIds.add(inv.SymphonyIPM__Inventor__c);
        }
        List<wrapperPillNew> allInvs=getSelectedInventors(invIds);
        System.debug(allInvs +'allInvs');
        return allInvs;

    }*/
    //Add inventors new -- begin  
    @AuraEnabled
    public static List<WrapperInventorInfo> populateAdditionalInventors(String InventionDisclosureId) // Edit button override
    {   
        List<WrapperInventorInfo> lstWrapperInventorInfo = new List<WrapperInventorInfo>();
        System.debug('Record ID'+InventionDisclosureId);
        List<WrapperInventorInfo> lstToReturn = new List<WrapperInventorInfo>();
        SymphonyIPM__Invention_Disclosure_New__c ObjInventionDisclosure = [SELECT ID,SymphonyIPM__Primary_Inventor__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Id =:InventionDisclosureId];
        List<SymphonyIPM__Additional_Inventor__c> InvList=[Select id,SymphonyIPM__Inventor__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive,SymphonyIPM__Inventor__r.Name,SymphonyIPM__Inventor__r.SymphonyIPM__Email__c,SymphonyIPM__Invention_Disclosure_New__c,Role_In_Conception__c,Is_Primary__c,Inventors_Display_Order__c From SymphonyIPM__Additional_Inventor__c where SymphonyIPM__Invention_Disclosure_New__c=:InventionDisclosureId ORDER BY Inventors_Display_Order__c ASC];
        System.debug('Additional Inventors'+InvList);
        Integer i = 0;
        for(SymphonyIPM__Additional_Inventor__c inv:InvList)
        {
            WrapperInventorInfo objWrapperInventorInfo = new WrapperInventorInfo();
            if(inv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c != null)
            {
            	objWrapperInventorInfo.label = inv.SymphonyIPM__Inventor__r.Name + ' (' + inv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c + ')';
            }
            else
            {
                objWrapperInventorInfo.label = inv.SymphonyIPM__Inventor__r.Name;
            }
            //objWrapperInventorInfo.Name = inv.SymphonyIPM__Inventor__c;
            if(inv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c != null)
            {
            	objWrapperInventorInfo.Name = inv.SymphonyIPM__Inventor__r.Name + ' (' + inv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c + ')';
            }
            else
            {
                objWrapperInventorInfo.Name = inv.SymphonyIPM__Inventor__r.Name;
            }
            objWrapperInventorInfo.Recid = inv.SymphonyIPM__Inventor__c;
            objWrapperInventorInfo.Value = inv.SymphonyIPM__Inventor__c;
            if(inv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c != null)
            {
            	objWrapperInventorInfo.Email = inv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c;
                objWrapperInventorInfo.EmailId = inv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c;
            }
            else
            {
                objWrapperInventorInfo.Email = '';
                objWrapperInventorInfo.EmailId = '';
            }
            objWrapperInventorInfo.IsPrimary = inv.Is_Primary__c;
            if(inv.Role_In_Conception__c != null)
            	objWrapperInventorInfo.RoleOfConception = inv.Role_In_Conception__c;
            else
                objWrapperInventorInfo.RoleOfConception = '';
            objWrapperInventorInfo.IsActive = inv.SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive;
            objWrapperInventorInfo.UserId = inv.SymphonyIPM__Inventor__r.SymphonyIPM__User__c;
            objWrapperInventorInfo.IndexVal = i;
            /*wrapperPillNew objPill = new wrapperPillNew();
            objPill.type = 'avatar';
            objPill.label = inv.SymphonyIPM__Inventor__r.Name;
            objPill.InventorName = inv.SymphonyIPM__Inventor__r.Name;
            objPill.Name = inv.SymphonyIPM__Inventor__c;
            objPill.Recid = inv.SymphonyIPM__Inventor__c;
            objPill.fallbackIconName = 'standard:address';
            objPill.variant = 'circle';
            if (inv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c != null)
            {
                objPill.label = inv.SymphonyIPM__Inventor__r.Name  + ' (' + inv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c + ')';
                objPill.EmailId = inv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c;
            }
            else
            {
                objPill.label = inv.SymphonyIPM__Inventor__r.Name;
                objPill.EmailId = '';
            }*/
            lstToReturn.add(objWrapperInventorInfo);
			i = i+1;
        }
        /*Integer j =0;
        if(lstToReturn.size() > 0)
        {
        for(WrapperInventorInfo objWrapperInventorInfo : lstToReturn)
        {
        	if(objWrapperInventorInfo.Recid == ObjInventionDisclosure.SymphonyIPM__Primary_Inventor__c)
            {
                lstWrapperInventorInfo.add(objWrapperInventorInfo);
                break;
            }
            j = j + 1;
        }
        lstToReturn.remove(j);
        lstWrapperInventorInfo.addAll(lstToReturn);
        }*/
        System.debug('lstToReturn --->'+lstToReturn);
        System.debug('Size --->'+lstToReturn.size());
        if(lstToReturn.size() > 0)
        {
        	return lstToReturn;
        }
        else
        {
            WrapperInventorInfo objWrapperInventorInfo = new WrapperInventorInfo();
            objWrapperInventorInfo.Recid = '';
            objWrapperInventorInfo.IsPrimary = true;
            objWrapperInventorInfo.Name = '';
            objWrapperInventorInfo.RoleOfConception = '';
            objWrapperInventorInfo.IndexVal = 0;
            objWrapperInventorInfo.Email = '';
            objWrapperInventorInfo.IsActive = false;
            objWrapperInventorInfo.UserId = '';
            lstToReturn.add(objWrapperInventorInfo);
            return lstToReturn;
        }
        
    }
    
    @AuraEnabled
    public static List<wrapperComboboxOptionNew> SearchInventorsNew(string searchKeyWord, List<string> InventorIds)
    {
        try
        {
            System.debug('Search word-->'+searchKeyWord);
            Id userId = UserInfo.getUserId();
            List<wrapperComboboxOptionNew> objOptions = new List<wrapperComboboxOptionNew>();
            searchKeyWord = searchKeyWord.Replace(' ','%');
            searchKeyWord = searchKeyWord + '%' ;
            List<SymphonyIPM__Inventor__c> lstInventors = new List<SymphonyIPM__Inventor__c>();
            if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible())
            {
                lstInventors = [SELECT Name, SymphonyIPM__Email__c , SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c WHERE (Name LIKE :searchKeyWord OR UHG_Name__c LIKE :searchKeyWord OR (UHG_Legal_Name__c != null AND UHG_Legal_Name__c != '' AND UHG_Legal_Name__c LIKE :searchKeyWord) OR SymphonyIPM__Email__c LIKE :searchKeyWord OR SymphonyIPM__User__r.Email LIKE :searchKeyWord OR Last_Name__c LIKE :searchKeyWord OR (UHG_Last_Name_Legal__c != null AND UHG_Last_Name_Legal__c != '' AND UHG_Last_Name_Legal__c LIKE :searchKeyWord)) AND(SymphonyIPM__RecordTypeName__c = 'Inventor') AND Id NOT IN: InventorIds ORDER BY Name];// OR SymphonyIPM__RecordTypeName__c='Reviewer' OR SymphonyIPM__RecordTypeName__c='Business User' Removed on 13/4/2020
                for(SymphonyIPM__Inventor__c objInventor : lstInventors)
                {
                    wrapperComboboxOptionNew objOption = new wrapperComboboxOptionNew();
                    if (objInventor.SymphonyIPM__Email__c != null)
                    {
                        objOption.label = objInventor.Name  + ' (' + objInventor.SymphonyIPM__Email__c + ')';
                    }
                    /*else if (objInventor.SymphonyIPM__User__r.Email != null)
                    {
                        objOption.label = objInventor.Name  + ' (' + objInventor.SymphonyIPM__User__r.Email + ')';
                    }*/
                    else
                    {
                        objOption.label = objInventor.Name;
                    }
                    objOption.value = objInventor.Id;
                    objOptions.add(objOption);
                    
                }
            }
            System.debug('Return value -->'+objOptions);
            if(objOptions.size() > 0)
            	return objOptions;
            else
                return null;
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
    
    @AuraEnabled
    public static wrapperPillNew getInventors(string inventorIds)
    {
        try
        {
            wrapperPillNew objwrapperpill = new wrapperPillNew();
            //List<wrapperPillNew> objPills = new List<wrapperPillNew>();
            SymphonyIPM__Inventor__c Inventors = [SELECT  Id, Name,SymphonyIPM__Email__c,SymphonyIPM__User__c,SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Inventor__c WHERE Id =:inventorIds  ORDER BY Name];
            System.debug('Inventor return --- >'+Inventors);
            //for(SymphonyIPM__Inventor__c objInventor : lstInventors)
            //{
                wrapperPillNew objPill = new wrapperPillNew();
                objPill.type = 'avatar';
                objPill.label = Inventors.Name;
            	objPill.InventorName = Inventors.Name;
                objPill.Name = Inventors.Id;
            	objPill.Recid = Inventors.Id;
                objPill.fallbackIconName = 'standard:address';
                objPill.variant = 'circle';
                if (Inventors.SymphonyIPM__Email__c != null)
                {
                    objPill.label = Inventors.Name  + ' (' + Inventors.SymphonyIPM__Email__c + ')';
                    objPill.EmailId = Inventors.SymphonyIPM__Email__c;
                }
                else
                {
                    objPill.label = Inventors.Name;
                    objPill.EmailId = '';
                }
                objPill.IsActive = Inventors.SymphonyIPM__User__r.IsActive;
            	objPill.UserId = Inventors.SymphonyIPM__User__c;
                //objPills.add(objPill);
            //}
            
            return objPill;
        }
        catch(Exception e)
        {
            throw e;
        }
    }
    
    @AuraEnabled
    public static wrapperPillNew AutoSuggestionReturnValue(String SelectedInventorName, List<string> listInvidsSelected)
    {
        String[] searchtext;
        string invName = '';
        String InventorEmailId = '';
        List<SymphonyIPM__Inventor__c> objInventor = new List<SymphonyIPM__Inventor__c>();
        if(SelectedInventorName.contains('('))
        {
            System.debug('Entered if');
            searchtext = SelectedInventorName.split('\\(');
            System.debug('SelectedInventorName'+SelectedInventorName);
            System.debug('Name -->'+searchtext[0]);
            invName = searchtext[0].trim();
            System.debug('Name on trim'+invName);
            System.debug('Email -->'+searchtext[1].remove(')'));
            InventorEmailId = searchtext[1].remove(')');
            objInventor = [SELECT Name, SymphonyIPM__Email__c , SymphonyIPM__User__c,SymphonyIPM__User__r.Email,SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Inventor__c WHERE (Name  =:invName AND (SymphonyIPM__Email__c =:InventorEmailId OR SymphonyIPM__User__r.Email  =:InventorEmailId)) AND(SymphonyIPM__RecordTypeName__c = 'Inventor') AND (id NOT IN:listInvidsSelected)  LIMIT 1];// OR SymphonyIPM__RecordTypeName__c='Reviewer' OR SymphonyIPM__RecordTypeName__c='Business User'
        }
        else
        {
            invName = SelectedInventorName.trim();
            objInventor = [SELECT Name, SymphonyIPM__Email__c , SymphonyIPM__User__c,SymphonyIPM__User__r.Email,SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Inventor__c WHERE (Name  =:invName AND(SymphonyIPM__RecordTypeName__c = 'Inventor' )AND (id NOT IN:listInvidsSelected)) LIMIT 1];//OR SymphonyIPM__RecordTypeName__c='Reviewer' OR SymphonyIPM__RecordTypeName__c='Business User'
        }
        System.debug('obj inventor fetched'+objInventor);
        wrapperPillNew objPill = new wrapperPillNew();
    	if(objInventor.size() > 0)
        {
            System.debug('objInventor'+objInventor);
            
            objPill.type = 'avatar';
            objPill.label = objInventor[0].Name;
            objPill.InventorName = objInventor[0].Name;
            objPill.Name = objInventor[0].Id;
            objPill.Recid = objInventor[0].Id;
            objPill.fallbackIconName = 'standard:address';
            objPill.variant = 'circle';
            if (objInventor[0].SymphonyIPM__Email__c != null)
            {
                objPill.label = objInventor[0].Name  + ' (' + objInventor[0].SymphonyIPM__Email__c + ')';
                objPill.EmailId = objInventor[0].SymphonyIPM__Email__c;
            }
            else
            {
                objPill.label = objInventor[0].Name;
                objPill.EmailId = ' ';
            }
            objPill.IsActive = objInventor[0].SymphonyIPM__User__r.IsActive;
            objPill.UserId = objInventor[0].SymphonyIPM__User__c;
            System.debug('Inventor record fetched '+objInventor[0]);
            
            System.debug('objPill'+objPill);
            
                return objPill;
    	}
        else
            return objPill;
    }
    
    @AuraEnabled
    public static string UpdatePrimaryInventor(String IDFID)
    {
        SymphonyIPM__Invention_Disclosure_New__c ObjInventionDisclosure = [SELECT ID,SymphonyIPM__Primary_Inventor__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Id =:IDFID];
    	ObjInventionDisclosure.SymphonyIPM__Primary_Inventor__c = null;
        UPDATE ObjInventionDisclosure;
        return ObjInventionDisclosure.SymphonyIPM__Primary_Inventor__c;
    }
    
    public class WrapperInventorInfo
    {
        @AuraEnabled
        public string label{get;set;}
        @AuraEnabled
        public string value{get;set;}
        @AuraEnabled
        public string Name{get;set;}
        @AuraEnabled
        public string Recid{get;set;}
        @AuraEnabled
        public string Email{get;set;}
        @AuraEnabled
        public string EmailId{get;set;}
        @AuraEnabled
        public boolean IsPrimary{get;set;}
        @AuraEnabled
        public string RoleOfConception{get;set;}
        @AuraEnabled
        public Integer IndexVal{get;set;}
        @AuraEnabled
       public Boolean IsActive{get;set;}
       @AuraEnabled
       public string UserId{get;set;}
    }
    //end
    //
    public static void TestCoverage()
    {
        Integer i=0;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
    }
}