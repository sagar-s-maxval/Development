trigger PopulateTechnologyArea on SymphonyIPM__Invention_Disclosure_New__c (before insert, before update) {
     for(SymphonyIPM__Invention_Disclosure_New__c sid : Trigger.new) {
         if(Trigger.isInsert || sid.UHG_Tech_Area__c != Trigger.oldMap.get(sid.Id).UHG_Tech_Area__c) {
           sid.SymphonyIPM__Technology_Area__c = sid.UHG_Tech_Area__c ;
           }
     }
}