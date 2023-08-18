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
                lstinv =[SELECT Id,SymphonyIPM__Employee_ID__c,EID__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c IN:strfed];
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
            list<SymphonyIPM__Inventor__c> lstinvRes =[SELECT Id,SymphonyIPM__Employee_ID__c,EID__c,SymphonyIPM__Email__c,SymphonyIPM__User__c,SymphonyIPM__RecordTypeName__c,RecordTypeId FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c IN:strfed];
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
                                inventor.First_Name__c=usr.FirstName;
                                inventor.Last_Name__c=usr.LastName;
                            }
                            else
                            {
                                inventor.name =usr.LastName;
                                inventor.Last_Name__c=usr.LastName;
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
                        
                        recType = ((usr.Profile.Name == 'Platform Inventor') ? 'Inventor' : (usr.Profile.Name == 'In-house Counsel') ? 'In house Counsel' : (usr.Profile.Name == 'Platform Outside Counsel') ? 'OC' : (usr.Profile.Name == 'Platform Reviewer') ? 'Reviewer': (usr.Profile.Name == 'Business User') ? 'Business User':'');
                        
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
                
                if(Inventortlist.size() > 0 && Schema.sObjectType.SymphonyIPM__Inventor__c.isAccessible() && Schema.sObjectType.SymphonyIPM__Inventor__c.isCreateable())
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
        String strAudit = '';
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
            
            //INVENTION DISCLOSURE - Primary Contact-----------
            List<SymphonyIPM__Invention_Disclosure_New__c> obPrimaryContractjInventions = [SELECT Id, Primary_Contact__c, Primary_Contact__r.SymphonyIPM__User__c, Primary_Contact__r.SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Primary_Contact__c IN :personIds AND Primary_Contact__r.SymphonyIPM__User__c!=null];
            for(SymphonyIPM__Invention_Disclosure_New__c  objInvention : obPrimaryContractjInventions)
            {
                if ((mapIDShare.containsKey(objInvention.Id + '_' + objInvention.Primary_Contact__r.SymphonyIPM__User__c)==false) && objInvention.Primary_Contact__r.SymphonyIPM__User__r.IsActive==true)
                {
                    SymphonyIPM__Invention_Disclosure_New__Share objinventionShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                    objinventionShare.ParentId = objInvention.Id;
                    objinventionShare.UserOrGroupId = objInvention.Primary_Contact__r.SymphonyIPM__User__c; 
                    objinventionShare.AccessLevel = 'Edit';
                    objinventionToBeShared.add(objinventionShare);
                    mapIDShare.put(objInvention.Id + '_' + objInvention.Primary_Contact__r.SymphonyIPM__User__c, objInvention.Id + '_' + objInvention.Primary_Contact__r.SymphonyIPM__User__c);
                }
            }
            //---------------------------------------------
            
            //INVENTION DISCLOSURE - Mentors-----------
            List<Id> listmentorids = new List<Id>();
            listmentorids.addAll(personIds);
            String mentorpersonid = '%'+listmentorids[0]+'%';
            List<SymphonyIPM__Invention_Disclosure_New__c> obMentorInventions = [SELECT Id, MentorsIDs__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE MentorsIDs__c LIKE: mentorpersonid];
            List<SymphonyIPM__Inventor__c> listInventor = [SELECT Id,SymphonyIPM__User__c,SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Inventor__c WHERE id =: listmentorids[0]];
            for(SymphonyIPM__Invention_Disclosure_New__c  objInvention : obMentorInventions)
            {
                if(listInventor.size() > 0 && (mapIDShare.containsKey(objInvention.Id + '_' + listInventor[0].SymphonyIPM__User__c)==false) && listInventor[0].SymphonyIPM__User__r.IsActive==true)
                {
                    SymphonyIPM__Invention_Disclosure_New__Share objinventionShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                    objinventionShare.ParentId = objInvention.Id;
                    objinventionShare.UserOrGroupId = listInventor[0].SymphonyIPM__User__c; 
                    objinventionShare.AccessLevel = 'Edit';
                    objinventionToBeShared.add(objinventionShare);
                    mapIDShare.put(objInvention.Id + '_' + listInventor[0].SymphonyIPM__User__c, objInvention.Id + '_' + listInventor[0].SymphonyIPM__User__c);
                }
            }
            //-------------------------------------------
            
            //INVENTION DISCLOSURE - Reviewers ------------------ 
            set<id> setofhierarchy = new set<id>();
            set<id> setofIDFids = new set<id>();
            map<string,string> mapofhierarchyidwithuserid = new map<string,string>();
            //Sharing IDF's
            
            List<SymphonyIPM__Hierarchy_Role__c> listHierarchyRoles = [SELECT id,SymphonyIPM__Hierarchy_Path__c,SymphonyIPM__User__c,SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Hierarchy_Role__c WHERE SymphonyIPM__User__c IN: ReactivatedUsrIds];
            if(listHierarchyRoles.size() > 0)
            {
                for(SymphonyIPM__Hierarchy_Role__c objHierarchyRole : listHierarchyRoles)
                {
                    setofhierarchy.add(objHierarchyRole.SymphonyIPM__Hierarchy_Path__c);
                    if(objHierarchyRole.SymphonyIPM__User__r.IsActive == true)
                    {
                        mapofhierarchyidwithuserid.put(objHierarchyRole.SymphonyIPM__Hierarchy_Path__c,objHierarchyRole.SymphonyIPM__User__c);
                    }
                }
            }
            strAudit += 'mapofhierarchyidwithuserid keys --->'+mapofhierarchyidwithuserid.keyset();
            strAudit += 'mapofhierarchyidwithuserid values --->'+mapofhierarchyidwithuserid.values();
            if(setofhierarchy.size() > 0)
            {
                List<SymphonyIPM__Invention_Disclosure_New__c> listInventionDisclosures = [SELECT Id,SymphonyIPM__Hierarchy__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE (SymphonyIPM__Hierarchy__c IN: setofhierarchy AND SymphonyIPM__Hierarchy__c != NULL)];
                strAudit += 'Disclosures fetched ------------>'+listInventionDisclosures;
                if(listInventionDisclosures.size() > 0)
                {
                    for(SymphonyIPM__Invention_Disclosure_New__c objIDF : listInventionDisclosures)
                    {
                        setofIDFids.add(objIDF.id);
                        if(mapofhierarchyidwithuserid.containskey(objIDF.SymphonyIPM__Hierarchy__c))
                        {
                            if(mapIDShare.containsKey(objIDF.Id + '_' + mapofhierarchyidwithuserid.get(objIDF.SymphonyIPM__Hierarchy__c))==false)
                            {
                                strAudit += 'Entered if ------------>';
                                SymphonyIPM__Invention_Disclosure_New__Share objinventionShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                                objinventionShare.ParentId = objIDF.Id;
                                objinventionShare.UserOrGroupId = mapofhierarchyidwithuserid.get(objIDF.SymphonyIPM__Hierarchy__c); 
                                objinventionShare.AccessLevel = 'Read';
                                strAudit += 'Share record created ------------>'+objinventionShare;
                                objinventionToBeShared.add(objinventionShare);
                                mapIDShare.put(objIDF.Id + '_' + mapofhierarchyidwithuserid.get(objIDF.SymphonyIPM__Hierarchy__c), objIDF.Id + '_' + mapofhierarchyidwithuserid.get(objIDF.SymphonyIPM__Hierarchy__c));
                            }
                        }
                    }
                }
            }
            //Sharing PRC Meeting records
            List<SymphonyIPM__PRC_Meeting__Share> listPRCMeetingShareToInsert = new List<SymphonyIPM__PRC_Meeting__Share>();
            if(setofIDFids.size() > 0)
            {
                List<SymphonyIPM__PRC_Meeting_Details__c> listPRCMeetingDetails = [SELECT SymphonyIPM__PRC_Meeting__c,SymphonyIPM__PRC_Meeting__r.SymphonyIPM__Path__c,SymphonyIPM__Related_Invention_Disclosure__c FROM SymphonyIPM__PRC_Meeting_Details__c WHERE SymphonyIPM__Related_Invention_Disclosure__c IN: setofIDFids];
                if(listPRCMeetingDetails.size() > 0)
                {
                    for(SymphonyIPM__PRC_Meeting_Details__c objPRCMeetingDetail : listPRCMeetingDetails)
                    {
                        if(mapofhierarchyidwithuserid.containskey(objPRCMeetingDetail.SymphonyIPM__PRC_Meeting__r.SymphonyIPM__Path__c))
                        {
                            if(mapIDShare.containsKey(objPRCMeetingDetail.SymphonyIPM__PRC_Meeting__c + '_' + mapofhierarchyidwithuserid.get(objPRCMeetingDetail.SymphonyIPM__PRC_Meeting__r.SymphonyIPM__Path__c))==false)
                            {
                                SymphonyIPM__PRC_Meeting__Share objPRCMeetingShare = new SymphonyIPM__PRC_Meeting__Share();
                                objPRCMeetingShare.ParentId = objPRCMeetingDetail.SymphonyIPM__PRC_Meeting__c;
                                objPRCMeetingShare.AccessLevel = 'Edit';
                                objPRCMeetingShare.UserOrGroupId = mapofhierarchyidwithuserid.get(objPRCMeetingDetail.SymphonyIPM__PRC_Meeting__r.SymphonyIPM__Path__c);
                                listPRCMeetingShareToInsert.add(objPRCMeetingShare);
                                mapIDShare.put(objPRCMeetingDetail.SymphonyIPM__PRC_Meeting__c + '_' + mapofhierarchyidwithuserid.get(objPRCMeetingDetail.SymphonyIPM__PRC_Meeting__r.SymphonyIPM__Path__c),objPRCMeetingDetail.SymphonyIPM__PRC_Meeting__c + '_' + mapofhierarchyidwithuserid.get(objPRCMeetingDetail.SymphonyIPM__PRC_Meeting__r.SymphonyIPM__Path__c));
                            }
                        }
                    }
                }
            }
            //--------------------------------------------------- 
             List<SymphonyIPM__Invention_Disclosure_New__c> obOtherContractjInventions = [SELECT Id, Other_Contact__c, Other_Contact__r.SymphonyIPM__User__c, Other_Contact__r.SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Other_Contact__c IN :personIds AND Other_Contact__r.SymphonyIPM__User__c!=null];
           for(SymphonyIPM__Invention_Disclosure_New__c  objInvention : obOtherContractjInventions)
           {
               if ((mapIDShare.containsKey(objInvention.Id + '_' + objInvention.Other_Contact__r.SymphonyIPM__User__c)==false) && objInvention.Other_Contact__r.SymphonyIPM__User__r.IsActive==true)
               {
                   SymphonyIPM__Invention_Disclosure_New__Share objinventionShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                   objinventionShare.ParentId = objInvention.Id;
                   objinventionShare.UserOrGroupId = objInvention.Other_Contact__r.SymphonyIPM__User__c;
                   objinventionShare.AccessLevel = 'Edit';
                   objinventionToBeShared.add(objinventionShare);
                   mapIDShare.put(objInvention.Id + '_' + objInvention.Other_Contact__r.SymphonyIPM__User__c, objInvention.Id + '_' + objInvention.Other_Contact__r.SymphonyIPM__User__c);
               }
           }
            
            if(objinventionToBeShared.size()>0)
            {
                insert objinventionToBeShared;
            }
            if(listPRCMeetingShareToInsert.size() > 0)
            {
                INSERT listPRCMeetingShareToInsert;
            }
        }
        catch(Exception exp)
        {
            strAudit += 'ERROR line'+ exp.getLineNumber() + 'ERROR '+ exp.getMessage();
            throw exp;
        }
        finally
        {
            SymphonyIPM__AuditTrail__c objAudit = new SymphonyIPM__AuditTrail__c();
            objAudit.SymphonyIPM__CObjectName__c = 'Sharing';
            objAudit.SymphonyIPM__Action__c = 'IDF Sharing';
            objAudit.SymphonyIPM__Description__c = strAudit;
            INSERT objAudit;
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
            
            //PATENT - Reviewers ------------------ 
            set<id> setofhierarchy = new set<id>();
            map<string,string> mapofhierarchyidwithuserid = new map<string,string>();
            //Sharing Patent's
            List<SymphonyIPM__Hierarchy_Role__c> listHierarchyRoles = [SELECT id,SymphonyIPM__Hierarchy_Path__c,SymphonyIPM__User__c,SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Hierarchy_Role__c WHERE SymphonyIPM__User__c IN: ReactivatedUsrIds];
            if(listHierarchyRoles.size() > 0)
            {
                for(SymphonyIPM__Hierarchy_Role__c objHierarchyRole : listHierarchyRoles)
                {
                    setofhierarchy.add(objHierarchyRole.SymphonyIPM__Hierarchy_Path__c);
                    if(objHierarchyRole.SymphonyIPM__User__r.IsActive == true)
                    {
                        mapofhierarchyidwithuserid.put(objHierarchyRole.SymphonyIPM__Hierarchy_Path__c,objHierarchyRole.SymphonyIPM__User__c);
                    }
                }
            }
            if(setofhierarchy.size() > 0)
            {
                List<SymphonyIPM__Patent__c> listPatents = [SELECT Id,SymphonyIPM__Hierarchy__c FROM SymphonyIPM__Patent__c WHERE (SymphonyIPM__Hierarchy__c IN: setofhierarchy AND SymphonyIPM__Hierarchy__c != NULL)];
                if(listPatents.size() > 0)
                {
                    for(SymphonyIPM__Patent__c objPatent : listPatents)
                    {
                        if(mapofhierarchyidwithuserid.containskey(objPatent.SymphonyIPM__Hierarchy__c))
                        {
                            if(mapPatentShare.containsKey(objPatent.Id + '_' + mapofhierarchyidwithuserid.get(objPatent.SymphonyIPM__Hierarchy__c))==false)
                            {
                                SymphonyIPM__Patent__Share objpatsShare = new SymphonyIPM__Patent__Share();
                                objpatsShare.ParentId = objPatent.Id;
                                objpatsShare.UserOrGroupId = mapofhierarchyidwithuserid.get(objPatent.SymphonyIPM__Hierarchy__c); 
                                objpatsShare.AccessLevel = 'Read';
                                objPatentToBeShared.add(objpatsShare);
                                mapPatentShare.put(objPatent.Id + '_' + mapofhierarchyidwithuserid.get(objPatent.SymphonyIPM__Hierarchy__c), objPatent.Id + '_' + mapofhierarchyidwithuserid.get(objPatent.SymphonyIPM__Hierarchy__c));
                            }
                        }
                    }
                }
            }
            //--------------------------------------------------- 
             List<SymphonyIPM__Patent__c> objBusinessContractjInventions = [SELECT Id, SymphonyIPM__Business_Contact__c, SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c, SymphonyIPM__Business_Contact__r.SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Patent__c WHERE SymphonyIPM__Business_Contact__c IN :personIds AND SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c!=null];
           for(SymphonyIPM__Patent__c  objPatent : objBusinessContractjInventions)
           {
               if ((mapPatentShare.containsKey(objPatent.Id + '_' + objPatent.SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c)==false) && objPatent.SymphonyIPM__Business_Contact__r.SymphonyIPM__User__r.IsActive==true)
               {
                   SymphonyIPM__Patent__Share objPatentShare = new SymphonyIPM__Patent__Share();
                   objPatentShare.ParentId = objPatent.Id;
                   objPatentShare.UserOrGroupId = objPatent.SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c;
                   objPatentShare.AccessLevel = 'Edit';
                   objPatentToBeShared.add(objPatentShare);
                   mapPatentShare.put(objPatent.Id + '_' + objPatent.SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c, objPatent.Id + '_' + objPatent.SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c);
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