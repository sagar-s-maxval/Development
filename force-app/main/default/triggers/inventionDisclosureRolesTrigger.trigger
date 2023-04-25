trigger inventionDisclosureRolesTrigger on Invention_Disclosure_Role__c (before insert,before update) {
list<id> personids= new list<id>();
    list<id> idfids= new list<id>();
    Map<id,id> docketusermap= new Map<id,id>();
for(Invention_Disclosure_Role__c  inv: trigger.new){
    if(inv.role__c=='Docketing')
        docketusermap.put(inv.Invention_Disclosure__c,inv.Person__c);
    if(inv.Person__c!=null)
personids.add(inv.Person__c);
    idfids.add(inv.Invention_Disclosure__c);
}
map<id,string> perosonrolemap= new map<id,string>();
    map<id,string> perosonusermap= new map<id,string>();

for(SymphonyIPM__Inventor__c  inv : [select id,SymphonyIPM__User__c from SymphonyIPM__Inventor__c   where id in:personids]){
if(inv.SymphonyIPM__User__c!=null)
    perosonusermap.put(inv.id,inv.SymphonyIPM__User__c);
}    
    
for(Invention_Disclosure_Role__c   invrole: [select id,Person__c,Role__c from Invention_Disclosure_Role__c   where Person__c=:personids and Invention_Disclosure__c in:idfids]){
if(invrole.Person__c!=null)
    perosonrolemap.put(invrole.Person__c,invrole.Role__c);
}


for(Invention_Disclosure_Role__c  inv: trigger.new){
    if(inv.Person__c!=null){
if(perosonrolemap.containskey(inv.Person__c)&& inv.Role__c == perosonrolemap.get(inv.Person__c)){
    inv.adderror('Adding same person with same role is not allowed');}
}

}


id Sysadminid=[select id from profile where name like '%system Admin%' limit 1 ].id;
        boolean noaccess=true;
          list<SymphonyIPM__Inventor__c> person=[select id from SymphonyIPM__Inventor__c where SymphonyIPM__User__c=:userinfo.getUserId() limit 1];
 list<Invention_Disclosure_Role__c  > patroles=[select id,Person__c,Role__C from Invention_Disclosure_Role__c   where Person__c =:person[0].id and Invention_Disclosure__c=:trigger.new[0].Invention_Disclosure__c];
  for(Invention_Disclosure_Role__c   pr:patroles){
            if((pr.Role__C=='Docketing' || pr.Role__C=='IP Responsible Manager')&&person[0].id==pr.Person__c )
                noaccess=false;
        }
         for(Invention_Disclosure_Role__c    pr:trigger.new){
                if(noaccess==true&& userinfo.getProfileId()!=Sysadminid){
                   pr.adderror('You don\'t have Access to Modify this Record.') ;
                }
            }




}