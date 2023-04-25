trigger EmailTrackerAttachmentsTrigger on Emai_Tracker__c (after insert,before insert,before update) {
     
    if(Trigger.isbefore){
        Map<id,id> EMtracktmap= new Map<id,id>();
        List<id>Emids= new List<id>();
        for(Emai_Tracker__c et: Trigger.new) {
            EMtracktmap.put(et.Email_Message_Id__c,et.id);
        }
       // List<Attachment> att= [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId in :EMtracktmap.keyset()];
       Map<id,id> Attachmap= new Map<id,id>();
        for(Attachment att:[SELECT Id, Name, ParentId FROM Attachment WHERE ParentId in :EMtracktmap.keyset()]){
           Attachmap.put(att.ParentId,att.id); 
        }
        for(Emai_Tracker__c et: Trigger.new) {
            if(Attachmap.containskey(et.Email_Message_Id__c))
                et.Attchment_Availble__c=true;
        }  
        
    }
    if(Trigger.isAfter && Trigger.isInsert){
     	Map<Id, Id> emailToTrackerMap = new Map<Id, Id>();
        for(Emai_Tracker__c et: Trigger.new) {
            emailToTrackerMap.put(et.Email_Message_Id__c, et.Id);
        }
    
        List<Attachment> attachments = new List<Attachment>();
        for (Attachment att : [SELECT Id, Body, Name, ParentId FROM Attachment WHERE ParentId IN :emailToTrackerMap.keySet()]) {
            Attachment local = new Attachment(Body=att.Body, Name=att.Name, ParentId=emailToTrackerMap.get(att.ParentId));
            attachments.add(local);
        }
    
        insert attachments;   
    }
}