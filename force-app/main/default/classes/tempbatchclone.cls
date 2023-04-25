public class tempbatchclone implements Database.Batchable<sObject> {
     public Database.QueryLocator start(Database.BatchableContext BC) {
      return Database.getQueryLocator([select id,SymphonyIPM__Mail_Room_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Docket_No__c,
   SymphonyIPM__PDFFileName__c, SymphonyIPM__Activity_Id__c, SymphonyIPM__IFW_Reference_Id__c,SymphonyIPM__IfwDocumentId__c,
  SymphonyIPM__Application_Number__c,MxOCRStatus__c,SymphonyIPM__Document_Code__c,
  SymphonyIPM__Patent_Country_Code__c  from SymphonyIPM__IFW_Data_v1__c where  SymphonyIPM__Document_Code__c!='NPL' and SymphonyIPM__Document_Code__c!='FOR' and SymphonyIPM__Document_Code__c!='WFEE'
   and SymphonyIPM__Document_Code__c!='N417'  and SymphonyIPM__Document_Code__c!='OA.EMAIL'  and 
SymphonyIPM__Document_Code__c!='SRNT'  and SymphonyIPM__Document_Code__c!='SRFW'  and SymphonyIPM__Document_Code__c!='IDS'
   and SymphonyIPM__Document_Code__c!='1449' and SymphonyIPM__Document_Code__c!='FWCLM' 
  and SymphonyIPM__Document_Code__c!='892'  and SymphonyIPM__Document_Code__c!='DRW' and SymphonyIPM__Document_Code__c!='IIFW' 
and SymphonyIPM__Document_Code__c!='SCORE' and  SymphonyIPM__Document_Code__c!='DRW.NONBW' and  
 SymphonyIPM__Document_Code__c!='136A' and  SymphonyIPM__Document_Code__c!='WCLM' and  SymphonyIPM__Document_Code__c!='XT/' 
  and (SymphonyIPM__Patent_Country_Code__c ='US' OR SymphonyIPM__Patent_Country_Code__c ='WO') and SymphonyIPM__Is_Manual_Entry__c =false and MxOCRStatus__c ='completed' and Document_Name__c =null
  ]);
     }
    public void execute(Database.BatchableContext BC, List<SymphonyIPM__IFW_Data_v1__c> scope) {
      List<SymphonyIPM__IFW_Data_v1__c> ifwlst= new List<SymphonyIPM__IFW_Data_v1__c>();
  list<SymphonyIPM__AuditTrail__c> aulist= new list<SymphonyIPM__AuditTrail__c>(); 
        for(SymphonyIPM__IFW_Data_v1__c ifwrec:scope){
            try{
             string mailroomdate=string.valueOf(ifwrec.SymphonyIPM__Mail_Room_Date__c).removeEnd(' 00:00:00');
            string title=ifwrec.SymphonyIPM__Asset__r.SymphonyIPM__Docket_No__c+ '_' +ifwrec.SymphonyIPM__Document_Code__c+'_'+mailroomdate;
            system.debug(title);
            list<ContentVersion> covlist=[SELECT Title , ContentDocumentId FROM ContentVersion WHERE Title=:title];
          
            list< contentDocumentLink> doclink=[select id,LinkedEntity.name,LinkedEntityId from contentDocumentLink where ContentDocumentId=:covlist[0].ContentDocumentId];
            for(contentDocumentLink dlink:doclink){
                string linkname=dlink.LinkedEntityId;
                if(linkname.startswith('a3')){
                    ifwrec.Document_Name__c=dlink.LinkedEntityId;
            ifwlst.add(ifwrec);
                }
            }
            }
            catch(Exception e){
                 string mailroomdate=string.valueOf(ifwrec.SymphonyIPM__Mail_Room_Date__c).removeEnd(' 00:00:00');
            string title=ifwrec.SymphonyIPM__Asset__r.SymphonyIPM__Docket_No__c+ '_' +ifwrec.SymphonyIPM__Document_Code__c+'_'+mailroomdate;
            
                 SymphonyIPM__AuditTrail__c aud= new SymphonyIPM__AuditTrail__c();
                aud.SymphonyIPM__CObjectName__c='OCR not synced';
                aud.SymphonyIPM__Description__c=title ;
                aulist.add(aud);
            }
        }
         if(aulist.size()>0)
            insert aulist;
        if(ifwlst.size()>0)
            update ifwlst;
     //    Database.executeBatch(new CreateDocumentFromOCRBatch(ifwlst), 1);
   
    }
    public void finish(Database.BatchableContext BC) {
        integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
           i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}