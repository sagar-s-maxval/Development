public class sendsummaryemialcntrl {

    @AuraEnabled
    Public static string sendemail(string recid){
        list<SymphonyIPM__PRC_Meeting__c> prcmeeting = new list<SymphonyIPM__PRC_Meeting__c>();
        list<id> updateoldprc = new list<id>();
        map<id,id> idfhier=new map<id,id>();
        list<id> sympath = new list<id>();
        list<id> prcmeetid = new list<id>();
        map<id,list<id>> hierarcyusermap= new map<id,list<id>>();
        list<id> inventionids=new list<id>();
        try{
              list<SymphonyIPM__PRC_Meeting__c> prcmeetinglist=[SELECT Id From SymphonyIPM__PRC_Meeting__c WHERE id =:recid];
              list<SymphonyIPM__PRC_Meeting_Details__c> prcdetails=[select id, SymphonyIPM__Related_Invention_Disclosure__r.id
                      from  SymphonyIPM__PRC_Meeting_Details__c where SymphonyIPM__PRC_Meeting__c =:recid ];
                    for(SymphonyIPM__PRC_Meeting_Details__c ss:prcdetails){
                        inventionids.add(ss.SymphonyIPM__Related_Invention_Disclosure__r.id);
                    }
                    system.debug('inventionids-->'+inventionids);
                    set<string> pathnames= new set<string>();
                 list<SymphonyIPM__Invention_Disclosure_New__c> invlist=[select id,Path__c,SymphonyIPM__Hierarchy__c  from SymphonyIPM__Invention_Disclosure_New__c
                                                                        where id in:inventionids];  
                    for(SymphonyIPM__Invention_Disclosure_New__c inv:invlist){
                       sympath.add(inv.SymphonyIPM__Hierarchy__c);
                    }
                    system.debug('sympath-->'+sympath);
                    list<SymphonyIPM__PRC_Meeting__c> prcmeet=[select id,SymphonyIPM__Path__r.id from SymphonyIPM__PRC_Meeting__c where id =:recid];
                   for(SymphonyIPM__PRC_Meeting__c sim:prcmeet){
                   sympath.add(sim.SymphonyIPM__Path__r.id); 
                   idfhier.put(sim.id,sim.SymphonyIPM__Path__r.id);
                    }
         system.debug('Invention Disclouser path-->'+sympath);
         system.debug('Iidfhier-->'+idfhier);
list<SymphonyIPM__Hierarchy__c> simhire=[select id,(select id,SymphonyIPM__User__r.id from SymphonyIPM__Hierarchy_Role__r) from SymphonyIPM__Hierarchy__c where id in:sympath];    
        for(SymphonyIPM__Hierarchy__c ss:simhire){
            if(hierarcyusermap.containskey(ss.id)){
                list<id> userid=hierarcyusermap.get(ss.id);
               for(SymphonyIPM__Hierarchy_Role__c sr:ss.SymphonyIPM__Hierarchy_Role__r){
                  userid.add(sr.SymphonyIPM__User__r.id);
               }
                 hierarcyusermap.put(ss.id,userid);
                
            }else{
               list<id> usrid=new list<id>();
               for(SymphonyIPM__Hierarchy_Role__c sr:ss.SymphonyIPM__Hierarchy_Role__r){
               usrid.add(sr.SymphonyIPM__User__r.id);
               }
                hierarcyusermap.put(ss.id,usrid);
            }
       }
         system.debug('hierarcyusermap'+hierarcyusermap);
        
    
 // sending emails to all PRC meetings which met criteria       
   Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> ();
   OrgWideEmailAddress owea = [select Id,Address  from OrgWideEmailAddress limit 1];
   EmailTemplate templateId = [Select id from EmailTemplate where name = 'PRB Review Complete-Defer'];  
            id userid=userinfo.getUserId();
     for(SymphonyIPM__PRC_Meeting__c pr:prcmeetinglist){
         System.debug('Meeting ID'+pr.id);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             if ( owea != null ) {
       //  mail.setOrgWideEmailAddressId(owea.id);
              }
          list<string> listosend = new list<string>();
          listosend.add('patents@uhg.com');
          listosend.add('invention@uhg.com');
         // listosend.add('saikrishna.t@maxval.com');
         id hierid=idfhier.get(pr.id);
          system.debug('hierid-->'+hierid);
          list<id> userlist=hierarcyusermap.get(hierid);
         system.debug('User list to send mail'+userlist);
         mail.setToAddresses(userlist);
        // mail.setReplyTo(owea.Address);
         mail.setCcAddresses(listosend);
         mail.setSaveAsActivity(false);
         mail.setwhatid(pr.id);
         mail.setTargetObjectId(userlist[0]);
         //  mail.setTemplateId('00Xc0000000Gi9pEAC');
         mail.setTemplateId(templateId.id);
         messages.add(mail);
        }
   Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    if (results[0].success) {
    System.debug('The email was sent successfully.');
        string returnstr='The Email was sent successfully ';
        return returnstr;
   } else {
        string returnstr='The Email was sent successfully '+ results[0].errors[0].message;
    System.debug('The email failed to send: ' + results[0].errors[0].message);
             return returnstr;
        } 
        } Catch(Exception e){
           string returnstr=e.getMessage();
             return returnstr;
        }finally{
           string strAudit =userinfo.getName()+'PRB Meeting Record ID-'+recid;
        SymphonyIPM__AuditTrail__c audit =new SymphonyIPM__AuditTrail__c();
        audit.SymphonyIPM__CObjectName__c='SendSummaryEmail';
        audit.SymphonyIPM__Description__c=strAudit;
        audit.SymphonyIPM__Status__c='Success';
        INSERT audit;
    }
      // Method End 
    }
    
    
}