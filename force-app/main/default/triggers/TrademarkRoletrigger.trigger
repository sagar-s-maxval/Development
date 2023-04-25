trigger TrademarkRoletrigger on Trademark_Role__c (before insert,before update){
list<id> personids= new list<id>();
    list<id> Tradeids= new list<id>();
for(Trademark_Role__c  inv: trigger.new){
    if(inv.Person__c!=null)
personids.add(inv.Person__c);
    Tradeids.add(inv.Trademark__c);
}
map<id,string> perosonrolemap= new map<id,string>();

for(Trademark_Role__c  invrole: [select id,Person__c,Role__c,Trademark__c from Trademark_Role__c   where Person__c=:personids and Trademark__c in:Tradeids]){
if(invrole.Person__c!=null)
    perosonrolemap.put(invrole.Person__c,invrole.Role__c);
}


/*for(Trademark_Role__c   inv: trigger.new){
    if(inv.Person__c!=null){
if(perosonrolemap.containskey(inv.Person__c)&& inv.Role__c == perosonrolemap.get(inv.Person__c)){
    inv.adderror('You cannot add same person with same role');
   }
}

}*/

}