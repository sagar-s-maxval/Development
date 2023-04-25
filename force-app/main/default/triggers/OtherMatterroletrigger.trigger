trigger OtherMatterroletrigger on OM_Role__c (before insert,before update,before delete) {

list<id> personids= new list<id>();
list<id> OMids= new list<id>();
    if(trigger.isinsert || trigger.isupdate){
for(OM_Role__c inv: trigger.new){
    if(inv.Person__c!=null)
personids.add(inv.Person__c);
    OMids.add(inv.Other_Matters__c);
}

map<id,List<OM_Role__c>> perosonrolemap= new map<id,List<OM_Role__c>>();

for(OM_Role__c  invrole: [select id,Person__c,Role__c,Other_Matters__c from OM_Role__c  where Person__c=:personids and Other_Matters__c in:OMids]){
    if(invrole.Person__c!=null){
         list<OM_Role__c> omlist;
    if(perosonrolemap.containskey(invrole.Other_Matters__c)){
        omlist=perosonrolemap.get(invrole.Other_Matters__c);
    }else{
        omlist= new list<OM_Role__c>();
    }
        omlist.add(invrole);
         perosonrolemap.put(invrole.Other_Matters__c,omlist);
    }
   
}


for(OM_Role__c inv: trigger.new){
    if(inv.Person__c!=null){
    if(trigger.isinsert){
        if(perosonrolemap.containskey(inv.Other_Matters__c)){
    for(OM_Role__c  exrol:perosonrolemap.get(inv.Other_Matters__c)){
    if(inv.Person__c==exrol.Person__c&& inv.Role__c ==exrol.Role__c  ){
    inv.adderror('You cannot add same person with same role');}
    }}}
    if(trigger.isupdate){
    
    if((trigger.oldmap.get(inv.id).Person__c!=trigger.newmap.get(inv.id).Person__c)|| (trigger.oldmap.get(inv.id).Role__c !=trigger.newmap.get(inv.id).Role__c ) ){
     if(perosonrolemap.containskey(inv.Other_Matters__c)){
    for(OM_Role__c  exrol:perosonrolemap.get(inv.Other_Matters__c)){
    if(inv.Person__c==exrol.Person__c&& inv.Role__c ==exrol.Role__c  ){
    inv.adderror('You cannot add same person with same role');}
    }}}
    
    }

    
    
}

}
    }
    
     if(Trigger.isBefore){
        id Sysadminid=[select id from profile where name like '%system Admin%' limit 1 ].id;
        boolean noaccess=true;
        list<SymphonyIPM__Inventor__c> person=[select id from SymphonyIPM__Inventor__c where SymphonyIPM__User__c=:userinfo.getUserId() limit 1];
        set<id> personids = new set<id>();
        set<id> omids = new set<id>();
        if(trigger.isdelete){
         for(OM_Role__c pr:trigger.old)
         { if(pr.Person__c!=null)
            personids.add(pr.Person__c);  
            omids.add(pr.Other_Matters__c);         
        }
        }else{
         for(OM_Role__c pr:trigger.new)
         { if(pr.Person__c!=null)
            personids.add(pr.Person__c);  
             omids.add(pr.Other_Matters__c);                
        }}
        Map<id,List<OM_Role__c>> docketpersonmap= new Map<id,List<OM_Role__c>>();
        for(OM_Role__c patroles:[select id,Other_Matters__c ,Person__c,Role__C from OM_Role__c where  (Role__C='Docketing'  OR Role__C='IP Responsible Manager' ) and Other_Matters__c in:omids ]){
            list<OM_Role__c> rollist;
            if(docketpersonmap.containskey(patroles.Other_Matters__c )){
                rollist=docketpersonmap.get(patroles.Other_Matters__c );
            }else{
                rollist= new List<OM_Role__c>();
            }
            rollist.add(patroles);
            docketpersonmap.put(patroles.Other_Matters__c ,rollist);
        }
        
        if(trigger.isdelete){
        
         for(OM_Role__c pr:trigger.old){
             if(docketpersonmap.containskey(pr.Other_Matters__c )){
                 for(OM_Role__c  prol:docketpersonmap.get(pr.Other_Matters__c )){
                     if(prol.Person__c==person[0].id)
                         noaccess=false; 
                 } }
             }
              for(OM_Role__c  pr:trigger.old){
                  
                   if(noaccess==true&& userinfo.getProfileId()!=Sysadminid && pr.Person__c!=null){
                   pr.adderror('You don\'t have Access to Delete this Record.') ;
                }
              }
        }
        else{
        for(OM_Role__c pr:trigger.new){
             if(docketpersonmap.containskey(pr.Other_Matters__c)){
                 for(OM_Role__c prol:docketpersonmap.get(pr.Other_Matters__c)){
                     if(prol.Person__c==person[0].id)
                         noaccess=false; 
                 } }
             }
              for(OM_Role__c pr:trigger.new){
                  
                   if(noaccess==true&& userinfo.getProfileId()!=Sysadminid && pr.Person__c!=null){
                   pr.adderror('You don\'t have Access to Modify this Record.') ;
                }
              }}
      }
 

}