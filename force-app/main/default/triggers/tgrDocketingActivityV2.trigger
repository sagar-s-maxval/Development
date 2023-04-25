trigger tgrDocketingActivityV2 on SymphonyIPM__Docketing_Activity_v2__c (before insert, before update, after insert, after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            HelperDocketingActivityTrigger.createDocketingReminders(Trigger.new);
        }else if(Trigger.isUpdate){
            HelperDocketingActivityTrigger.createDocketingReminders(Trigger.new, Trigger.oldMap);
        }
    }else if(Trigger.isBefore){
    
    for(SymphonyIPM__Docketing_Activity_v2__c  doc:trigger.new){
    if(doc.SymphonyIPM__Comments__c!=null && doc.SymphonyIPM__Comments__c!=''){
    string comm='';
        if(doc.Comments__c!=null && doc.Comments__c!=''){
    comm=doc.Comments__c+'\r\n';
     // ==doc.Comments__c!=null ? doc.Comments__c+'/n' : '';
            doc.Comments__c=comm+doc.SymphonyIPM__Comments__c;}
        else
         doc.Comments__c= doc.SymphonyIPM__Comments__c;  
      doc.SymphonyIPM__Comments__c='';
    }
  
    }
        // Profile porf = [SELECT Id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()];
        // if(porf.Name == 'Outside Counsel'){
        //     for(SymphonyIPM__Docketing_Activity_v2__c act: Trigger.new){
        //         act.addError('You don\'t have access to create an activity');
        //     }
        // }else if(porf.Name == 'System Administrator'){
        //     //Do Nothing
        // }else{
        //     //HelperDocketingActivityTrigger.checkUserActivityAccess(Trigger.new);
        // }
    }
}