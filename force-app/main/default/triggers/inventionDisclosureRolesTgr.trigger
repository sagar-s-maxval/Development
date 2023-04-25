trigger inventionDisclosureRolesTgr on Invention_Disclosure_Role__c (after insert, after update, after delete, before update, before insert,before delete) {

    Set<Id> inventionDisclosureIds = new Set<Id>();
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            inventionDisclosureRolesTriggerHelper.updatePermissionFields(Trigger.new);
            inventionDisclosureRolesTriggerHelper.shareRecordsBasedOnRoles(Trigger.newMap);
        }else if(Trigger.isDelete){
            inventionDisclosureRolesTriggerHelper.updatePermissionFields(Trigger.old);
            inventionDisclosureRolesTriggerHelper.shareRecordsBasedOnRoles(Trigger.oldMap);
        }
    }
     if(Trigger.isBefore){
       SymphonyIPM__Inventor__c Sysadmin = [Select Id, Is_Allowed_To_Modify__c FROM SymphonyIPM__Inventor__c WHERE Name = 'System Admin' LIMIT 1];
        id Inhouseid=[select id from profile where name ='In-House Counsel' limit 1 ].id;
        boolean noaccess=true;
        list<SymphonyIPM__Inventor__c> person=[select id,Is_Allowed_To_Modify__c from SymphonyIPM__Inventor__c where SymphonyIPM__User__c=:userinfo.getUserId() limit 1];
        set<id> personids = new set<id>();
          set<id> IDfids = new set<id>();
        if(trigger.isdelete){
         for(Invention_Disclosure_Role__c pr:trigger.old)
         { if(pr.Person__c!=null)
            personids.add(pr.Person__c); 
           IDfids.add(pr.Invention_Disclosure__c);
        }
        }else{
         for(Invention_Disclosure_Role__c pr:trigger.new)
         { if(pr.Person__c!=null)
            personids.add(pr.Person__c);  
           IDfids.add(pr.Invention_Disclosure__c);
        }}
        Map<id,List<Invention_Disclosure_Role__c>> docketpersonmap= new Map<id,List<Invention_Disclosure_Role__c>>();
        for(Invention_Disclosure_Role__c patroles:[select id,Invention_Disclosure__c,Person__c,Role__C from Invention_Disclosure_Role__c where  Role__C='Docketing' and Invention_Disclosure__c in:IDfids ]){
            list<Invention_Disclosure_Role__c> rollist;
            if(docketpersonmap.containskey(patroles.Invention_Disclosure__c)){
                rollist=docketpersonmap.get(patroles.Invention_Disclosure__c);
            }else{
                rollist= new List<Invention_Disclosure_Role__c>();
            }
            rollist.add(patroles);
            docketpersonmap.put(patroles.Invention_Disclosure__c,rollist);
        }
        
        if(trigger.isdelete){
        
         for(Invention_Disclosure_Role__c pr:trigger.old){
             if(docketpersonmap.containskey(pr.Invention_Disclosure__c)){
                 for(Invention_Disclosure_Role__c prol:docketpersonmap.get(pr.Invention_Disclosure__c)){
                     if(prol.Person__c==person[0].id)
                         noaccess=false; 
                 } }
             }
              for(Invention_Disclosure_Role__c pr:trigger.old){
                  
                   if(noaccess==true&& userinfo.getProfileId()==Inhouseid && pr.Person__c!=null && !Sysadmin.Is_Allowed_To_Modify__c){
                   pr.adderror('You don\'t have Access to Delete this Record.') ;
                }
              }
        }
        else{
        for(Invention_Disclosure_Role__c pr:trigger.new){
             if(docketpersonmap.containskey(pr.Invention_Disclosure__c)){
                 for(Invention_Disclosure_Role__c prol:docketpersonmap.get(pr.Invention_Disclosure__c)){
                     if(prol.Person__c==person[0].id)
                         noaccess=false; 
                 } }
             }
              for(Invention_Disclosure_Role__c pr:trigger.new){
                  
                if(noaccess==true&& userinfo.getProfileId()==Inhouseid && pr.Person__c!=null && !Sysadmin.Is_Allowed_To_Modify__c){
                        if(trigger.isinsert &&  pr.Allow_access__c==false)
                   pr.adderror('You don\'t have Access to Insert this Record.') ;
                       if(trigger.isupdate &&  pr.Allow_access__c==false)
                   pr.adderror('You don\'t have Access to Modify this Record.') ;        
                 //  pr.adderror('You don\'t have Access to Modify this Record.') ;
                }
              }}
       
    }
    /*else if ((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)) {
        inventionDisclosureRolesTriggerHelper.validateRoles(Trigger.new, Trigger.oldMap);
    }*/
}