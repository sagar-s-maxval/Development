trigger trgPatentAssignee on Patent_Assignee__c (after insert, after update) {
       List<id> patentid = new List<id>();
    if(trigger.isinsert)
    {
      for(Patent_Assignee__c  patent : Trigger.new){
        patentid.add(patent .Patent__c);
      }
     PatentAssigneeTriggerHelper.populateinventors(patentid);
    }
    
   //  PatentAssigneeTriggerHelper.populateinventors(Trigger.new);
     else{
      for(Patent_Assignee__c  patent : Trigger.new){
         Patent_Assignee__c oldpatent=Trigger.oldMap.get(patent.Id);
         Patent_Assignee__c newpatent=Trigger.newmap.get(patent.Id);
      //   if(oldpatent.Entity__c!=newpatent.Entity__c){
         patentid.add(newpatent.Patent__c);
      //   }
         
         }
         if(patentid.size()>0)
      PatentAssigneeTriggerHelper.populateinventors(patentid);
     }
     
}