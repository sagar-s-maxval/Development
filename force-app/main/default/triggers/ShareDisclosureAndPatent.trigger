trigger ShareDisclosureAndPatent on SymphonyIPM__Inventor__c (after Insert, after update,before update) {
       
    	//Codded by Juveria on 27-03-2020 for sharing disclosure and patent when user is updated in person record.
    	List<SymphonyIPM__Inventor__c> ObjNewPersonsList = new List<SymphonyIPM__Inventor__c>();
        list<SymphonyIPM__Invention_Disclosure_New__c> objIDFList = new list<SymphonyIPM__Invention_Disclosure_New__c>();
        list<SymphonyIPM__Additional_Inventor__c> IDFRelatedToAddInv =new  list<SymphonyIPM__Additional_Inventor__c>();
        List<SymphonyIPM__Asset_Inventor_v1__c> listOfAssetInv =new List<SymphonyIPM__Asset_Inventor_v1__c>();
   
    if(trigger.IsUpdate && trigger.IsBefore)
    {
        Set<Id> ObjOldUsersList = new Set<Id>();
        Set<Id> setofDisclosure = new Set<Id>();
        Set<Id> setofPatent = new Set<Id>();
        for(Id personObjId : Trigger.newMap.keySet())
        {   
            //System.debug('New Map after update' + Trigger.newMap.keySet());
            if(Trigger.oldMap.get(personObjId).SymphonyIPM__User__c != Trigger.newMap.get(personObjId).SymphonyIPM__User__c )
            {   
               /* System.debug('old user>>>>>'+ Trigger.oldMap.get(personObjId).SymphonyIPM__User__c);
                System.debug('new user>>>>>'+ Trigger.newMap.get(personObjId).SymphonyIPM__User__c);
                System.debug('profile name of user>>>>>'+ Trigger.oldMap.get(personObjId).SymphonyIPM__RecordTypeName__c);
                System.debug('new person record>>>>>'+ Trigger.newMap.get(personObjId));
                System.debug('new person record>>>>>'+ Trigger.newMap.get(personObjId)); */
                if( Trigger.oldMap.get(personObjId).SymphonyIPM__User__c != null && Trigger.oldMap.get(personObjId).SymphonyIPM__RecordTypeName__c =='Inventor') //&& Trigger.oldMap.get(personObjId).SymphonyIPM__User__r.Profile.Name=='Platform Inventor'
                {
                    ObjOldUsersList.add(Trigger.oldMap.get(personObjId).SymphonyIPM__User__c);
                  //System.debug('ObjOldUsersList size>>>>>>>>>>>>'+ ObjOldUsersList.size());
                }
            }
        }
    
    
     if(ObjOldUsersList != null && ObjOldUsersList.size() > 0)
        {   
           //querying disclosure records
            IDFRelatedToAddInv =[Select Id,SymphonyIPM__Invention_Disclosure_New__c,SymphonyIPM__Inventor__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__c from SymphonyIPM__Additional_Inventor__c where ((SymphonyIPM__Inventor__r.SymphonyIPM__User__c IN : ObjOldUsersList) AND( SymphonyIPM__Invention_Disclosure_New__c != null))];    
            if(!IDFRelatedToAddInv.IsEmpty()){
                for(SymphonyIPM__Additional_Inventor__c listidf : IDFRelatedToAddInv){
                    setofDisclosure.add(listidf.SymphonyIPM__Invention_Disclosure_New__c);
                }
            }
    		listOfAssetInv=[Select Id,SymphonyIPM__Asset__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__c  From SymphonyIPM__Asset_Inventor_v1__c where SymphonyIPM__Inventor__r.SymphonyIPM__User__c IN : ObjOldUsersList AND SymphonyIPM__Asset__c != null ];
            if(!listOfAssetInv.IsEmpty()){
                for(SymphonyIPM__Asset_Inventor_v1__c listasset : listOfAssetInv){
                    setofPatent.add(listasset.SymphonyIPM__Asset__c);
                }
             }
            if(!setofPatent.IsEmpty()){
                //System.debug(setofPatent + '<<<<<setofPatent');
                //System.debug(setofPatent.size() + '<<<<<setofPatent');
                List<SymphonyIPM__Patent__Share> ObjExistingPatentShare =[Select Id,UserOrGroupId,ParentId  From SymphonyIPM__Patent__Share Where ((ParentId IN : setofPatent) AND  (RowCause = 'Manual' OR RowCause = 'SymphonyIPM__Other_Inventor__c' OR RowCause != 'Owner' ) AND (UserOrGroupId IN : ObjOldUsersList) )];
                if(!ObjExistingPatentShare.IsEmpty())
           	    {    
                   Database.DeleteResult[] drList= Database.delete(ObjExistingPatentShare,false);
                  //delete ObjExistingPatentShare;
                  /* for(Database.DeleteResult dr : drList) {
                       if (dr.isSuccess()) {
                           // Operation was successful, so get the ID of the record that was processed
                           System.debug('Successfully deleted account with ID: ' + dr.getId());
                       }
                       else {
                           // Operation failed, so get all errors                
                           for(Database.Error err : dr.getErrors()) {
                               System.debug('The following error has occurred.');                    
                               System.debug(err.getStatusCode() + ': ' + err.getMessage());
                               System.debug('Disclosure fields that affected this error: ' + err.getFields());
                           }
                       }
                   }
                   System.debug('ObjExistingIDFShare after delete' + drList); */
               }
            }
                
           if(!setofDisclosure.IsEmpty())
           {
              // System.debug(setofDisclosure + '<<<<<setofDisclosure');
              // System.debug(setofDisclosure.size() + '<<<<<setofDisclosure');
              // System.debug('set contains this disc'+ setofDisclosure.contains('a1Qc0000003Ny6ZEAS'));
               List<SymphonyIPM__Invention_Disclosure_New__Share> ObjExistingIDFShare = [Select Id,UserOrGroupId,ParentId  From SymphonyIPM__Invention_Disclosure_New__Share Where ((ParentId IN : setofDisclosure) AND (RowCause = 'Manual' OR RowCause = 'SymphonyIPM__Other_Inventor__c' OR RowCause != 'Owner') AND (UserOrGroupId IN : ObjOldUsersList))];//AND (UserOrGroupId IN : ObjOldUsersList)
               if(!ObjExistingIDFShare.IsEmpty())
               {    
                   System.debug('ObjExistingIDFShare before delete' + ObjExistingIDFShare);
                   Database.DeleteResult[] drList= Database.delete(ObjExistingIDFShare,false);
                   //delete ObjExistingIDFShare;
                  /* for(Database.DeleteResult dr : drList) {
                       if (dr.isSuccess()) {
                           // Operation was successful, so get the ID of the record that was processed
                           System.debug('Successfully deleted account with ID: ' + dr.getId());
                       }
                       else {
                           // Operation failed, so get all errors                
                           for(Database.Error err : dr.getErrors()) {
                               System.debug('The following error has occurred.');                    
                               System.debug(err.getStatusCode() + ': ' + err.getMessage());
                               System.debug('Disclosure fields that affected this error: ' + err.getFields());
                           }
                       }
                   }
                   System.debug('ObjExistingIDFShare after delete' + drList);*/
                   
               }
           }
        } 
    }

  
    if(trigger.IsUpdate && trigger.IsAfter)
    {
        Set<Id> ObjOldPersonIds = new Set<Id>();
        Set<Id> ObjNewPersonIds = new Set<Id>();
        Set<Id> ObjOldUsersList = new Set<Id>();
        Set<Id> ObjNewUsersList = new Set<Id>();
        Set<Id> setofDisclosure = new Set<Id>();
        Set<Id> setofPatent = new Set<Id>();
        Set<Id> ObjOldIDFList = new Set<Id>();
        List<SymphonyIPM__Invention_Disclosure_New__Share> ObjNewIDFShareList = new List<SymphonyIPM__Invention_Disclosure_New__Share>();
        List<SymphonyIPM__Patent__Share> ObjNewPatentShareList = new List<SymphonyIPM__Patent__Share>();
        for(Id personObjId : Trigger.newMap.keySet())
        {   
            System.debug('New Map after update' + Trigger.newMap.keySet());
            if(Trigger.oldMap.get(personObjId).SymphonyIPM__User__c != Trigger.newMap.get(personObjId).SymphonyIPM__User__c )
            {   
              /*System.debug('old user>>>>>'+ Trigger.oldMap.get(personObjId).SymphonyIPM__User__c);
                System.debug('new user>>>>>'+ Trigger.newMap.get(personObjId).SymphonyIPM__User__c);
                System.debug('profile name of user>>>>>'+ Trigger.oldMap.get(personObjId).SymphonyIPM__RecordTypeName__c);
                System.debug('new person record>>>>>'+ Trigger.newMap.get(personObjId));
                System.debug('new person record>>>>>'+ Trigger.newMap.get(personObjId)); */
                if( Trigger.oldMap.get(personObjId).SymphonyIPM__User__c != null && Trigger.oldMap.get(personObjId).SymphonyIPM__RecordTypeName__c =='Inventor') //&& Trigger.oldMap.get(personObjId).SymphonyIPM__User__r.Profile.Name=='Platform Inventor'
                {
                    ObjOldUsersList.add(Trigger.oldMap.get(personObjId).SymphonyIPM__User__c);
                  //System.debug('ObjOldUsersList size>>>>>>>>>>>>'+ ObjOldUsersList.size());
                }
                if(Trigger.newMap.get(personObjId).SymphonyIPM__User__c != null && Trigger.newMap.get(personObjId).SymphonyIPM__RecordTypeName__c =='Inventor') //&& Trigger.newMap.get(personObjId).SymphonyIPM__User__r.Profile.Name=='Platform Inventor'
                {
                    ObjNewPersonsList.add(Trigger.newMap.get(personObjId));
                   /* system.debug('ObjNewPersonsList>>>>>>>>>>>' + ObjNewPersonsList);
                     System.debug('ObjNewPersonsList size>>>>>>>>>>>>'+ ObjNewPersonsList.size()); */
                }
            }
        }

        if(ObjNewPersonsList != null && ObjNewPersonsList.size() > 0)
        {
            Set<Id> ObjNewUserIds = new Set<Id>();
            if(!ObjNewPersonsList.IsEmpty())
            {
                for(SymphonyIPM__Inventor__c ObjPer : ObjNewPersonsList)
                {
                    ObjNewUserIds.add(ObjPer.SymphonyIPM__User__c);
                    system.debug('ObjNewLawFirmIds>>>>>>>>>>>>>>>>' + ObjNewUserIds);
                }
                 //list<SymphonyIPM__Invention_Disclosure_New__c> objIDFList = [Select Id,SymphonyIPM__Primary_Inventor__c,SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c from SymphonyIPM__Invention_Disclosure_New__c where SymphonyIPM__Primary_Inventor__r.SymphonyIPM__User__c IN : ObjNewUserIds ];
                 IDFRelatedToAddInv =[Select Id,SymphonyIPM__Invention_Disclosure_New__c,SymphonyIPM__Inventor__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__c from SymphonyIPM__Additional_Inventor__c where SymphonyIPM__Inventor__r.SymphonyIPM__User__c IN : ObjNewUserIds AND SymphonyIPM__Invention_Disclosure_New__c != null AND SymphonyIPM__Inventor__r.SymphonyIPM__User__r.isActive = true];  
                 listOfAssetInv=[Select Id,SymphonyIPM__Asset__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__c  From SymphonyIPM__Asset_Inventor_v1__c where SymphonyIPM__Inventor__r.SymphonyIPM__User__c IN : ObjNewUserIds AND SymphonyIPM__Asset__c != null AND SymphonyIPM__Inventor__r.SymphonyIPM__User__r.isActive = true ];
                if(!IDFRelatedToAddInv.IsEmpty())
                {
                    for(SymphonyIPM__Additional_Inventor__c ObjIDF : IDFRelatedToAddInv)
                    {
                        for(SymphonyIPM__Inventor__c objNewPer : ObjNewPersonsList)
                        {
                            if(ObjIDF.SymphonyIPM__Inventor__r.SymphonyIPM__User__c == objNewPer.SymphonyIPM__User__c) 
                            {
                                //System.debug('AddInv'+ objNewPer.SymphonyIPM__User__c);
                                SymphonyIPM__Invention_Disclosure_New__Share ObIDFShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                                ObIDFShare.AccessLevel='Edit';
                                ObIDFShare.ParentId=ObjIDF.SymphonyIPM__Invention_Disclosure_New__c;
                                ObIDFShare.UserOrGroupId=objNewPer.SymphonyIPM__User__c;
                                ObjNewIDFShareList.add(ObIDFShare);
                                
                            }
                        }
                    } 
                }
                
                if(!listOfAssetInv.IsEmpty())
                {
                    for(SymphonyIPM__Asset_Inventor_v1__c ObjPatent : listOfAssetInv)
                    {
                        for(SymphonyIPM__Inventor__c objNewPer : ObjNewPersonsList)
                        {
                            if(ObjPatent.SymphonyIPM__Inventor__r.SymphonyIPM__User__c == objNewPer.SymphonyIPM__User__c) 
                            {
                                //System.debug('AddInv'+ objNewPer.SymphonyIPM__User__c);
                                SymphonyIPM__Patent__Share ObPatShare = new SymphonyIPM__Patent__Share();
                                ObPatShare.AccessLevel='Edit';
                                ObPatShare.ParentId=ObjPatent.SymphonyIPM__Asset__c;
                                ObPatShare.UserOrGroupId=objNewPer.SymphonyIPM__User__c;
                                ObjNewPatentShareList.add(ObPatShare);
                                
                            }
                        }
                    } 
                }
                    if(!ObjNewPatentShareList.IsEmpty())
                    {
                        Database.SaveResult[] PatShareInsertRes=Database.insert(ObjNewPatentShareList,false);
                      //System.debug('ObjNewPatentShareList>>>>>>>>>>>>>>>>>>>>>'  + PatShareInsertRes);
                    }
    
                    if(!ObjNewIDFShareList.IsEmpty())
                    {
                        Database.SaveResult[] IDFShareInsertRes=Database.insert(ObjNewIDFShareList,false);// uncomment later
                        System.debug(ObjNewIDFShareList);
                    }   
            }
        }
    }

  /*  if(trigger.isInsert && trigger.isAfter){
        Set<Id> ObjNewUserIds = new Set<Id>();
        List<SymphonyIPM__Patent__Share> ObjNewPatentShareList = new List<SymphonyIPM__Patent__Share>();
        List<SymphonyIPM__Invention_Disclosure_New__Share> ObjNewIDFShareList = new List<SymphonyIPM__Invention_Disclosure_New__Share>();
        List<SymphonyIPM__Inventor__c> ObjNewPersonsList=[Select Id, SymphonyIPM__User__c,SymphonyIPM__RecordTypeName__c From SymphonyIPM__Inventor__c Where ((Id IN : Trigger.New) AND (SymphonyIPM__User__c != null) AND (SymphonyIPM__RecordTypeName__c ='Inventor'))];
        if(!ObjNewPersonsList.IsEmpty())
        {
            for(SymphonyIPM__Inventor__c ObjPer : ObjNewPersonsList)
            {
                ObjNewUserIds.add(ObjPer.SymphonyIPM__User__c);
            }
            
            IDFRelatedToAddInv =[Select Id,SymphonyIPM__Invention_Disclosure_New__c,SymphonyIPM__Inventor__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__c from SymphonyIPM__Additional_Inventor__c where SymphonyIPM__Inventor__r.SymphonyIPM__User__c IN : ObjNewUserIds AND SymphonyIPM__Invention_Disclosure_New__c != null];   
            listOfAssetInv=[Select Id,SymphonyIPM__Asset__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__c  From SymphonyIPM__Asset_Inventor_v1__c where SymphonyIPM__Inventor__r.SymphonyIPM__User__c IN : ObjNewUserIds AND SymphonyIPM__Asset__c != null ];
             
           // List<SymphonyIPM__Patent__c> ObjPatentList=[Select Id, Law_Firm__c,SymphonyIPM__Base_Invention_Disclosure_New__c from SymphonyIPM__Patent__c where Law_Firm__c IN :ObjNewUserIds];
                if(!listOfAssetInv.IsEmpty())
                {
                    for(SymphonyIPM__Asset_Inventor_v1__c ObjPatent : listOfAssetInv)
                    {
                        for(SymphonyIPM__Inventor__c objNewPer : ObjNewPersonsList)
                        {
                            if(ObjPatent.SymphonyIPM__Inventor__r.SymphonyIPM__User__c  == objNewPer.SymphonyIPM__User__c)
                            {
                                SymphonyIPM__Patent__Share ObjPatShare = new SymphonyIPM__Patent__Share();
                                ObjPatShare.AccessLevel='Edit';
                                ObjPatShare.ParentId=ObjPatent.SymphonyIPM__Asset__c;
                                ObjPatShare.UserOrGroupId=objNewPer.SymphonyIPM__User__c;
                                ObjNewPatentShareList.add(ObjPatShare);
                            } 
                        }
                    }
                }
           
                
                 if(!IDFRelatedToAddInv.IsEmpty())
                {
                    for(SymphonyIPM__Additional_Inventor__c ObjIDF : IDFRelatedToAddInv)
                    {
                        for(SymphonyIPM__Inventor__c objNewPer : ObjNewPersonsList)
                        {
                            if(ObjIDF.SymphonyIPM__Inventor__r.SymphonyIPM__User__c == objNewPer.SymphonyIPM__User__c) 
                            {
                                //System.debug('AddInv'+ objNewPer.SymphonyIPM__User__c);
                                SymphonyIPM__Invention_Disclosure_New__Share ObIDFShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                                ObIDFShare.AccessLevel='Edit';
                                ObIDFShare.ParentId=ObjIDF.SymphonyIPM__Invention_Disclosure_New__c;
                                ObIDFShare.UserOrGroupId=objNewPer.SymphonyIPM__User__c;
                                ObjNewIDFShareList.add(ObIDFShare);
                                
                            }
                        }
                    } 
                }
                if(!ObjNewPatentShareList.IsEmpty())
                {
                    Database.SaveResult[] PatShareInsertRes=Database.insert(ObjNewPatentShareList,false);
                    System.debug(ObjNewPatentShareList);
                }

                if(!ObjNewIDFShareList.IsEmpty())
                {
                    Database.SaveResult[] IDFShareInsertRes=Database.insert(ObjNewIDFShareList,false);
                    System.debug(ObjNewIDFShareList);
                }
        }
    }*/
}