public with sharing class CreateDocumentFromOCRBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    public List<SymphonyIPM__IFW_Data_v1__c> ifwdocumentcrecs;
    public static final String ENDPOINT = 'https://symphony.maxval-ip.com/MaxvalPairAPIPdfViewer/?ClientId=58&CrawlerId=139&PDFFileName=';
    public CreateDocumentFromOCRBatch(List<SymphonyIPM__IFW_Data_v1__c> ifwdocrecs) {
        this.ifwdocumentcrecs = ifwdocrecs;
     }
    public Iterable<SObject> start(Database.BatchableContext param1) {
         System.debug('IN THE START');
         if(this.ifwdocumentcrecs!=null)
             return this.ifwdocumentcrecs;
         else 
             return null;    
    }
   public void execute(Database.BatchableContext param1, List<SymphonyIPM__IFW_Data_v1__c> ifwdocumentrec) {
         
              try{
                  list<SymphonyIPM__IFW_Data_v1__c> updatifwrecs=new List<SymphonyIPM__IFW_Data_v1__c>();
            for (SymphonyIPM__IFW_Data_v1__c ifwrec : ifwdocumentrec) {
              PAIR_API__c Paircreds= PAIR_API__c.getValues('Prerequisites');
              string endpointdocekturl=Paircreds.DocketingURL__c+'ClientId='+Paircreds.ClientId__c+'&CrawlerId='+Paircreds.crawlerId__c+'&PDFFileName=';
              Blob document = OCRServiceController.fetchFileFromExternalUrl(endpointdocekturl+ifwrec.SymphonyIPM__PDFFileName__c + '_Searchable');
              
              ContentVersion contentVersion = new ContentVersion();
              contentVersion.VersionData = document; 
             // date maildate=date.valueof(ifwrec.SymphonyIPM__Mail_Room_Date__c);
              string mailroomdate=string.valueOf(ifwrec.SymphonyIPM__Mail_Room_Date__c).removeEnd(' 00:00:00');
              contentVersion.Title =  ifwrec.SymphonyIPM__Asset__r.SymphonyIPM__Docket_No__c+ '_' +ifwrec.SymphonyIPM__Document_Code__c+'_'+mailroomdate;
              contentVersion.PathOnClient = contentVersion.Title + '.pdf';
              insert contentVersion;
              
              list<ContentVersion> covlist=[SELECT Title , ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.id];
              Document_History__c documentHistory = new Document_History__c();
             // documentHistory.IFW_Data__c = ifwrec.id;
               documentHistory.Patent__c= ifwrec.SymphonyIPM__Asset__c;
              insert documentHistory;
              
              ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
              contentDocumentLink.ContentDocumentId = covlist[0].ContentDocumentId;
              contentDocumentLink.LinkedEntityId = documentHistory.Id;
              
                       insert contentDocumentLink;
            ifwrec.Document_Name__c=documentHistory.id;
                updatifwrecs.add(ifwrec);
            }
              if(updatifwrecs.size()>0)
                  update updatifwrecs;
              }
              catch(Exception e){
                  system.debug('Error '+e.getMessage());
              }
          
      }
    
 public void finish(Database.BatchableContext param1) { }
}