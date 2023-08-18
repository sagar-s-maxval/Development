trigger trgAdditionalInventor_DeleteSharedIDF on SymphonyIPM__Additional_Inventor__c (After insert, After update,before delete) 
{   
    String CurrentUserId = UserInfo.getUserId(); 
    System.debug(CurrentUserId);
    List<SymphonyIPM__Invention_Disclosure_New__Share> objinventionShareToBeDeleted = new List<SymphonyIPM__Invention_Disclosure_New__Share>();
    Set<Id> lstInvIds = new Set<Id>();
    Set<Id> lstInvUserIds = new Set<Id>();
    
    if (Trigger.isBefore)
    {   
        if (Trigger.isDelete)
        {  
            if(Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.isAccessible() && SymphonyIPM__Additional_Inventor__c.sObjectType.getDescribe().isAccessible())
            {   
                System.debug(Trigger.Old);
                List<SymphonyIPM__Additional_Inventor__c> objInventors = [SELECT SymphonyIPM__Invention_Disclosure_New__c, SymphonyIPM__Inventor__r.SymphonyIPM__User__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive,SymphonyIPM__shared__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Inventor__r.SymphonyIPM__User__c!= null  AND Id IN :Trigger.Old AND SymphonyIPM__Inventor__r.SymphonyIPM__User__c!=:CurrentUserId];
                
                if (objInventors != null && objInventors.size()>0)
                {  
                     Set<Id> setOfDiscID = new Set<Id>();
                     Map<String,String> PriMenMap= new Map<String,String>();
                  
                     for(SymphonyIPM__Additional_Inventor__c inv: objInventors)
                     {
                       setOfDiscID.add(inv.SymphonyIPM__Invention_Disclosure_New__c);
                     }
                    for(SymphonyIPM__Invention_Disclosure_New__c invRec : [Select id,Primary_Contact__c,MentorsIDs__c from SymphonyIPM__Invention_Disclosure_New__c where Id IN :setOfDiscID ]){
                        if(invRec.Primary_Contact__c != null){
                             PriMenMap.put(invRec.Primary_Contact__c+'-'+invRec.Id,invRec.Id);
                               System.debug('PrimaryContact'+ PriMenMap);
                        }
                        if(invRec.MentorsIDs__c != null)
                        {   
                             list<String> NewPersonIDs =new list<String>();
                             if(invRec.MentorsIDs__c.contains(',')){
                                 NewPersonIDs= invRec.MentorsIDs__c.trim().split(',');
                                 System.debug('MentorsIDs'+ NewPersonIDs);
                             }
                             else if(!invRec.MentorsIDs__c.contains(',')){
                                 NewPersonIDs.add(invRec.MentorsIDs__c);  
                             }
                             if(NewPersonIDs.size() >0)
                             {
                                 for(String str :NewPersonIDs){
                                      PriMenMap.put(str+'-'+invRec.Id,invRec.Id);
                                 }
                             }
                        }
                       System.debug('PriMen'+ PriMenMap);
                    }
                    //Fetch PriMenMap for Primary contact/Mentors
                   
                    
                    for(SymphonyIPM__Additional_Inventor__c objInventor : objInventors)
                    {  
                        //Check Person Id in PriMenMap
                        if(PriMenMap.get(objInventor.SymphonyIPM__Inventor__c+'-'+objInventor.SymphonyIPM__Invention_Disclosure_New__c )== null)
                        {
                            if(Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.fields.SymphonyIPM__Invention_Disclosure_New__c.isAccessible())
                                lstInvIds.add(objInventor.SymphonyIPM__Invention_Disclosure_New__c);
                            if(Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.fields.SymphonyIPM__Inventor__c.isAccessible())
                            {  
                                if(objInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive)
                                    lstInvUserIds.add(objInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__c);
                            }
                            System.debug('There is no same person');
                        }
                        //If no person in PriMenMap -- Add to delete list
                        //If person found in PriMenMap then check PriMenMap.IDF == objInventor.IDF - DO NOT add to delete list ELSE Add
                        
                       
                        else if(PriMenMap.get(objInventor.SymphonyIPM__Inventor__c+'-'+objInventor.SymphonyIPM__Invention_Disclosure_New__c) != null){
                            if(PriMenMap.get(objInventor.SymphonyIPM__Inventor__c+'-'+objInventor.SymphonyIPM__Invention_Disclosure_New__c) == objInventor.SymphonyIPM__Invention_Disclosure_New__c)
                            {
                                System.debug('Same Record'+PriMenMap.get(objInventor.SymphonyIPM__Inventor__c+'-'+objInventor.SymphonyIPM__Invention_Disclosure_New__c) +'-----'+ objInventor.SymphonyIPM__Invention_Disclosure_New__c);
                            }
                            /*else{
                                if(Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.fields.SymphonyIPM__Invention_Disclosure_New__c.isAccessible())
                                    lstInvIds.add(objInventor.SymphonyIPM__Invention_Disclosure_New__c);
                                if(Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.fields.SymphonyIPM__Inventor__c.isAccessible())
                                {  
                                    if(objInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive)
                                        lstInvUserIds.add(objInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__c);
                                }
                            }*/
                        }
                        
                    }
                    
                    List<SymphonyIPM__Invention_Disclosure_New__c> IDFList=[Select OwnerId from SymphonyIPM__Invention_Disclosure_New__c where Id in:lstInvIds];
                    /*for(SymphonyIPM__Invention_Disclosure_New__c IDF : IDFList)
                    {
                        ownerIds.add(IDF.OwnerId);
                    }*/
                    objinventionShareToBeDeleted=[Select id from SymphonyIPM__Invention_Disclosure_New__Share where ParentId in:lstInvIds AND UserOrGroupId in:lstInvUserIds And RowCause!='Primary_Inventor__c' And RowCause!='Owner'];  // AND UserOrGroupId Not In:ownerIds
                }
            }
        } 
        if (objinventionShareToBeDeleted!= null && objinventionShareToBeDeleted.size()>0)
        {    
            System.debug('objDel'+objinventionShareToBeDeleted);
            //database.delete(objinventionShareToBeDeleted);
            Database.DeleteResult[] drList = Database.delete(objinventionShareToBeDeleted, false);

        } 
    }
    
    if (Trigger.isAfter)
    {
        if (Trigger.isInsert || Trigger.isUpdate)
        {
            //try{  
            //Step.1.Get affected inventors ids
            List<Id> lstInvIds = new List<Id>();
            if(Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.isAccessible() && SymphonyIPM__Additional_Inventor__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPM__Additional_Inventor__c> objInventors = [SELECT SymphonyIPM__Invention_Disclosure_New__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive, SymphonyIPM__Inventor__r.SymphonyIPM__User__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Inventor__r.SymphonyIPM__User__c!= null AND Id IN :Trigger.New];
                // 
                if (objInventors != null && objInventors.size()>0)
                {
                    for(SymphonyIPM__Additional_Inventor__c objInventor : objInventors)
                    {  
                        if(Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.fields.SymphonyIPM__Invention_Disclosure_New__c.isAccessible())
                            lstInvIds.add(objInventor.SymphonyIPM__Invention_Disclosure_New__c);
                    }
                }
                
                if (lstInvIds != null && lstInvIds.size()>0)
                { 
                    //Step.2.Create invention share for affected invention ids
                    List<SymphonyIPM__Invention_Disclosure_New__Share> objinventionToBeShared = new List<SymphonyIPM__Invention_Disclosure_New__Share>();
                    if(Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.isAccessible() && SymphonyIPM__Additional_Inventor__c.sObjectType.getDescribe().isAccessible())
                    {
                        List<SymphonyIPM__Additional_Inventor__c> objInventors1 = [SELECT SymphonyIPM__Invention_Disclosure_New__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive, SymphonyIPM__Inventor__r.SymphonyIPM__User__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Invention_Disclosure_New__c IN :lstInvIds];
                        List<Id> userIdList=new List<Id>();
                        if (objInventors1 != null && objInventors1.size()>0)
                        {   
                            for(SymphonyIPM__Additional_Inventor__c objInventor : objInventors1)
                            { 
                                userIdList.add(objInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__c);
                            }
                            //Map<String,SymphonyIPM__Invention_Disclosure_New__Share> parentIdMap=new Map<String,SymphonyIPM__Invention_Disclosure_New__Share>();
                            Map<String,SymphonyIPM__Invention_Disclosure_New__Share> userOrGroupIdMap=new Map<String,SymphonyIPM__Invention_Disclosure_New__Share>();
                            
                            List<SymphonyIPM__Invention_Disclosure_New__Share> inventionShareList = [Select id,ParentId,UserOrGroupId from SymphonyIPM__Invention_Disclosure_New__Share where ParentId in: lstInvIds AND UserOrGroupId in:userIdList AND Rowcause='Inventor__c'];
                            
                            for(SymphonyIPM__Invention_Disclosure_New__Share inventionShare : inventionShareList)
                            {
                                //parentIdMap.put(inventionShare.ParentId,inventionShare);
                                userOrGroupIdMap.put(inventionShare.UserOrGroupId+'-'+inventionShare.ParentId,inventionShare);
                            }
                            
                            for(SymphonyIPM__Additional_Inventor__c objInventor : objInventors1)
                            {
                                if (objInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive && objInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__c!=null && userOrGroupIdMap.containsKey(objInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__c+'-'+objInventor.SymphonyIPM__Invention_Disclosure_New__c)!=true)
                                {  
                                    SymphonyIPM__Invention_Disclosure_New__Share objinventionShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                                    if(Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.fields.SymphonyIPM__Invention_Disclosure_New__c.isAccessible())
                                        objinventionShare.ParentId = objInventor.SymphonyIPM__Invention_Disclosure_New__c;
                                    if(Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.fields.SymphonyIPM__Inventor__c.isAccessible() && Schema.sObjectType.SymphonyIPM__Invention_Disclosure_New__Share.fields.UserOrGroupId.isCreateable())
                                        objinventionShare.UserOrGroupId = objInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__c; 
                                    if(Schema.sObjectType.SymphonyIPM__Invention_Disclosure_New__Share.fields.AccessLevel.isCreateable())
                                        objinventionShare.AccessLevel = 'Edit';
                                    //objinventionShare.RowCause=Schema.SymphonyIPM__Invention_Disclosure_New__Share.RowCause.Inventor__c;
                                    //if(Schema.sObjectType.Invention_Disclosure_New__Share.fields.RowCause.isCreateable())
                                    // objinventionShare.RowCause = Schema.Invention_Disclosure_New__Share.RowCause.Other_Inventor__c;
                                    objinventionToBeShared.add(objinventionShare);
                                }
                            }
                        }
                    }
                    System.debug('test**********');
                    //Step.3.Insert/update the new shares from Step.2
                    if (SymphonyIPM__Invention_Disclosure_New__Share.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.SymphonyIPM__Invention_Disclosure_New__Share.isCreateable() && SymphonyIPM__Invention_Disclosure_New__Share.sObjectType.getDescribe().isUpdateable() && Schema.sObjectType.SymphonyIPM__Invention_Disclosure_New__Share.isUpdateable())
                    {
                        if (objinventionToBeShared!= null && objinventionToBeShared.size()>0)
                        {   
                            System.debug('obj'+objinventionToBeShared);
                            //database.insert(objinventionToBeShared);
                            Database.SaveResult[] Sr= Database.Insert(objinventionToBeShared,false);
                        }
                    }
                    /* List<SymphonyIPM__Additional_Inventor__c> updateShared = new List<SymphonyIPM__Additional_Inventor__c>();
                    for(SymphonyIPM__Additional_Inventor__c shareupdate : objInventors)
                    {
                    if(Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.fields.Share_Asset__c.isAccessible())
                    {  
                    shareupdate.SymphonyIPM__shared__c=true;
                    updateShared.add(shareupdate);
                    }
                    }
                    if (SymphonyIPM__Additional_Inventor__c.sObjectType.getDescribe().isUpdateable() && Schema.sObjectType.SymphonyIPM__Additional_Inventor__c.isUpdateable())
                    {
                    if (updateShared!= null && updateShared.size()>0)
                    UPDATE updateShared;
                    }*/
                }
            }
      //  }catch(Exception e){
         //   System.debug('Get Errors'+ e.getLineNumber());
          //     System.debug('Get Errors'+ e.getMessage());
          //   System.debug('Get Errors'+ e.getStackTraceString());
       // }
        }
    }    
    
}