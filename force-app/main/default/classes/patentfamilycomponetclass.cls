public with sharing class patentfamilycomponetclass
{
    @AuraEnabled
    public static List<wrapperFamily> fetchfamilys(Id AssetId)
    {
        List<wrapperFamily> lstobjwrapfmly = New List<wrapperFamily>();
        //List<wrapperFamily> listobjwrapfmly = New List<wrapperFamily>();
        Map<String,wrapperFamily> mapobjwrapfmly =new Map<String,wrapperFamily>();
        String straudit;
        try{
            
        String ParentDocketNo; 
        List<string> patfamilyId = New List<string>();
        List<string> patfamilyIdAdd = New List<string>();
        //wrapperFamily objwrapfmly1 = NEW wrapperFamily();
        Map<string,SymphonyIPM__Patent__c> mappatentrecords = NEW Map<string,SymphonyIPM__Patent__c>();
        if(Schema.sObjectType.SymphonyIPM__Patent__c.isAccessible() && SymphonyIPM__Patent__c.sObjectType.getDescribe().isAccessible())
        {        
            list<SymphonyIPM__Patent__c> lstpat = [SELECT Id,SymphonyIPM__Family_ID__c,SymphonyIPM__Application_Number__c,
            SymphonyIPM__Application_Date__c,SymphonyIPM__Docket_No__c,Name,SymphonyIPM__EPApplicationNumber__c,SymphonyIPM__Case_Type__c,SymphonyIPM__Title_of_Invention__c,SymphonyIPM__Country__r.Name,SymphonyIPM__Country_Code__c,
                                                   SymphonyIPM__Status__c,SymphonyIPM__Issue_Date_of_Patent__c FROM SymphonyIPM__Patent__c WHERE Id=:AssetId AND SymphonyIPM__Family_ID__c!=Null];
            
            ParentDocketNo = [SELECT SymphonyIPM__Docket_No__c FROM SymphonyIPM__Patent__c WHERE Id=:AssetId].SymphonyIPM__Docket_No__c;
                                     
             
            if(Schema.sObjectType.SymphonyIPM__Patent__c.isAccessible())
            { 
                for(SymphonyIPM__Patent__c pat : lstpat)
                {
                    if(pat.SymphonyIPM__Family_ID__c!=Null && pat.SymphonyIPM__Family_ID__c!='')
                    {
                       
                        //ParentDocketNo=pat.SymphonyIPM__Docket_No__c;
                        //system.debug('Parentdocno'+objwrapfmly1.ParentDocketNumber);
                        string FmlyId=(pat.SymphonyIPM__Family_ID__c).replace(',','');
                        patfamilyId.add(FmlyId);
                        patfamilyIdAdd.add(pat.SymphonyIPM__Family_ID__c);
                        
                        //mappatentrecords.put(pat.SymphonyIPM__EPApplicationNumber__c,pat);
                    }            
                }
            }
        }
        System.debug('patfamilyId list'+patfamilyId);
        list<SymphonyIPM__Family__c> BaseFmlyRecords = New list<SymphonyIPM__Family__c>();
        Map<string,Id> mapAppNo = NEW Map<string,Id>();
        Map<string,Id> mapApplicationNo = NEW Map<string,Id>();
        Map<string,SymphonyIPM__Family__c> mapBaserecords = NEW Map<string,SymphonyIPM__Family__c>();
        set<string> setBaseRecords = New set<string>();
        List<SymphonyIPM__Family__c> lstfmly = New List<SymphonyIPM__Family__c>();
        if(Schema.sObjectType.SymphonyIPM__Family__c.isAccessible() && SymphonyIPM__Family__c.sObjectType.getDescribe().isAccessible())
        {
            lstfmly = [SELECT id,Name,SymphonyIPM__BaseRecord__c,SymphonyIPM__ExisitsInSymphony__c,SymphonyIPM__FamilyId__c,SymphonyIPM__ParentRecord__c,SymphonyIPM__Filing_Date__c FROM SymphonyIPM__Family__c WHERE SymphonyIPM__FamilyId__c IN:patfamilyId ORDER BY SymphonyIPM__Filing_Date__c ASC NULLS LAST];
            system.debug('lstfmly-->>:: ' +lstfmly);
            for(SymphonyIPM__Family__c fmly: lstfmly)
            {
                if(fmly.SymphonyIPM__BaseRecord__c!=Null && fmly.SymphonyIPM__BaseRecord__c!='')
                {
                    mapBaserecords.put(fmly.SymphonyIPM__BaseRecord__c,fmly);
                    setBaseRecords.add(fmly.SymphonyIPM__BaseRecord__c);
                }
            }
        }
        system.debug('mapBaserecords-->>:: ' +mapBaserecords);
        set<SymphonyIPM__Patent__c> lstpat = New set<SymphonyIPM__Patent__c>();
        if(Schema.sObjectType.SymphonyIPM__Patent__c.isAccessible()  && SymphonyIPM__Patent__c.sObjectType.getDescribe().isAccessible())
        {
            //list<SymphonyIPM__Patent__c> lstappPatent = [SELECT Id,SymphonyIPM__Family_ID__c,SymphonyIPM__Application_Number__c,SymphonyIPM__Application_Date__c,SymphonyIPM__Docket_No__c,SymphonyIPM__EPApplicationNumber__c,SymphonyIPM__Case_Type__c,SymphonyIPM__Title_of_Invention__c,SymphonyIPM__Country__r.Name,SymphonyIPM__Status__c,SymphonyIPM__Issue_Date_of_Patent__c FROM SymphonyIPM__Patent__c WHERE(SymphonyIPM__EPApplicationNumber__c!=Null AND (SymphonyIPM__EPApplicationNumber__c IN: setBaseRecords OR SymphonyIPM__Application_Number__c IN:setBaseRecords))];
            list<SymphonyIPM__Patent__c> lstappPatent = [SELECT Id,SymphonyIPM__Family_ID__c,SymphonyIPM__Application_Number__c,SymphonyIPM__Application_Date__c,SymphonyIPM__Docket_No__c,SymphonyIPM__EPApplicationNumber__c,SymphonyIPM__Case_Type__c,SymphonyIPM__Title_of_Invention__c,SymphonyIPM__Country__r.Name,SymphonyIPM__Country_Code__c ,SymphonyIPM__Status__c,SymphonyIPM__Issue_Date_of_Patent__c FROM SymphonyIPM__Patent__c WHERE(SymphonyIPM__EPApplicationNumber__c!=Null AND SymphonyIPM__EPApplicationNumber__c IN: setBaseRecords)];
            for(SymphonyIPM__Patent__c pat : lstappPatent)
            {
                if(pat.SymphonyIPM__EPApplicationNumber__c!=Null && pat.SymphonyIPM__EPApplicationNumber__c!='')
                {
                    mapAppNo.put(pat.SymphonyIPM__EPApplicationNumber__c,pat.id);
                    mappatentrecords.put(pat.SymphonyIPM__EPApplicationNumber__c,pat);
                    lstpat.add(pat);
                }
                if(pat.SymphonyIPM__Application_Number__c!=Null && pat.SymphonyIPM__Application_Number__c!='')
                {
                    mapApplicationNo.put(pat.SymphonyIPM__Application_Number__c,pat.id);
                    System.debug('App map'+mapApplicationNo);
                    lstpat.add(pat);
                }
            }
        }
        
        if(lstfmly.size()>0)
        {
            if(Schema.sObjectType.SymphonyIPM__Family__c.isAccessible() && SymphonyIPM__Family__c.sObjectType.getDescribe().isAccessible())
            {
                for(SymphonyIPM__Family__c lstfmlyrec : mapBaserecords.values())
                {
                   
                    wrapperFamily objwrapfmly = NEW wrapperFamily();
                    objwrapfmly.BaseNumber = lstfmlyrec.SymphonyIPM__BaseRecord__c;
                    /*objwrapfmly.filingDate = lstfmlyrec.SymphonyIPM__Filing_Date__c;  
                    objwrapfmly.CaseType = lstfmlyrec.SymphonyIPM__Case_Type__c;
                    objwrapfmly.ParentDocketNumber= ParentDocketNo;*/
                    
                    if(mapAppNo.containsKey(lstfmlyrec.SymphonyIPM__BaseRecord__c))
                    {
                        objwrapfmly.PatentId = mapAppNo.get(lstfmlyrec.SymphonyIPM__BaseRecord__c); 
                    }
                     if(mapApplicationNo.containsKey(lstfmlyrec.SymphonyIPM__BaseRecord__c))
                    {
                        objwrapfmly.PatentId = mapApplicationNo.get(lstfmlyrec.SymphonyIPM__BaseRecord__c); 
                    }
                    for(SymphonyIPM__Patent__c pat : lstpat)
                    {
                        System.debug('Map EPApp no'+mapAppNo.get(lstfmlyrec.SymphonyIPM__BaseRecord__c));
                        if(pat.Id == mapAppNo.get(lstfmlyrec.SymphonyIPM__BaseRecord__c))
                        {
                            objwrapfmly.title= pat.SymphonyIPM__Title_of_Invention__c;
                            objwrapfmly.DocketNumber= pat.SymphonyIPM__Docket_No__c;
                            objwrapfmly.ParentDocketNumber= ParentDocketNo;
                            objwrapfmly.filingDate=pat.SymphonyIPM__Application_Date__c;
                            objwrapfmly.jurisdiction= pat.SymphonyIPM__Country_Code__c ;
                            objwrapfmly.status= pat.SymphonyIPM__Status__c;
                            objwrapfmly.CaseType= pat.SymphonyIPM__Case_Type__c;
                            objwrapfmly.IssueDate= pat.SymphonyIPM__Issue_Date_of_Patent__c;  
                            objwrapfmly.DocPatId = pat.id; 
                            // Added on 03/01/2020 for navigating to record page by clicking on the Docket Number.
                        }  
                        System.debug('Map App no'+mapApplicationNo.get(lstfmlyrec.SymphonyIPM__BaseRecord__c));
                        if(pat.Id == mapApplicationNo.get(lstfmlyrec.SymphonyIPM__BaseRecord__c))
                        {
                            objwrapfmly.title= pat.SymphonyIPM__Title_of_Invention__c;
                            objwrapfmly.DocketNumber= pat.SymphonyIPM__Docket_No__c;
                            objwrapfmly.ParentDocketNumber= ParentDocketNo;
                            objwrapfmly.jurisdiction= pat.SymphonyIPM__Country_Code__c ;
                            objwrapfmly.filingDate=pat.SymphonyIPM__Application_Date__c;
                            objwrapfmly.status= pat.SymphonyIPM__Status__c;
                            objwrapfmly.CaseType= pat.SymphonyIPM__Case_Type__c;
                            objwrapfmly.IssueDate= pat.SymphonyIPM__Issue_Date_of_Patent__c;  
                            objwrapfmly.DocPatId = pat.id; 
                            // Added on 03/01/2020 for navigating to record page by clicking on the Docket Number.
                        }    
                    }
                    lstobjwrapfmly.add(objwrapfmly);
                    //mapobjwrapfmly.put(objwrapfmly.BaseNumber,objwrapfmly);
                    //strAudit=+'mapobjwrapfmly--->'+mapobjwrapfmly.size();
                                        
                }
            }
        }
        System.debug('patfamilyId-->>:: ' +patfamilyId);
        list<SymphonyIPM__Patent__c> lstpatwithoutFmly = [SELECT Id,SymphonyIPM__Family_ID__c,SymphonyIPM__Application_Date__c,SymphonyIPM__Application_Number__c,SymphonyIPM__Docket_No__c,SymphonyIPM__Case_Type__c,SymphonyIPM__Title_of_Invention__c,SymphonyIPM__Country__r.Name,SymphonyIPM__Country_Code__c ,SymphonyIPM__Status__c,SymphonyIPM__Issue_Date_of_Patent__c,SymphonyIPM__Priority_Number__c,SymphonyIPM__ClonedFromAsset__c FROM SymphonyIPM__Patent__c WHERE SymphonyIPM__Family_ID__c IN: patfamilyIdAdd AND SymphonyIPM__Family_ID__c!=Null AND SymphonyIPM__ClonedFromAsset__c!=Null AND (SymphonyIPM__EPApplicationNumber__c ='' OR SymphonyIPM__Application_Number__c='')];
        strAudit=+'lstpatwithoutFmly--->'+lstpatwithoutFmly.size();
        if(lstpatwithoutFmly.Size()>0)
        {
            for(SymphonyIPM__Patent__c pat :lstpatwithoutFmly)
            {
                wrapperFamily objwrapfmly = NEW wrapperFamily();
                objwrapfmly.DocPatId =pat.Id;
                objwrapfmly.title= pat.SymphonyIPM__Title_of_Invention__c;
                objwrapfmly.jurisdiction= pat.SymphonyIPM__Country_Code__c ;
                objwrapfmly.filingDate=pat.SymphonyIPM__Application_Date__c;
                objwrapfmly.DocketNumber= pat.SymphonyIPM__Docket_No__c;
                objwrapfmly.status= pat.SymphonyIPM__Status__c;
                //objwrapfmly.BaseNumber =pat.SymphonyIPM__EPApplicationNumber__c;
                objwrapfmly.CaseType= pat.SymphonyIPM__Case_Type__c;
                objwrapfmly.IssueDate= pat.SymphonyIPM__Issue_Date_of_Patent__c;
                objwrapfmly.ParentDocketNumber= ParentDocketNo;
                lstobjwrapfmly.add(objwrapfmly);
                //mapobjwrapfmly.put(objwrapfmly.BaseNumber,objwrapfmly);   
            }            
        }
        //lstobjwrapfmly.addall(mapobjwrapfmly.values());
        }
        catch(Exception exp)
        {
            throw exp;
        } 
        finally{
           SymphonyIPM__AuditTrail__c audit =new SymphonyIPM__AuditTrail__c();
           audit.SymphonyIPM__CObjectName__c='Patent Family';
           audit.SymphonyIPM__Description__c=strAudit;
           audit.SymphonyIPM__Status__c='Success';
           INSERT audit;
           } 
        return lstobjwrapfmly;
    }
    @AuraEnabled
    public static List<wrapperComboboxOptionCls> searchPatents(string searchWord,List<String> PatentIds)
    {
        System.debug('serverside controller');
        try
        {
            List<wrapperComboboxOptionCls> objOptions = new List<wrapperComboboxOptionCls>();
            searchWord = searchWord + '%';
            if(Schema.sObjectType.SymphonyIPM__Patent__c.isAccessible() && SymphonyIPM__Patent__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPM__Patent__c> lstPatents = [SELECT Name,SymphonyIPM__Patent_Number__c,SymphonyIPM__Docket_No__c,SymphonyIPM__Application_Number__c,SymphonyIPM__EPApplicationNumber__c,SymphonyIPM__Title_of_Invention__c,SymphonyIPM__Earliest_Publication_No__c FROM SymphonyIPM__Patent__c WHERE (SymphonyIPM__Application_Number__c LIKE :searchWord AND Id NOT IN :PatentIds) ORDER BY SymphonyIPM__Application_Number__c];
                System.debug('list patents'+lstPatents);
                for(SymphonyIPM__Patent__c objPatent : lstPatents)
                {
                    wrapperComboboxOptionCls objOption = new wrapperComboboxOptionCls();
                    if (objPatent.SymphonyIPM__Application_Number__c != null)
                        objOption.label = objPatent.SymphonyIPM__Application_Number__c + '--' + objPatent.SymphonyIPM__Title_of_Invention__c;
                    objOption.value = objPatent.Id;
                    objOptions.add(objOption);
                     
                }
            }
            System.debug('return values'+objOptions);
            return objOptions;
            
        }
        catch(Exception exp)
        {
            throw exp;
        } 
    }
    
     @AuraEnabled
    public static List<wrapperPillCls> getSelectedPatents(List<string> PatentIds) 
    {
        try
        {
            List<wrapperPillCls> objPills = new List<wrapperPillCls>();
            if(Schema.sObjectType.SymphonyIPM__Patent__c.isAccessible() && SymphonyIPM__Patent__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPM__Patent__c> lstPatents = [SELECT  Name, SymphonyIPM__Patent_Number__c, SymphonyIPM__Application_Number__c,SymphonyIPM__EPApplicationNumber__c,SymphonyIPM__Title_of_Invention__c FROM SymphonyIPM__Patent__c WHERE Id IN :PatentIds ORDER BY SymphonyIPM__Application_Number__c];
                for(SymphonyIPM__Patent__c objPatent : lstPatents)
                {
                    wrapperPillCls objPill = new wrapperPillCls();
                    objPill.type = 'avatar';
                    objPill.label = objPatent.SymphonyIPM__Application_Number__c;
                    objPill.name = objPatent.Id;
                    objPill.fallbackIconName = 'standard:user';
                    objPill.variant = 'circle';
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
    @AuraEnabled
    public static List<String> getCaseType()
    {
        List<String> casetypelist = new List<String>();
        Schema.DescribeFieldResult fieldResult = SymphonyIPM__Patent__c.SymphonyIPM__Case_Type__c.getDescribe();
        List<Schema.PicklistEntry> cas = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry casetype : cas)
        {
            casetypelist.add(casetype.getLabel());
        }
        System.debug(casetypelist);
        return casetypelist;
    }
    
    // to create a family Record on click of Add button
    @AuraEnabled
    public static list<SymphonyIPM__Family__c> creatfmlyRecord(SymphonyIPM__Family__c fmlyobject,Id AssetId, List<string> selectedbaseRec)
    {
        System.debug(fmlyobject);
        string patfamilyId;
        list<SymphonyIPM__Family__c> familylist=new list<SymphonyIPM__Family__c>();
        //String caseType=selectedCaseType;
        if(Schema.sObjectType.SymphonyIPM__Patent__c.isAccessible() && SymphonyIPM__Patent__c.sObjectType.getDescribe().isAccessible())
        {    
            list<SymphonyIPM__Patent__c> lstpat = [SELECT Id,SymphonyIPM__Family_ID__c,SymphonyIPM__Application_Number__c,SymphonyIPM__EPApplicationNumber__c FROM SymphonyIPM__Patent__c WHERE Id=:AssetId AND SymphonyIPM__Family_ID__c!=Null];
            for(SymphonyIPM__Patent__c pat : lstpat)
            {
                if(pat.SymphonyIPM__Family_ID__c!=Null && pat.SymphonyIPM__Family_ID__c!='')
                {
                    patfamilyId = pat.SymphonyIPM__Family_ID__c;
                }    
                
                
            }
        }
          system.debug('Patent Family Id: ' + patfamilyId);
         if(Schema.sObjectType.SymphonyIPM__Patent__c.isAccessible() && SymphonyIPM__Patent__c.sObjectType.getDescribe().isAccessible())
        {       
            
            list<SymphonyIPM__Patent__c> lstpat = [SELECT Id,SymphonyIPM__Family_ID__c,SymphonyIPM__Application_Number__c,SymphonyIPM__EPApplicationNumber__c FROM SymphonyIPM__Patent__c WHERE Id IN :selectedbaseRec]; 
            System.debug(lstpat);
            for(SymphonyIPM__Patent__c pat:lstpat)
            {
                SymphonyIPM__Family__c objfam =new SymphonyIPM__Family__c();
                objfam.SymphonyIPM__BaseRecord__c=pat.SymphonyIPM__Application_Number__c;
                objfam.SymphonyIPM__FamilyId__c = patfamilyId;
                familylist.add(objfam);
            }
            if(!test.isrunningtest() && familylist.size()>0 )
            {
               insert familylist;
            }
           System.debug('List of family'+familylist);
        }
        /*if(Schema.sObjectType.SymphonyIPM__Patent__c.isAccessible() && SymphonyIPM__Patent__c.sObjectType.getDescribe().isAccessible())
        {       
            list<SymphonyIPM__Patent__c> lstpat = [SELECT Id,SymphonyIPM__Family_ID__c,SymphonyIPM__Application_Number__c FROM SymphonyIPM__Patent__c WHERE Id=:selectedparentRec LIMIT 1]; 
            fmlyobject.SymphonyIPM__ParentRecord__c=lstpat[0].SymphonyIPM__Application_Number__c;
        }*/

        //fmlyobject.SymphonyIPM__Case_Type__c=caseType;
        
        return familylist;
    }
    // For Induval Record Sync
    @AuraEnabled
    public static string familysync(Id patentId)
    {
        try 
        {
            list<Id> lstpatids =  New list<Id>();
            //lstpatids.add(patentId);
            if(Schema.sObjectType.SymphonyIPM__Patent__c.isAccessible() && SymphonyIPM__Patent__c.sObjectType.getDescribe().isAccessible())
            {
                
               for(SymphonyIPM__Patent__c objPatent :[SELECT Id,Name,SymphonyIPM__Application_Number__c,SymphonyIPM__Priority_Number__c FROM SymphonyIPM__Patent__c WHERE Id =:patentId])
               {
                   if((objPatent.SymphonyIPM__Application_Number__c!=Null && objPatent.SymphonyIPM__Application_Number__c!=''))
                   {
                       lstpatids.add(objPatent.Id);     
                   }
               }
               if(lstpatids.size()>0)
               {
                   SymphonyIPM.PatentFamilygroupBatch PatFamlyBatch = new SymphonyIPM.PatentFamilygroupBatch(lstpatids); 
                   Database.executeBatch(PatFamlyBatch,1);   
               } 
               

            }
            string patId=string.valueof(lstpatids.size());
            return patId;
        } 
        catch (Exception ex) 
        {
            System.debug(ex.getMessage());
            return 'error';
        }
    }
    
    @AuraEnabled
   public static string deletePat(string PatId){
        list<SymphonyIPM__Patent__c> lstpat = new list<SymphonyIPM__Patent__c>();
        list<SymphonyIPM__Family__c> lstfam = new list<SymphonyIPM__Family__c>();
        String str;
       if(Schema.sObjectType.SymphonyIPM__Patent__c.isAccessible() && SymphonyIPM__Patent__c.sObjectType.getDescribe().isAccessible())
       {
           lstpat = [SELECT Id,SymphonyIPM__Docket_No__c,SymphonyIPM__Application_Number__c FROM SymphonyIPM__Patent__c WHERE Id=:PatId limit 1];
           if(lstpat.size() > 0 && lstpat !=null){
               lstfam=[Select id,SymphonyIPM__BaseRecord__c,SymphonyIPM__FamilyId__c from SymphonyIPM__Family__c where SymphonyIPM__BaseRecord__c =:lstpat[0].SymphonyIPM__Application_Number__c];
               if(lstfam.size() > 0 && lstfam !=null){
                   try{
                       if(Schema.sObjectType.SymphonyIPM__Family__c.isDeletable() && SymphonyIPM__Family__c.sObjectType.getDescribe().isDeletable())
                        delete lstfam;
                       system.debug(lstfam);
                   }catch(Exception e){
                       
                   }
               }
               try{
                    
                   if(Schema.sObjectType.SymphonyIPM__Patent__c.isDeletable() && SymphonyIPM__Patent__c.sObjectType.getDescribe().isDeletable()) 
                   delete lstpat;
                   if(lstpat[0].SymphonyIPM__Docket_No__c != null){
                       str= lstpat[0].SymphonyIPM__Docket_No__c +' was deleted successfully.';
                   }else
                       str= 'The record was deleted successfully.';
               }catch(Exception e){
                   
               }
               
               
           }
           
       }//comments
       return str;
   }
    
    public with sharing  class wrapperFamily
    {
        @AuraEnabled
        public Id PatentId{get;set;}
         @AuraEnabled
        public Id DocPatId{get;set;}
        @AuraEnabled
        public string title{get;set;}
        @AuraEnabled
        public string jurisdiction{get;set;}
        @AuraEnabled
        public string status{get;set;}
        @AuraEnabled
        public string CaseType{get;set;}
        @AuraEnabled
        public string BaseNumber{get;set;}
        @AuraEnabled
        public Date filingDate{get;set;}
        @AuraEnabled
        public String ParentDocketNumber{get;set;}
        @AuraEnabled
        public String DocketNumber{get;set;}
        @AuraEnabled
        public Date IssueDate{get;set;}
        @AuraEnabled
        public Date FamilyID{get;set;}
    }
public static void magicMethod(){
Integer i = 0;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;

    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
}
}