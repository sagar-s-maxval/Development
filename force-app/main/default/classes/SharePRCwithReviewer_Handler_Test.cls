@isTest
private class SharePRCwithReviewer_Handler_Test{
    
    @isTest static void ShareprcTest() {
    
    Profile p = [SELECT Id FROM Profile WHERE Name='Platform Reviewer']; 

        User u = new User(Alias = 'standt1', Email='reviewer1tes@yopmail.com',FirstName='share', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='reviewer1tes@yopmail.com');
            insert u;
                                        
            SymphonyIPM__Hierarchy__c newpath = new SymphonyIPM__Hierarchy__c(name = 'Testing Path');
            insert newpath;
            
            date prcdate =  system.today();     
            SymphonyIPM__Hierarchy_Role__c newrole = new SymphonyIPM__Hierarchy_Role__c(SymphonyIPM__Hierarchy_Path__c=newpath.id,SymphonyIPM__isPrimary__c=true,SymphonyIPM__Role__c='Reviewer',SymphonyIPM__User__c=u.id);
           insert newrole;
           set<id> userId = new set<id>();
            SymphonyIPM__PRC_Meeting__c newprc = new SymphonyIPM__PRC_Meeting__c(SymphonyIPM__Meeting_Date__c=prcdate,SymphonyIPM__Path__c=newpath.id,Name='Test PRC Meeting',SymphonyIPM__Start_Time__c='03.30');
            insert newprc;
            list <SymphonyIPM__Hierarchy_Role__c> Hierarchy = new list <SymphonyIPM__Hierarchy_Role__c>();
            Hierarchy = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c =: newpath.id AND SymphonyIPM__User__c != null];
            Set<SymphonyIPM__PRC_Meeting__Share> setprcshare = new Set<SymphonyIPM__PRC_Meeting__Share>();
        list<SymphonyIPM__PRC_Meeting__Share> listprcshare = new list<SymphonyIPM__PRC_Meeting__Share>();
            for(SymphonyIPM__Hierarchy_Role__c getuser : Hierarchy)
        {
        userId.add(getuser.SymphonyIPM__User__c);
        }
        system.debug('set of users'+userId);
       for(id share : userId)
       {
       SymphonyIPM__PRC_Meeting__Share createshare = new SymphonyIPM__PRC_Meeting__Share();
       createshare.ParentId = newprc.id;
       createshare.UserOrGroupId = share;
       createshare.AccessLevel = 'Edit';
       setprcshare.add(createshare);
       }
       listprcshare.addAll(setprcshare);
       system.debug('list of prc share records'+listprcshare); 
       if(listprcshare.size() > 0){
            try{
                upsert listprcshare;
                
            }catch(Exception e){
                System.debug('Error in upserting  share records--'+e);
            }
    
    }
    
}
    }