public class SharePRCwithReviewer_Handler {   
    public void SharingPRC(list<SymphonyIPM__PRC_Meeting__c> insertedrecords){ 
        list <SymphonyIPM__Hierarchy_Role__c> Hierarchy = new list <SymphonyIPM__Hierarchy_Role__c>();
        Hierarchy = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c =: insertedrecords[0].SymphonyIPM__Path__c AND SymphonyIPM__User__c != null AND SymphonyIPM__User__c !=: insertedrecords[0].CreatedById AND SymphonyIPM__User__r.IsActive = true];
        set<id> userId = new set<id>();
		set<id> userIdset = new set<id>();
        Set<SymphonyIPM__PRC_Meeting__Share> setprcshare = new Set<SymphonyIPM__PRC_Meeting__Share>();
        list<SymphonyIPM__PRC_Meeting__Share> listprcshare = new list<SymphonyIPM__PRC_Meeting__Share>();
        for(SymphonyIPM__Hierarchy_Role__c getuser : Hierarchy)
        {
        userId.add(getuser.SymphonyIPM__User__c);
        }
        system.debug('set of users'+userId);
		/*list<user> activeuser = [select id from user where id IN : userId AND IsActive = true];
		for(user activeid : activeuser )
		{
		userIdset.add(activeid.id);
		}*/
       for(id share : userId)
       {
       SymphonyIPM__PRC_Meeting__Share createshare = new SymphonyIPM__PRC_Meeting__Share();
       createshare.ParentId = insertedrecords[0].id;
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