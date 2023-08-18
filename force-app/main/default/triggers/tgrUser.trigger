trigger tgrUser on User (after insert,after update) 
{
    /*Boolean UserTriggerEnabled = false;
List<AdminTriggerConfigSettings__c> lstSettings = [SELECT ID, User_Trigger__c FROM AdminTriggerConfigSettings__c where Name='Admin Trigger Config' Limit 1];
//AdminTriggerConfigSettings__c cobjAdminTriggerConfig = AdminTriggerConfigSettings__c.getValues('Admin Trigger Config');
if(lstSettings != null && lstSettings.size()>0)
{
AdminTriggerConfigSettings__c cobjAdminTriggerConfig = lstSettings[0];
UserTriggerEnabled = cobjAdminTriggerConfig.User_Trigger__c;
} */
    //if(UserTriggerEnabled) 
    if(trigger.isafter && trigger.isInsert)
    {
        createInventor.createInventorRecord(Trigger.newMap.keySet());
    }
    //code moved from createInventor Trigger and deactivated by Divya
    string strAuditTest='';
    
    if (trigger.isAfter)
    {
        try
        {
            strAuditTest='trgUser--AfterInsert--->';
            set<string> profilesNames = New set<string>();
            set<Id> userIds = New set<Id>();
            //Checks if the scheduled job is running. If running, it does not execute the trigger logic
            // AsyncApexJob aJob = [SELECT Id, Status, MethodName, ApexClass.Name FROM AsyncApexJob where ApexClass.Name ='licenceRecyclingReorderOpScheduler' AND Status!='Aborted' LIMIT 1];
            
            // if(aJob.Status != 'Processing')
            
            if(Trigger.isAfter && Trigger.isInsert)
            {
                for(User intsanceUser:trigger.new)
                {
                    userIds.add(intsanceUser.Id);
                }
                if(Schema.sObjectType.User.isAccessible())
                {
                    
                    If(userIds.size()>0)
                    {
                        for(user uData: [Select id,Profile.Name From User Where Id IN: userIds]){
                            profilesNames.add(uData.Profile.Name);
                        }
                        strAuditTest +=  'userids---->'+userIds;
                        strAuditTest += 'ProfilesNames--->'+profilesNames;
                        trgUserHandler th = new trgUserHandler();
                        th.handleRecycling(profilesNames,userIds,true); //Handler class to call the batch class that checks for deactivation/re-order criteria
                    }
                        
                }
            }
            
            if(Trigger.isAfter && Trigger.isUpdate)
            {        
                
                //set<string> profilesNames = New set<string>();
                //set<Id> userIds = New set<Id>();
                set<Id> ReactivatedUsrIds = New set<Id>();
                /*for(User intsanceUser : trigger.new)
                {                    
                    //system.debug('activation status is :'+intsanceUser.isActive+' Profile name '+intsanceUser.Profile.Name);
                    //if((Trigger.oldMap.get(intsanceUser.Id).isActive != intsanceUser.isActive) && intsanceUser.isActive == true)
                    if((Trigger.oldMap.get(intsanceUser.Id).isActive && intsanceUser.isActive) == true)
                    {    
                        // Trigger.oldMap.get(intsanceUser.Id).isActive != false
                        //set<string> profilesNames = New set<string>();
                        
                        userIds.add(intsanceUser.Id);
                        if(userIds.size() >0){
                            //System.debug('Calling Batch class');
                            // UpdatePersonRecords BatchUpdt = new UpdatePersonRecords(userIds,false); 
                            // database.executeBatch(BatchUpdt); 
                            //System.debug('Executed Batch class Successfully');
                            trgUserHandler th = new trgUserHandler();
                            th.handleRecycling(profilesNames,userIds,false); //Handler class to call the batch class that checks for deactivation/re-order criteria
                        }                                              
                    }
                    User oldusr = Trigger.oldMap.get(intsanceUser.Id); 
                    if(intsanceUser.IsActive != oldusr.IsActive)
                    {
                        if(intsanceUser.IsActive == True)
                        {
                            ReactivatedUsrIds.add(intsanceUser.id);
                        }
                    }
                }*/
                //------------------------------------------
                profilesNames.clear();
                userIds.clear();
                for(User intsanceUser : [Select id,Profile.Name,isActive From User Where Id IN: trigger.new])
                {
                    profilesNames.add(intsanceUser.Profile.Name);
                    if((Trigger.oldMap.get(intsanceUser.Id).isActive != intsanceUser.isActive) && intsanceUser.isActive == true)
                    {    
                        userIds.add(intsanceUser.Id);
                    }
                    User oldusr = Trigger.oldMap.get(intsanceUser.Id); 
                    if(intsanceUser.IsActive != oldusr.IsActive)
                    {
                        if(intsanceUser.IsActive == True)
                        {
                            ReactivatedUsrIds.add(intsanceUser.id);
                        }
                    }
                }
                if(userIds.size() >0){
                    //UpdatePersonRecords BatchUpdt = new UpdatePersonRecords(userIds,false); 
                    //database.executeBatch(BatchUpdt); 
                    trgUserHandler th = new trgUserHandler();
                    if(StopContinuosbatchcalling.check==false)//added condition by hari to stop System.AsyncException
                    th.handleRecycling(profilesNames,userIds,false); //Handler class to call the batch class that checks for deactivation/re-order criteria
                }
                //------------------------------------------------
                set<Id> personIds = New set<Id>();
                System.debug('Active User Ids: ' +ReactivatedUsrIds);
                if(ReactivatedUsrIds.size()>0)
                {
                    list<SymphonyIPM__Inventor__c> lstInvs =[SELECT Id,Name,SymphonyIPM__User__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__User__c IN: ReactivatedUsrIds AND (RecordType.Name ='Platform Inventor' OR RecordType.Name ='Inventor' OR RecordType.Name ='Reviewer')]; //Added on 11/12/20 for resolving sharing for reviewers after reactivating
                    if(lstInvs.size()>0)
                    {
                        for(SymphonyIPM__Inventor__c inv : lstInvs)
                        {
                            if(inv.SymphonyIPM__User__c!=NUll)
                            {
                                personIds.add(inv.Id);
                            }
                        }
                    }
                    if(personIds.size()>0)
                    {
                        if(StopContinuosbatchcalling.check==false){//added condition by hari to stop System.AsyncException
                        createInventor.shareInventionDisclosure(ReactivatedUsrIds, personIds);
                        createInventor.sharePatent(ReactivatedUsrIds, personIds);
                        createInventor.shareInventorAwards(ReactivatedUsrIds, personIds);
                        }
                    }
                }
            }
            
        }
        catch(Exception e)
        {
            throw e;
        }
    }         
}