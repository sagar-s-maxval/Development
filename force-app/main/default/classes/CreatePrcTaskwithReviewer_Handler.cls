public class CreatePrcTaskwithReviewer_Handler {
    public void CreateTask(list<SymphonyIPM__PRC_Meeting_Details__c> insertedrecords){
        if(System.isFuture() || System.isBatch()){
            regularSyncCall(insertedrecords[0].SymphonyIPM__Related_Invention_Disclosure__c, insertedrecords[0].SymphonyIPM__PRC_Meeting__c);
        } else {
            if(Limits.getFutureCalls() < Limits.getLimitFutureCalls()){
                doFutureCall(insertedrecords[0].SymphonyIPM__Related_Invention_Disclosure__c, insertedrecords[0].SymphonyIPM__PRC_Meeting__c);
            } else {
                // Do some explicit notification so that you know your @future call was denied
            }
        }
    }
    
    @future
    public static void doFutureCall(String disclosureId, String meetingId){
        regularSyncCall(disclosureId, meetingId);
    }
    
    public static void regularSyncCall(String disclosureId, String meetingId){
        list <SymphonyIPM__Hierarchy_Role__c> Hierarchy = new list <SymphonyIPM__Hierarchy_Role__c>();
        list <SymphonyIPM__PRC_Meeting__c> prclist = new list <SymphonyIPM__PRC_Meeting__c>();
        list <SymphonyIPM__Invention_Disclosure_New__c> IdfName = new list <SymphonyIPM__Invention_Disclosure_New__c>();
        
        IdfName = [select name,UHG_Reviewer_Notes__c from SymphonyIPM__Invention_Disclosure_New__c where id =: disclosureId];
        prclist = [select id,SymphonyIPM__Path__c,SymphonyIPM__Meeting_Date__c,Name from SymphonyIPM__PRC_Meeting__c where  id =: meetingId];
        system.debug('prc list'+prclist);
        
        set<id> pathId = new set<id>();
        for(SymphonyIPM__PRC_Meeting__c pathlist : prclist ){
            pathId.add(pathlist.SymphonyIPM__Path__c);
        }
        
        Hierarchy = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c IN : pathId AND SymphonyIPM__User__c != null AND SymphonyIPM__User__r.IsActive = true];
        system.debug('Hierarchy roles'+Hierarchy);
        
        set<id> userId = new set<id>();
        set<Task> TaskSet = new set<Task>();
        list<Task> Tasklist = new list<Task>();
        system.debug('idf name'+IdfName[0].name);
        
        for(SymphonyIPM__Hierarchy_Role__c getuser : Hierarchy){
            userId.add(getuser.SymphonyIPM__User__c);
        }
        system.debug('set of users'+userId);
        
        for(SymphonyIPM__PRC_Meeting__c prc : prclist ){
            for(id share : userId){
                Task prctask = new Task();
                prctask.OwnerId = share;
                prctask.SymphonyIPM__Docket_No__c = IdfName[0].name;
                prctask.Description = IdfName[0].UHG_Reviewer_Notes__c;
                prctask.ActivityDate = prc.SymphonyIPM__Meeting_Date__c;
                prctask.Priority = 'Normal';
                prctask.Status = 'Not Started';
                prctask.Type = 'PRC Meeting';
                prctask.Subject = 'Review' + ' ' + IdfName[0].name + ' ' + 'in preparation for' + ' ' + prc.Name;
                prctask.WhatId = disclosureId;
                TaskSet.add(prctask);
            }
        }
        Tasklist.addAll(TaskSet);
        system.debug('size of task records'+Tasklist.size());
        
        if(Tasklist.size() > 0 && !test.isRunningTest()){
            try{
                //insert Tasklist;
                Database.DMLOptions options = new Database.DMLOptions();
                options.EmailHeader.triggerUserEmail = false;
                Database.insert(Tasklist,options);
                
            }catch(Exception e){
                System.debug('Error in inserting task records--'+e);
            }
        }
    }
}