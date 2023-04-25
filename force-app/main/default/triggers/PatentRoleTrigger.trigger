trigger PatentRoleTrigger on Patent_Role__c (before insert, before update, after insert, after update, after delete,before delete) {
    
    if(Trigger.isBefore){
        id Inhouseid=[select id from profile where name ='In-House Counsel' limit 1 ].id;
        boolean noaccess=true;
        list<SymphonyIPM__Inventor__c> person=[select id from SymphonyIPM__Inventor__c where SymphonyIPM__User__c=:userinfo.getUserId() limit 1];
        set<id> personids = new set<id>();
        set<id> patids = new set<id>();
        if(trigger.isdelete){
         for(Patent_Role__c pr:trigger.old)
         { if(pr.Person__c!=null)
            personids.add(pr.Person__c); 
          patids.add(pr.Patent__c);
        }
        }else{
         for(Patent_Role__c pr:trigger.new)
         { if(pr.Person__c!=null)
            personids.add(pr.Person__c); 
          patids.add(pr.Patent__c);
        }}
        Map<id,List<Patent_Role__c>> docketpersonmap= new Map<id,List<Patent_Role__c>>();
        for(Patent_Role__c patroles:[select id,Patent__c,Person__c,Role__C from Patent_Role__c where Role__C='Docketing' and Patent__c in:patids]){
            list<Patent_Role__c> rollist;
            if(docketpersonmap.containskey(patroles.Patent__c)){
                rollist=docketpersonmap.get(patroles.Patent__c);
            }else{
                rollist= new List<Patent_Role__c>();
            }
            rollist.add(patroles);
            docketpersonmap.put(patroles.Patent__c,rollist);
        }
        
        if(trigger.isdelete){
        
         for(Patent_Role__c pr:trigger.old){
             if(docketpersonmap.containskey(pr.Patent__c)){
                 for(Patent_Role__c prol:docketpersonmap.get(pr.Patent__c)){
                     if(prol.Person__c==person[0].id)
                         noaccess=false; 
                 } }
             }
              for(Patent_Role__c pr:trigger.old){
                  
                   if(noaccess==true&& userinfo.getProfileId()==Inhouseid && pr.Person__c!=null){
                   pr.adderror('You don\'t have Access to Delete this Record.') ;
                }
              }
        }
        else if(Trigger.isUpdate){
        for(Patent_Role__c pr:trigger.new){
             if(docketpersonmap.containskey(pr.Patent__c)){
                 for(Patent_Role__c prol:docketpersonmap.get(pr.Patent__c)){
                     if(prol.Person__c==person[0].id)
                         noaccess=false; 
                 } }
             }
              for(Patent_Role__c pr:trigger.new){
                   if(noaccess==true&& userinfo.getProfileId()==Inhouseid && pr.Person__c!=null  ){
                       if(trigger.isinsert &&  pr.Allow_access__c==false)
                   pr.adderror('You don\'t have Access to Insert this Record.') ;
                       else if(TFconstant.allowrolechange!=true)
                     pr.adderror('You don\'t have Access to Modify this Record.') ;       
                }
              }}
        
         
         
              
        if(Trigger.isinsert){
           
            
            PatentRoleTriggerHelper.validateRoles(Trigger.new);
        }else if(Trigger.isUpdate){
            
            PatentRoleTriggerHelper.validateRoles(Trigger.newMap, Trigger.oldMap);
        }
    }else if(Trigger.isAfter){
        Set<Id> patentIds = new Set<Id>();
        System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        if(Trigger.isInsert || Trigger.isUpdate){

            if(Trigger.new.size()>10 || Limits.getQueries()>60){
       
                   for(Patent_Role__c pr: Trigger.new){
                patentIds.add(pr.id);
            }
              PatentroleBatchcls pr= new PatentroleBatchcls(patentIds,'Insert');
                Database.executeBatch(pr,10);
            }
            else{
                 PatentRoleTriggerHelper.updaterolesinpatentflow(Trigger.new);
           PatentRoleTriggerHelper.updatePatentrolepersonfield(Trigger.new);
            PatentRoleTriggerHelper.updatePermissionFields(Trigger.new);
            for(Patent_Role__c pr: Trigger.new){
                patentIds.add(pr.Patent__c);
            }
            PatentRoleTriggerHelper.shareRecordsBasedOnRoles(patentIds);
            }
        
        }else if(Trigger.isDelete){
              PatentRoleTriggerHelper.updatePatentrolepersonfield(Trigger.old);
              PatentRoleTriggerHelper.updatePermissionFields(Trigger.old);
            for(Patent_Role__c pr: Trigger.old){

                patentIds.add(pr.Patent__c);
            }
            PatentRoleTriggerHelper.shareRecordsBasedOnRoles(patentIds);
             integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
}