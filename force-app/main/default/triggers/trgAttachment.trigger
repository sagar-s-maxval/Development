trigger trgAttachment on Attachment (after insert) {
    List<id> emmsgid= new List<id>();
    for(Attachment att:Trigger.new){
        string partid=att.ParentId;
        if(partid.startsWith('02s')){
            emmsgid.add(att.ParentId);   
        }
        list<Emai_Tracker__c> Emailtracklist= new List<Emai_Tracker__c>();
        if(emmsgid.size()>0){
   for(Emai_Tracker__c em:[select id,Attchment_Availble__c from Emai_Tracker__c  where Email_Message_Id__c in:emmsgid]){
                em.Attchment_Availble__c=true;
                Emailtracklist.add(em);   
            }
        }
        if(Emailtracklist.size()>0)
            update Emailtracklist;
    }
}