@isTest
private class CreatePrcTaskwithReviewer_Handler_Test{
    
    @isTest static void CreateTaskTest() {
        
    Profile p = [SELECT Id FROM Profile WHERE Name='Platform Reviewer']; 
    Profile I= [SELECT Id FROM Profile WHERE Name='Platform Inventor'];
        User u = new User(Alias = 'standt', Email='patents@uhg.com',FirstName='Task', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='reviewertes@uhg.com');
            insert u;
                                                
            SymphonyIPM__Hierarchy__c newpath = new SymphonyIPM__Hierarchy__c(name = 'Test Path');
            insert newpath;
            
            date prcdate =  system.today();     
            SymphonyIPM__Hierarchy_Role__c newrole = new SymphonyIPM__Hierarchy_Role__c(SymphonyIPM__Hierarchy_Path__c=newpath.id,SymphonyIPM__isPrimary__c=true,SymphonyIPM__Role__c='Reviewer',SymphonyIPM__User__c=u.id);
           insert newrole;
        
            SymphonyIPM__PRC_Meeting__c newprc = new SymphonyIPM__PRC_Meeting__c(SymphonyIPM__Meeting_Date__c=prcdate,SymphonyIPM__Path__c=newpath.id,Name='Test PRC Meeting',SymphonyIPM__Start_Time__c='03.30');
            insert newprc;
        
        SymphonyIPM__Invention_Disclosure_New__c idf = new SymphonyIPM__Invention_Disclosure_New__c(SymphonyIPM__Disclosure_Status__c='Submitted',name='test-idf',SymphonyIPM__Hierarchy__c=newpath.id);
            insert idf;
        
            SymphonyIPM__PRC_Meeting_Details__c prcdetails = new SymphonyIPM__PRC_Meeting_Details__c(SymphonyIPM__PRC_Meeting__c=newprc.id,SymphonyIPM__Related_Invention_Disclosure__c=idf.id);
            insert prcdetails;
        
            list<SymphonyIPM__Hierarchy_Role__c> Hierarchy = new list<SymphonyIPM__Hierarchy_Role__c>();
            Hierarchy = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c =: newpath.id AND SymphonyIPM__User__c != null];
            set<id> userId = new set<id>();
        set<Task> TaskSet = new set<Task>();
        list<Task> Tasklist = new list<Task>();
        for(SymphonyIPM__Hierarchy_Role__c getuser : Hierarchy)
        {
        userId.add(getuser.SymphonyIPM__User__c);
        }
        system.debug('set of users'+userId);
      // for(SymphonyIPM__PRC_Meeting__c prc : newprc )
        //{
         for(id share : userId)
       {
       Task prctask = new Task();
       prctask.OwnerId = share;
        prctask.SymphonyIPM__Docket_No__c = 'testidf';
       prctask.ActivityDate = prcdate;
       prctask.Priority = 'Normal';
       prctask.Status = 'Not Started';
       prctask.Type = 'PRC Meeting';
       prctask.Subject = 'test subject';
       prctask.WhatId = newprc.id;
       TaskSet.add(prctask);
       }
        
       Tasklist.addAll(TaskSet);
       system.debug('size of task records'+Tasklist.size()); 
       if(Tasklist.size() > 0){
            try{
                insert Tasklist;
                
            }catch(Exception e){
                System.debug('Error in inserting task records--'+e);
            }
            }
}
}