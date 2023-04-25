global with sharing class createInventor
{
    @future
    public static void createInventorRecord(Set<Id> userIds) 
    {
        List<User> user;
        if(Schema.sObjectType.user.isAccessible())
        {
            user = [select Id,Name, firstname, lastname, email,FederationIdentifier, Profile.Name from user where Id IN :userIds];           
            
            List<SymphonyIPM__Inventor__c> Inventortlist =null;
            SymphonyIPM__Inventor__c inventor =null;
            set<String> strfed = New set<String>();
            set<String> strempIds = New set<String>();
            list<SymphonyIPM__Inventor__c> lstinv = new list<SymphonyIPM__Inventor__c>();
            for(User u : user)
            {
                if(u.FederationIdentifier!=Null && u.FederationIdentifier!='')
                {
                    strfed.add(u.FederationIdentifier.toUpperCase().trim());
                }
            }
            system.debug('strfed: ' + strfed);
            if(strfed.size()>0)
            {
                //lstinv =[SELECT Id,SymphonyIPM__Employee_ID__c,EID__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c IN:strfed];
                lstinv =[SELECT Id,SymphonyIPM__Employee_ID__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c IN:strfed];
                for(SymphonyIPM__Inventor__c inv : lstinv)
                {
                    if((inv.SymphonyIPM__Employee_ID__c!=Null && inv.SymphonyIPM__Employee_ID__c!=''))
                    {
                        strempIds.add(inv.SymphonyIPM__Employee_ID__c.toUpperCase().trim());
                    }
                }
                system.debug('Lst Inv: ' + lstinv);
            }
            list<SymphonyIPM__Inventor__c> updateInvs = New list<SymphonyIPM__Inventor__c>();
            //list<SymphonyIPM__Inventor__c> lstinvRes =[SELECT Id,SymphonyIPM__Employee_ID__c,EID__c,SymphonyIPM__Email__c,SymphonyIPM__User__c,SymphonyIPM__RecordTypeName__c,RecordTypeId FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c IN:strfed];
            list<SymphonyIPM__Inventor__c> lstinvRes =[SELECT Id,SymphonyIPM__Employee_ID__c,SymphonyIPM__Email__c,SymphonyIPM__User__c,SymphonyIPM__RecordTypeName__c,RecordTypeId FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c IN:strfed];
            if(lstinvRes.size()>0)
            {
                for(SymphonyIPM__Inventor__c inv : lstinvRes)
                {
                    if(inv.SymphonyIPM__User__c==Null)
                    {
                        string recType;
                        for(User u : User)
                        {
                            inv.SymphonyIPM__User__c = u.id;
                            recType = ((u.Profile.Name == 'Platform Inventor') ? 'Inventor' : (u.Profile.Name == 'In-house Counsel') ? 'In house Counsel' : (u.Profile.Name == 'Platform Outside Counsel') ? 'OC' : '');                         
                            if(!test.isrunningtest())
                            {
                                if (Schema.sObjectType.SymphonyIPM__Inventor__c.fields.RecordTypeId.isCreateable() && Schema.sObjectType.SymphonyIPM__Inventor__c.fields.RecordTypeId.isAccessible())
                                    if(recType!=Null && recType!='')
                                {
                                    inv.RecordTypeId = Schema.SObjectType.SymphonyIPM__Inventor__c.getRecordTypeInfosByName().get(recType).getRecordTypeId();

                                        inv.SymphonyIPM__Email__c=u.Email;
                                    
                                }
                            } 
                            updateInvs.add(inv);
                        }
                    }
                }
            }
            if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isAccessible() && SymphonyIPM__Inventor__c.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.SymphonyIPM__Inventor__c.isCreateable() )
            {
                Inventortlist = new List<SymphonyIPM__Inventor__c>();
                for (User usr : User) 
                {
                    string uppercasefedId;
                    if(usr.FederationIdentifier!=Null)
                    {
                        uppercasefedId = usr.FederationIdentifier.toUpperCase().trim();
                    }
                     
                    if(!strempIds.contains(uppercasefedId))
                    {
                        inventor = new SymphonyIPM__Inventor__c();
                        string recType;
                        if(Schema.sObjectType.SymphonyIPM__Inventor__c.fields.name.isCreateable() && Schema.sObjectType.SymphonyIPM__Inventor__c.fields.name.isAccessible())
                        {
                            //inventor.name =usr.name;
                            if(usr.FirstName !='')
                            {
                                inventor.name =usr.FirstName + ' ' + usr.LastName;
                                inventor.SymphonyIPM__FirstName__c=usr.FirstName;
                                inventor.SymphonyIPM__LastName__c=usr.LastName;
                            }
                            else
                            {
                                inventor.name =usr.LastName;
                                inventor.SymphonyIPM__LastName__c=usr.LastName;
                            }
                        }    
                        if (Schema.sObjectType.SymphonyIPM__Inventor__c.fields.SymphonyIPM__CitizenshipPicklist__c.isCreateable() && Schema.sObjectType.SymphonyIPM__Inventor__c.fields.SymphonyIPM__CitizenshipPicklist__c.isAccessible())
                            inventor.SymphonyIPM__CitizenshipPicklist__c='None';
                        if (Schema.sObjectType.SymphonyIPM__Inventor__c.fields.SymphonyIPM__Location__c.isCreateable() && Schema.sObjectType.SymphonyIPM__Inventor__c.fields.SymphonyIPM__Location__c.isAccessible())
                            inventor.SymphonyIPM__Location__c='None';
                        
                            if (Schema.sObjectType.SymphonyIPM__Inventor__c.fields.SymphonyIPM__Email__c.isCreateable() && Schema.sObjectType.SymphonyIPM__Inventor__c.fields.SymphonyIPM__Email__c.isAccessible())
                                inventor.SymphonyIPM__Email__c=usr.Email;
                        
                        inventor.SymphonyIPM__Employee_ID__c = usr.FederationIdentifier;
                        
                        if (Schema.sObjectType.SymphonyIPM__Inventor__c.fields.SymphonyIPM__User__c.isCreateable() && Schema.sObjectType.SymphonyIPM__Inventor__c.fields.SymphonyIPM__User__c.isAccessible())
                            inventor.SymphonyIPM__User__c = usr.id;
                        
                        recType = ((usr.Profile.Name == 'Platform Inventor') ? 'Inventor' : (usr.Profile.Name == 'In-house Counsel') ? 'In house Counsel' : (usr.Profile.Name == 'Platform Outside Counsel') ? 'OC' : ''); 
                        
                        if(!test.isrunningtest())
                        {
                            if (Schema.sObjectType.SymphonyIPM__Inventor__c.fields.RecordTypeId.isCreateable() && Schema.sObjectType.SymphonyIPM__Inventor__c.fields.RecordTypeId.isAccessible())
                                if(recType!=Null && recType!='')
                            {
                                inventor.RecordTypeId = Schema.SObjectType.SymphonyIPM__Inventor__c.getRecordTypeInfosByName().get(recType).getRecordTypeId();
                            }
                        }                    
                        if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && Schema.sObjectType.SymphonyIPM__Inventor__c.isCreateable())
                            Inventortlist.add(inventor);
                    }
                }
                
                if(Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && Schema.sObjectType.SymphonyIPM__Inventor__c.isCreateable())
                    insert Inventortlist; 
                
                //Code added on 16-08-2019 by Anand for sharing records (IDF, Patent & Awards) with newly created SSO Users
                if(Inventortlist.size()>0)
                {
                    system.debug('Inventortlist.size:>>>>>>>> ' + Inventortlist.size());
                    CreateShareRecords(Inventortlist);
                }                          
            }
            if(updateInvs.size()>0)
            {
                update updateInvs;
                system.debug('updateInvs.size:>>>>>>>> ' + updateInvs.size());
                CreateShareRecords(updateInvs);
            }
            
        }
    }
    
    //Code added on 16-08-2019 by Anand for sharing records (IDF, Patent & Awards) with newly created SSO Users
    //@future
    public static void CreateShareRecords(List<SymphonyIPM__Inventor__c> LstInventors)
    {
        system.debug('CreateShareRecords>>>>>>> Start');
        Set<Id> personIds = New Set<Id>();
        Set<Id> UserIdsSet = new Set<Id>(); 
        List<SymphonyIPM__Invention_Disclosure_New__Share> objinventionToBeShared = new List<SymphonyIPM__Invention_Disclosure_New__Share>();
        List<SymphonyIPM__Patent__Share> objPatentToBeShared = new List<SymphonyIPM__Patent__Share>();
        
        for(SymphonyIPM__Inventor__c objInv : LstInventors)
        {
            if(objInv.SymphonyIPM__RecordTypeName__c =='Inventor' || objInv.SymphonyIPM__RecordTypeName__c =='Platform Inventor')
            {
               personIds.add(objInv.Id);
               UserIdsSet.add(objInv.SymphonyIPM__User__c);   
            }
        }
        
        system.debug('UserIdsSet.size:>>>>>>>> ' + UserIdsSet.size());
        system.debug('personIds.size:>>>>>>>> ' + personIds.size());
        
        //Get all IDF share records for the User
        List<SymphonyIPM__Invention_Disclosure_New__Share> InventionsToBeShared = [SELECT ParentId, UserOrGroupId FROM SymphonyIPM__Invention_Disclosure_New__Share Where UserOrGroupId IN :UserIdsSet];
        Map<string,string> mapIDShare = new Map<string,string>();
        for(SymphonyIPM__Invention_Disclosure_New__Share objInventionShare : InventionsToBeShared)
        {
            if(mapIDShare.containsKey(objInventionShare.ParentId + '_' + objInventionShare.UserOrGroupId)==false)
            {
                mapIDShare.put(objInventionShare.ParentId + '_' +objInventionShare.UserOrGroupId,objInventionShare.ParentId + '_' +objInventionShare.UserOrGroupId);
            }
        }
        
        //Get all Patent share records for the User
        List<SymphonyIPM__Patent__Share> PatentsToBeShared = [SELECT ParentId, UserOrGroupId FROM SymphonyIPM__Patent__Share Where UserOrGroupId IN :UserIdsSet];
        Map<string,string> mapPatentShare = new Map<string,string>();
        for(SymphonyIPM__Patent__Share objPatentShare : PatentsToBeShared)
        {
            if(mapPatentShare.containsKey(objPatentShare.ParentId + '_' + objPatentShare.UserOrGroupId)==false)
            {
                mapPatentShare.put(objPatentShare.ParentId + '_' +objPatentShare.UserOrGroupId, objPatentShare.ParentId + '_' +objPatentShare.UserOrGroupId);
            }
        }
        
        //Get all Invention Disclosure Award records for the User
        Map<string, Id> mapInventorAwardExistingShare = new Map<string, Id>();
        List<SymphonyIPM__Inventor_Award_v1__share> objInventorAwardShareToBeInsertedList = new List<SymphonyIPM__Inventor_Award_v1__share>();
        List<SymphonyIPM__Inventor_Award_v1__share> objInventorAwardExistingShareList = [SELECT Id, ParentId, UserOrGroupId FROM SymphonyIPM__Inventor_Award_v1__share WHERE UserOrGroupId IN :UserIdsSet];
        for(SymphonyIPM__Inventor_Award_v1__share objInventorAwardShare : objInventorAwardExistingShareList)
        {
            if (mapInventorAwardExistingShare.containsKey(objInventorAwardShare.ParentId + '_' + objInventorAwardShare.UserOrGroupId)==false)
            {
                mapInventorAwardExistingShare.put(objInventorAwardShare.ParentId + '_' + objInventorAwardShare.UserOrGroupId, objInventorAwardShare.ParentId + '_' + objInventorAwardShare.UserOrGroupId);
            }
        }
                
        if(personIds.size()>0)
        {
            //INVENTION DISCLOSURE - Additional Inventors
            List<SymphonyIPM__Additional_Inventor__c> lstAddInvs =[SELECT Id,SymphonyIPM__Invention_Disclosure_New__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__c,SymphonyIPM__Inventor__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Inventor__c IN: personIds];
            if(lstAddInvs.size()>0)
            {
                for(SymphonyIPM__Additional_Inventor__c addInvs : lstAddInvs)
                {
                    if(mapIDShare.containsKey(addInvs.SymphonyIPM__Invention_Disclosure_New__c+ '_' + addInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c)==false)
                    {
                        if(addInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c!=null)
                        {
                            SymphonyIPM__Invention_Disclosure_New__Share objinventionShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                            objinventionShare.ParentId = addInvs.SymphonyIPM__Invention_Disclosure_New__c;
                            objinventionShare.UserOrGroupId = addInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c; 
                            objinventionShare.AccessLevel = 'Edit';
                            objinventionToBeShared.add(objinventionShare);
                            mapIDShare.put(addInvs.SymphonyIPM__Invention_Disclosure_New__c+ '_' + addInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c, addInvs.SymphonyIPM__Invention_Disclosure_New__c+ '_' + addInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c);
                        }
                    }
                }                    
            }
            
            //INVENTION DISCLOSURE - Primary Inventors
            List<SymphonyIPM__Invention_Disclosure_New__c> objInventions = [SELECT Id, SymphonyIPM__Primary_Inventor__c, SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c, SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Invention_Disclosure_New__c WHERE SymphonyIPM__Primary_Inventor__c IN :personIds AND SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c!=null];
            for(SymphonyIPM__Invention_Disclosure_New__c  objInvention : objInventions)
            {
                if ((mapIDShare.containsKey(objInvention.Id + '_' + objInvention.SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c)==false) && objInvention.SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__r.IsActive==true)
                {
                    SymphonyIPM__Invention_Disclosure_New__Share objinventionShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                    objinventionShare.ParentId = objInvention.Id;
                    objinventionShare.UserOrGroupId = objInvention.SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c; 
                    objinventionShare.AccessLevel = 'Edit';
                    objinventionToBeShared.add(objinventionShare);
                    mapIDShare.put(objInvention.Id + '_' + objInvention.SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c, objInvention.Id + '_' + objInvention.SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c);
                }
            }
            
            //PATENT - Asset Inventors
            list<SymphonyIPM__Asset_Inventor_v1__c> lstAstInvs = [SELECT Id,SymphonyIPM__Asset__c,SymphonyIPM__Inventor__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__c FROM SymphonyIPM__Asset_Inventor_v1__c WHERE SymphonyIPM__Inventor__c IN : personIds];
            if(lstAstInvs.size()>0)
            {
                for(SymphonyIPM__Asset_Inventor_v1__c astInvs : lstAstInvs)
                {
                    if(mapPatentShare.containsKey(astInvs.SymphonyIPM__Asset__c+ '_' + astInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c)==false)
                    {
                        if(astInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c!=null)
                        {
                            SymphonyIPM__Patent__Share objpatsShare = new SymphonyIPM__Patent__Share();
                            objpatsShare.ParentId = astInvs.SymphonyIPM__Asset__c;
                            objpatsShare.UserOrGroupId = astInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c; 
                            objpatsShare.AccessLevel = 'Edit';
                            objPatentToBeShared.add(objpatsShare);
                            mapPatentShare.put(astInvs.SymphonyIPM__Asset__c+ '_' + astInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c, astInvs.SymphonyIPM__Asset__c+ '_' + astInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c);
                        }
                    }
                }
            }
            
            //PATENT - Primary Inventors
            List<SymphonyIPM__Patent__c> objPatents = [SELECT Id, SymphonyIPM__First_Named_Inventor__c, SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c, SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Patent__c WHERE SymphonyIPM__First_Named_Inventor__c IN :personIds AND SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c!=null];
            for(SymphonyIPM__Patent__c objPatent : objPatents)
            {
                if ((mapPatentShare.containsKey(objPatent.Id + '_' + objPatent.SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c)==false) && objPatent.SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__r.IsActive==true)
                {
                    SymphonyIPM__Patent__Share objpatsShare = new SymphonyIPM__Patent__Share();
                    objpatsShare.ParentId = objPatent.Id;
                    objpatsShare.UserOrGroupId = objPatent.SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c; 
                    objpatsShare.AccessLevel = 'Edit';
                    objPatentToBeShared.add(objpatsShare);
                    mapPatentShare.put(objPatent.Id + '_' + objPatent.SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c, objPatent.Id + '_' + objPatent.SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c);
                }
            }
            
            //INVENTOR AWARDS
            List<SymphonyIPM__Inventor_Award_v1__c> objInventorAwardList = [SELECT Id, SymphonyIPM__Inventor__r.SymphonyIPM__User__c, SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive, SymphonyIPM__Approver__c, SymphonyIPM__Approver__r.IsActive FROM SymphonyIPM__Inventor_Award_v1__c WHERE (SymphonyIPM__Inventor__r.SymphonyIPM__User__c IN :personIds OR SymphonyIPM__Approver__c IN :personIds)];
            for (SymphonyIPM__Inventor_Award_v1__c objInventorAward : objInventorAwardList)
            {
                if (Schema.sObjectType.SymphonyIPM__Inventor_Award_v1__c.fields.SymphonyIPM__Inventor__c.isAccessible())
                {
                    if 
                    (
                        objInventorAward.SymphonyIPM__Inventor__c != null 
                        && objInventorAward.SymphonyIPM__Inventor__r.SymphonyIPM__User__c != null 
                        && objInventorAward.SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive == true 
                        && mapInventorAwardExistingShare.containsKey(objInventorAward.Id + '_' + objInventorAward.SymphonyIPM__Inventor__r.SymphonyIPM__User__c)==false
                    )
                    {
                        SymphonyIPM__Inventor_Award_v1__share objInventorAwardInventorShare = new SymphonyIPM__Inventor_Award_v1__share();
                        objInventorAwardInventorShare.ParentId = objInventorAward.Id;
                        objInventorAwardInventorShare.UserOrGroupId = objInventorAward.SymphonyIPM__Inventor__r.SymphonyIPM__User__c;
                        objInventorAwardInventorShare.Accesslevel = 'Read';
                        //objInventorAwardInventorShare.RowCause = Schema.SymphonyIPM__Inventor_Award_v1__share.RowCause.SymphonyIPM__Inventor__c;
                        objInventorAwardShareToBeInsertedList.add(objInventorAwardInventorShare);
                        mapInventorAwardExistingShare.put(objInventorAward.Id + '_' + objInventorAward.SymphonyIPM__Inventor__r.SymphonyIPM__User__c, objInventorAward.Id);
                    }
                    if 
                    (
                        objInventorAward.SymphonyIPM__Approver__c != null 
                        && objInventorAward.SymphonyIPM__Approver__r.IsActive == true 
                        && mapInventorAwardExistingShare.containsKey(objInventorAward.Id + '_' + objInventorAward.SymphonyIPM__Approver__c)==false
                    )
                    {
                        SymphonyIPM__Inventor_Award_v1__share objInventorAwardApproverShare = new SymphonyIPM__Inventor_Award_v1__share();
                        objInventorAwardApproverShare.ParentId = objInventorAward.Id;
                        objInventorAwardApproverShare.UserOrGroupId = objInventorAward.SymphonyIPM__Approver__c;
                        objInventorAwardApproverShare.Accesslevel = 'Edit';
                        //objInventorAwardApproverShare.RowCause = Schema.SymphonyIPM__Inventor_Award_v1__share.RowCause.SymphonyIPM__Approver__c;
                        objInventorAwardShareToBeInsertedList.add(objInventorAwardApproverShare);
                        mapInventorAwardExistingShare.put(objInventorAward.Id + '_' + objInventorAward.SymphonyIPM__Approver__c, objInventorAward.Id);
                    }
                }
            }
        }
        system.debug('objinventionToBeShared.size:>>>>>>>> ' + objinventionToBeShared.size());
        if(objinventionToBeShared.size()>0)
        {
            insert objinventionToBeShared;
        }
        system.debug('objPatentToBeShared.size:>>>>>>>> ' + objPatentToBeShared.size());
        if(objPatentToBeShared.size()>0)
        {
            insert objPatentToBeShared;
        }
        if(objInventorAwardShareToBeInsertedList.size()>0)
        {
            insert objInventorAwardShareToBeInsertedList;
        }           
    }
    
    @future
    public static void shareInventionDisclosure(set<Id> ReactivatedUsrIds, set<Id> personIds)
    {
        try
        {
            List<SymphonyIPM__Invention_Disclosure_New__Share> objinventionToBeShared = new List<SymphonyIPM__Invention_Disclosure_New__Share>();
            //Read shared details of Invention Disclosures
            Map<string,string> mapIDShare = new Map<string,string>();
            List<SymphonyIPM__Invention_Disclosure_New__Share> objInventionShares = [SELECT ParentId, UserOrGroupId FROM SymphonyIPM__Invention_Disclosure_New__Share WHERE UserOrGroupId IN :ReactivatedUsrIds];
            for(SymphonyIPM__Invention_Disclosure_New__Share objInventionShare : objInventionShares)
            {
                if (mapIDShare.containsKey(objInventionShare.ParentId + '_' + objInventionShare.UserOrGroupId)==false)
                    mapIDShare.put(objInventionShare.ParentId + '_' + objInventionShare.UserOrGroupId,objInventionShare.ParentId + '_' + objInventionShare.UserOrGroupId);
            }
            
            //INVENTION DISCLOSURE - Primary Inventors
            List<SymphonyIPM__Invention_Disclosure_New__c> objInventions = [SELECT Id, SymphonyIPM__Primary_Inventor__c, SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c, SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Invention_Disclosure_New__c WHERE SymphonyIPM__Primary_Inventor__c IN :personIds AND SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c!=null];
            for(SymphonyIPM__Invention_Disclosure_New__c  objInvention : objInventions)
            {
                if ((mapIDShare.containsKey(objInvention.Id + '_' + objInvention.SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c)==false) && objInvention.SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__r.IsActive==true)
                {
                    SymphonyIPM__Invention_Disclosure_New__Share objinventionShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                    objinventionShare.ParentId = objInvention.Id;
                    objinventionShare.UserOrGroupId = objInvention.SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c; 
                    objinventionShare.AccessLevel = 'Edit';
                    objinventionToBeShared.add(objinventionShare);
                    mapIDShare.put(objInvention.Id + '_' + objInvention.SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c, objInvention.Id + '_' + objInvention.SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c);
                }
            }

            //INVENTION DISCLOSURE - Additional Inventors
            list<SymphonyIPM__Additional_Inventor__c> lstAddInvs =[SELECT Id, SymphonyIPM__Invention_Disclosure_New__c, SymphonyIPM__Inventor__r.SymphonyIPM__User__c, SymphonyIPM__Inventor__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Inventor__c IN: personIds];
            If(lstAddInvs.size()>0)
            {
                for(SymphonyIPM__Additional_Inventor__c addInvs : lstAddInvs)
                {
                    if(addInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c!=null)
                    {
                        if (mapIDShare.containsKey(addInvs.SymphonyIPM__Invention_Disclosure_New__c + '_' + addInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c)==false)
                        {
                            SymphonyIPM__Invention_Disclosure_New__Share objinventionShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                            objinventionShare.ParentId = addInvs.SymphonyIPM__Invention_Disclosure_New__c;
                            objinventionShare.UserOrGroupId = addInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c; 
                            objinventionShare.AccessLevel = 'Edit';
                            objinventionToBeShared.add(objinventionShare);
                            mapIDShare.put(addInvs.SymphonyIPM__Invention_Disclosure_New__c + '_' + addInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c, addInvs.SymphonyIPM__Invention_Disclosure_New__c + '_' + addInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c);
                        }
                    }
                }                    
            }
            
            if(objinventionToBeShared.size()>0)
            {
                insert objinventionToBeShared;
            }
        }
        catch(Exception exp)
        {
        }
    }
    
    @future
    public static void sharePatent(set<Id> ReactivatedUsrIds, set<Id> personIds)
    {
        try
        {
            List<SymphonyIPM__Patent__Share> objPatentToBeShared = new List<SymphonyIPM__Patent__Share>();
            //Read shared details of Patents
            Map<string,string> mapPatentShare = new Map<string,string>();
            List<SymphonyIPM__Patent__Share> objPatentShares = [SELECT ParentId, UserOrGroupId FROM SymphonyIPM__Patent__Share WHERE UserOrGroupId IN :ReactivatedUsrIds];
            for(SymphonyIPM__Patent__Share objPatentShare : objPatentShares)
            {
                if (mapPatentShare.containsKey(objPatentShare.ParentId + '_' + objPatentShare.UserOrGroupId)==false)
                    mapPatentShare.put(objPatentShare.ParentId + '_' + objPatentShare.UserOrGroupId, objPatentShare.ParentId + '_' + objPatentShare.UserOrGroupId);
            }
            
            //PATENT - Primary Inventors
            List<SymphonyIPM__Patent__c> objPatents = [SELECT Id, SymphonyIPM__First_Named_Inventor__c, SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c, SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Patent__c WHERE SymphonyIPM__First_Named_Inventor__c IN :personIds AND SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c!=null];
            for(SymphonyIPM__Patent__c objPatent : objPatents)
            {
                if ((mapPatentShare.containsKey(objPatent.Id + '_' + objPatent.SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c)==false) && objPatent.SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__r.IsActive==true)
                {
                    SymphonyIPM__Patent__Share objpatsShare = new SymphonyIPM__Patent__Share();
                    objpatsShare.ParentId = objPatent.Id;
                    objpatsShare.UserOrGroupId = objPatent.SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c; 
                    objpatsShare.AccessLevel = 'Edit';
                    objPatentToBeShared.add(objpatsShare);
                    mapPatentShare.put(objPatent.Id + '_' + objPatent.SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c, objPatent.Id + '_' + objPatent.SymphonyIPM__First_Named_Inventor__r.SymphonyIPM__User__c);
                }
            }
            
            //PATENT - Asset Inventors
            list<SymphonyIPM__Asset_Inventor_v1__c> lstAstInvs = [SELECT Id,SymphonyIPM__Asset__c,SymphonyIPM__Inventor__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__c FROM SymphonyIPM__Asset_Inventor_v1__c WHERE SymphonyIPM__Inventor__c IN : personIds];
            if(lstAstInvs.size()>0)
            {
                for(SymphonyIPM__Asset_Inventor_v1__c astInvs : lstAstInvs)
                {
                    if(astInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c!=null)
                    {
                        if (mapPatentShare.containsKey(astInvs.SymphonyIPM__Asset__c + '_' + astInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c)==false)
                        {
                            SymphonyIPM__Patent__Share objpatsShare = new SymphonyIPM__Patent__Share();
                            objpatsShare.ParentId = astInvs.SymphonyIPM__Asset__c;
                            objpatsShare.UserOrGroupId = astInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c; 
                            objpatsShare.AccessLevel = 'Edit';
                            objPatentToBeShared.add(objpatsShare);
                            mapPatentShare.put(astInvs.SymphonyIPM__Asset__c + '_' + astInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c, astInvs.SymphonyIPM__Asset__c + '_' + astInvs.SymphonyIPM__Inventor__r.SymphonyIPM__User__c);
                        }
                    }
                }
            }
            
            if(objPatentToBeShared.size()>0)
            {
                insert objPatentToBeShared;
            }
        }
        catch(Exception exp)
        {
        }
    }
     @future
   
    public static void shareInventorAwards(set<Id> ReactivatedUsrIds, set<Id> personIds)
    {
        try
        {
            List<SymphonyIPM__Inventor_Award_v1__share> objInventorAwardShareToBeInsertedList = new List<SymphonyIPM__Inventor_Award_v1__share>();
            
            //Read shared details of Invention Disclosure Award
            Map<string, Id> mapInventorAwardExistingShare = new Map<string, Id>();
            List<SymphonyIPM__Inventor_Award_v1__share> objInventorAwardExistingShareList = [SELECT Id, ParentId, UserOrGroupId FROM SymphonyIPM__Inventor_Award_v1__share WHERE UserOrGroupId IN :ReactivatedUsrIds];
            for(SymphonyIPM__Inventor_Award_v1__share objInventorAwardShare : objInventorAwardExistingShareList)
            {
                if (mapInventorAwardExistingShare.containsKey(objInventorAwardShare.ParentId + '_' + objInventorAwardShare.UserOrGroupId)==false)
                    mapInventorAwardExistingShare.put(objInventorAwardShare.ParentId + '_' + objInventorAwardShare.UserOrGroupId, objInventorAwardShare.Id);
            }
            
            //INVENTOR AWARDS
            List<SymphonyIPM__Inventor_Award_v1__c> objInventorAwardList = [SELECT Id, SymphonyIPM__Inventor__r.SymphonyIPM__User__c, SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive, SymphonyIPM__Approver__c, SymphonyIPM__Approver__r.IsActive FROM SymphonyIPM__Inventor_Award_v1__c WHERE (SymphonyIPM__Inventor__r.SymphonyIPM__User__c IN :personIds OR SymphonyIPM__Approver__c IN :personIds)];
            for (SymphonyIPM__Inventor_Award_v1__c objInventorAward : objInventorAwardList)
            {
                if (Schema.sObjectType.SymphonyIPM__Inventor_Award_v1__c.fields.SymphonyIPM__Inventor__c.isAccessible())
                {
                    if 
                    (
                        objInventorAward.SymphonyIPM__Inventor__c != null 
                        && objInventorAward.SymphonyIPM__Inventor__r.SymphonyIPM__User__c != null 
                        && objInventorAward.SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive == true 
                        && mapInventorAwardExistingShare.containsKey(objInventorAward.Id + '_' + objInventorAward.SymphonyIPM__Inventor__r.SymphonyIPM__User__c)==false
                    )
                    {
                        SymphonyIPM__Inventor_Award_v1__share objInventorAwardInventorShare = new SymphonyIPM__Inventor_Award_v1__share();
                        objInventorAwardInventorShare.ParentId = objInventorAward.Id;
                        objInventorAwardInventorShare.UserOrGroupId = objInventorAward.SymphonyIPM__Inventor__r.SymphonyIPM__User__c;
                        objInventorAwardInventorShare.Accesslevel = 'Read';
                        objInventorAwardInventorShare.RowCause = Schema.SymphonyIPM__Inventor_Award_v1__share.RowCause.SymphonyIPM__Inventor__c;
                        objInventorAwardShareToBeInsertedList.add(objInventorAwardInventorShare);
                        mapInventorAwardExistingShare.put(objInventorAward.Id + '_' + objInventorAward.SymphonyIPM__Inventor__r.SymphonyIPM__User__c, objInventorAward.Id);
                    }
                    if 
                    (
                        objInventorAward.SymphonyIPM__Approver__c != null 
                        && objInventorAward.SymphonyIPM__Approver__r.IsActive == true 
                        && mapInventorAwardExistingShare.containsKey(objInventorAward.Id + '_' + objInventorAward.SymphonyIPM__Approver__c)==false
                    )
                    {
                        SymphonyIPM__Inventor_Award_v1__share objInventorAwardApproverShare = new SymphonyIPM__Inventor_Award_v1__share();
                        objInventorAwardApproverShare.ParentId = objInventorAward.Id;
                        objInventorAwardApproverShare.UserOrGroupId = objInventorAward.SymphonyIPM__Approver__c;
                        objInventorAwardApproverShare.Accesslevel = 'Edit';
                        objInventorAwardApproverShare.RowCause = Schema.SymphonyIPM__Inventor_Award_v1__share.RowCause.SymphonyIPM__Approver__c;
                        objInventorAwardShareToBeInsertedList.add(objInventorAwardApproverShare);
                        mapInventorAwardExistingShare.put(objInventorAward.Id + '_' + objInventorAward.SymphonyIPM__Approver__c, objInventorAward.Id);
                    }
                }
            }
            if(objInventorAwardShareToBeInsertedList.size()>0)
            {
                insert objInventorAwardShareToBeInsertedList;
            }
        }
        catch(Exception exp)
        {
        }
    }
    
    public static void CalcSSO(Integer cnt)
    {
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;
        cnt=cnt+1;   
    }
}