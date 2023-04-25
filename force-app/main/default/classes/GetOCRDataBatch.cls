global with sharing class GetOCRDataBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    public String query;
    public Set<string> ApplicationNos;
    @TestVisible private static Map<String, PAIR_API__c> customset = new Map<String, PAIR_API__c>();
    @TestVisible private static String prerequisite;
    @TestVisible private static String key;
    @TestVisible private static String password;
    @TestVisible private static String clientId;
    @TestVisible private static String crawlerId;
    public Map<String, SymphonyIPM__IFW_Data_v1__c> ifwmap;
    public string strValue { get; set; }
    public Set<id> ifwidlist{set; get;}
    list<string> Doccodes=new list<string>{'NPL','FOR','WFEE','N417','OA.EMAIL','SRNT','SRFW','IDS','1449','FWCLM','892','DRW','IIFW','SCORE','DRW.NONBW','136A','WCLM','XT/','CRFE','371P'};
 
 global GetOCRDataBatch() {   
ifwidlist = NEW Set<ID>(); 
        ApplicationNos = new Set<string>();
      for(SymphonyIPM__IFW_Data_v1__c ifwlist:[select id,SymphonyIPM__Asset__r.SymphonyIPM__WIPO_App_No__c,SymphonyIPM__PDFFileName__c,SymphonyIPM__Activity_Id__c,SymphonyIPM__IfwDocumentId__c,SymphonyIPM__Application_Number__c,MxOCRStatus__c,SymphonyIPM__Document_Code__c,SymphonyIPM__Patent_Country_Code__c FROM SymphonyIPM__IFW_Data_v1__c where createddate>=2022-06-20T20:06:33.625+05:30  and SymphonyIPM__Is_Manual_Entry__c =false and 
        ((SymphonyIPM__Document_Code__c not in:Doccodes  and    (SymphonyIPM__Patent_Country_Code__c ='US' OR SymphonyIPM__Patent_Country_Code__c ='WO') and MxOCRStatus__c ='' )OR SymphonyIPM__PDFFileName__c=null ) and SymphonyIPM__Application_Number__c  !=null]){
        ApplicationNos.add(ifwlist.SymphonyIPM__Asset__r.SymphonyIPM__WIPO_App_No__c);                                            
       }
     for(SymphonyIPM__IFW_Data_v1__c ifwlist:[select id,SymphonyIPM__Asset__r.SymphonyIPM__WIPO_App_No__c,SymphonyIPM__PDFFileName__c,SymphonyIPM__Activity_Id__c,SymphonyIPM__IfwDocumentId__c,SymphonyIPM__Application_Number__c,MxOCRStatus__c,SymphonyIPM__Document_Code__c,SymphonyIPM__Patent_Country_Code__c FROM SymphonyIPM__IFW_Data_v1__c where createddate>=2022-06-20T20:06:33.625+05:30  and SymphonyIPM__Is_Manual_Entry__c =false and 
          (SymphonyIPM__Document_Code__c not in:Doccodes  and    (SymphonyIPM__Patent_Country_Code__c ='US' OR SymphonyIPM__Patent_Country_Code__c ='WO') ) and SymphonyIPM__Application_Number__c  !=null and Document_Name__c=null and  MxOCRStatus__c ='completed']){
        ApplicationNos.add(ifwlist.SymphonyIPM__Asset__r.SymphonyIPM__WIPO_App_No__c);  
     }
       query = 'SELECT SymphonyIPM__Application_Number__c,SymphonyIPM__Asset__c FROM SymphonyIPM__Application_Data_v1__c WHERE SymphonyIPM__Application_Number__c != null AND SymphonyIPM__Application_Number__c IN: ApplicationNos';
        system.debug(query);
     }
   
    global Database.QueryLocator start(Database.BatchableContext BC) {
        if (Schema.sObjectType.SymphonyIPM__Application_Data_v1__c.isAccessible() && SymphonyIPM__Application_Data_v1__c.sObjectType.getDescribe().isAccessible()) {
            system.debug(query);
            return Database.getQueryLocator(query);

        } else {
            return null;
        }
    }      
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
    Set<string> Activityidlist = new Set<string>();
    Map<string,string> PdfActivityMap= new Map<string,string>();
        List<string> PDFIFwidlist = new List <string>();
        string strAuditTrailLogText = '[ Started - GetIFWDataBatch - Execute]';
        try {
            //String endpoint = 'http://projects.maxval-ip.com/MaxvalPairAPIQA/PairService.svc/';
            system.debug(scope);
            string endpoint = '';
            customset = PAIR_API__c.getall();
            set<String> ApplicationNoSet = New set<String>();
             list<id> ifwinsertedids = new list<id>();
            for(String name : customset.keySet())
              {
                  prerequisite = name;
                  break;
              }
              key = PAIR_API__c.getInstance(prerequisite).apikey__c;
              password = PAIR_API__c.getInstance(prerequisite).apipassword__c;
              clientId = PAIR_API__c.getInstance(prerequisite).ClientId__c;
              crawlerId = PAIR_API__c.getInstance(prerequisite).crawlerId__c;
              endpoint = PAIR_API__c.getInstance(prerequisite).api_url__c + 'PairService.svc/';
              strAuditTrailLogText += '[ Inputs: key:' + key + ', password:' + password + ', clientId:' + clientId + ', crawlerId:' + crawlerId + ', endpoint:' + endpoint + ' ]'; 
            //clientId ='1';
            //crawlerId ='3';
            strAuditTrailLogText += '[ Scope Size:' + scope.size() + ' ]';
            ifwmap = new Map<String, SymphonyIPM__IFW_Data_v1__c>();
            integer i = 0;
            for (Sobject obj : scope) {
                SymphonyIPM__Application_Data_v1__c appData = (SymphonyIPM__Application_Data_v1__c) obj;
                String applicationNo = appData.SymphonyIPM__Application_Number__c;
                if (applicationNo != '')
                    ApplicationNoSet.add(applicationNo);
                String serviceLink = endpoint + 'GetIfwDetails/ClientId/' + clientId + '/CrawlerId/' + crawlerId + '/ApplicationNo/' + applicationNo;
                strAuditTrailLogText += '[ serviceLink :' + serviceLink + ' ]';
                HttpRequest req = new HttpRequest();
                req.setEndpoint(serviceLink);
                req.setMethod('GET');
                req.setHeader('apikey', key);
                req.setHeader('apipassword', password);
                req.setHeader('Content-type', 'text/xml');

                Http http = new Http();
                HTTPResponse res = null;
                try {
                    i = i + 1;
                    res = http.send(req);
                    system.debug('response is: ' + res);
                    //System.debug('Response :'+res +'**Body**'+res.getBody());
                    strAuditTrailLogText += '[ Response received : ' + res + ']';
                    // strAuditTrailLogText += '[ Response Body : '+res.getBody()+']';
                } catch (Exception e) {
                    strAuditTrailLogText += '[ Error:' + e.getMessage() + ' ]';
                    system.debug('catch entered: ' + e.getMessage());
                }

                Dom.Document xmldata;
                Dom.XmlNode xmlcontent;
                Dom.XmlNode queryresult;
                Dom.XmlNode ifwdata;
                Dom.XmlNode[] ifwlist;

                if (res != null)
                    if (res.getStatusCode() == 200) {
                        xmldata = res.getBodyDocument();
                        //System.debug(xmldata);
                        strAuditTrailLogText += '[ Response received ]' + xmldata;
                        xmlcontent = xmldata.getRootElement();
                        String namespace = xmlcontent.getNamespace();
                        ifwdata = xmlcontent.getChildElement('IfwInfoList', namespace);
                        queryresult = xmlcontent.getChildElement('QueryResult', namespace);
                        if (queryresult.getText() == '0 Record(s) found')
                            strAuditTrailLogText += '[ Response Body : ' + queryresult.getText() + ']';
                        ifwlist = ifwdata.getChildElements();
                        if (!ifwlist.isEmpty()) {
                            SymphonyIPM__IFW_Data_v1__c ifw;
                            if (Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.isCreateable() && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.isAccessible()) {
                                for (Dom.XmlNode element : ifwlist) {
                                    Dom.XmlNode[] ifwfields = element.getChildElements();
                                    ifw = new SymphonyIPM__IFW_Data_v1__c();
                                    if (Schema.sObjectType.SymphonyIPM__Application_Data_v1__c.fields.SymphonyIPM__Application_Number__c.isAccessible() && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__Application_Number__c.isCreateable())
                                        ifw.SymphonyIPM__Application_Number__c = appData.SymphonyIPM__Application_Number__c;
                                    if (Schema.sObjectType.SymphonyIPM__Application_Data_v1__c.fields.SymphonyIPM__Asset__c.isAccessible() && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__Asset__c.isCreateable())
                                        ifw.SymphonyIPM__Asset__c = appData.SymphonyIPM__Asset__c;
                                    for (Dom.XmlNode node : ifwfields) {
                                        string activityid='';
                                         system.debug('Node-->'+node.getName());
                                         if ( node.getName().equals('MxOCRStatus') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.MxOCRStatus__c.isCreateable()) {
                                              if (!String.isEmpty(node.getText())) { 
                                                  ifw.MxOCRStatus__c = node.getText();}
                                             else{
                                                 ifw.MxOCRStatus__c = '';  }
                                             }
                                        if (!String.isEmpty(node.getText())) {
                                        if(node.getName().equals('IfwDocumentId') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__IfwDocumentId__c.isCreateable()) {
                                                ifw.SymphonyIPM__IfwDocumentId__c = node.getText();
                                            }
                                             else if (node.getName().equals('PDFFileName') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__PDFFileName__c.isCreateable()) {
                                                ifw.SymphonyIPM__PDFFileName__c = node.getText();
                                            }
                                        }
                                  
                                    ifwmap.put(ifw.SymphonyIPM__IfwDocumentId__c,ifw);
                                    }
                            }
                        } else {
                            System.debug('Query Result : ' + queryresult.getText());
                        }
                    } else {
                        strAuditTrailLogText += '[ Response Status:' + res.getStatus() + ' ]';
                    }
            }
          List<id> IfwNoocrid= new List<id>();
 if (!ifwmap.isEmpty()) {
                try {
             if (Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.isCreateable() && SymphonyIPM__IFW_Data_v1__c.sObjectType.getDescribe().isCreateable()) {
                    // Update the Exisiting Activities MxOCR status to Completed
                   
               List<SymphonyIPM__IFW_Data_v1__c> updateifwlst= new List<SymphonyIPM__IFW_Data_v1__c>();
                List<SymphonyIPM__IFW_Data_v1__c> updatePDFifwlst= new List<SymphonyIPM__IFW_Data_v1__c>();
               for(SymphonyIPM__IFW_Data_v1__c Ifw:[select id,MxOCRStatus__c,SymphonyIPM__PDFFileName__c,SymphonyIPM__IfwDocumentId__c  from SymphonyIPM__IFW_Data_v1__c where SymphonyIPM__IfwDocumentId__c in:ifwmap.keySet() ]){
                  if(Ifw.SymphonyIPM__PDFFileName__c==null){
                  if(ifwmap.containskey(Ifw.SymphonyIPM__IfwDocumentId__c)){
                  Ifw.SymphonyIPM__PDFFileName__c=ifwmap.get(Ifw.SymphonyIPM__IfwDocumentId__c).SymphonyIPM__PDFFileName__c;
                  updatePDFifwlst.add(Ifw);
                  }
                  }
                  if(Ifw.MxOCRStatus__c!='Completed'){
                  IfwNoocrid.add(Ifw.id);
                   Ifw.MxOCRStatus__c='Completed';}
                  updateifwlst.add(Ifw);
                    } 
                if(updateifwlst.size()>0)
                update updateifwlst;
                if(updatePDFifwlst.size()>0)
                update updatePDFifwlst;
                }
                
             } catch (Exception e) {
                    strAuditTrailLogText += '[ Error raised while insert:' + e.getMessage() + ' | ' + e.getStackTraceString() + ' ]';
                }
            }
            
        if (IfwNoocrid.size() > 0) {
           list<SymphonyIPM__IFW_Data_v1__c> ifwdatarecs=[select id,name,MxOCRStatus__c,SymphonyIPM__Asset__c,SymphonyIPM__Document_Code__c,SymphonyIPM__Activity_Id__c from 
           SymphonyIPM__IFW_Data_v1__c WHERE   id IN:IfwNoocrid];
            for (SymphonyIPM__IFW_Data_v1__c ifwrec : ifwdatarecs) {
               if (ifwrec.SymphonyIPM__Document_Code__c!='NPL'&& ifwrec.SymphonyIPM__Document_Code__c!='FOR'  &&ifwrec.MxOCRStatus__c=='Completed' ) {
                 this.ifwidlist.add(ifwrec.id);
                }  
             }
          }
        list<SymphonyIPM__IFW_Data_v1__c> ifwwithnodocs=[select id,SymphonyIPM__Mail_Room_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Docket_No__c,
   SymphonyIPM__PDFFileName__c, SymphonyIPM__Activity_Id__c, SymphonyIPM__IFW_Reference_Id__c,SymphonyIPM__IfwDocumentId__c,
  SymphonyIPM__Application_Number__c,MxOCRStatus__c,SymphonyIPM__Document_Code__c,
  SymphonyIPM__Patent_Country_Code__c  from SymphonyIPM__IFW_Data_v1__c where createddate>=2022-06-20T20:06:33.625+05:30 and SymphonyIPM__Document_Code__c!='NPL' and SymphonyIPM__Document_Code__c!='FOR' and SymphonyIPM__Document_Code__c!='WFEE'
   and SymphonyIPM__Document_Code__c!='N417'  and SymphonyIPM__Document_Code__c!='OA.EMAIL'  and 
SymphonyIPM__Document_Code__c!='SRNT'  and SymphonyIPM__Document_Code__c!='SRFW'  and SymphonyIPM__Document_Code__c!='IDS'
   and SymphonyIPM__Document_Code__c!='1449' and SymphonyIPM__Document_Code__c!='FWCLM' 
  and SymphonyIPM__Document_Code__c!='892'  and SymphonyIPM__Document_Code__c!='DRW' and SymphonyIPM__Document_Code__c!='IIFW' 
and SymphonyIPM__Document_Code__c!='SCORE' and  SymphonyIPM__Document_Code__c!='DRW.NONBW' and  
 SymphonyIPM__Document_Code__c!='136A' and  SymphonyIPM__Document_Code__c!='WCLM' and  SymphonyIPM__Document_Code__c!='XT/' 
  and (SymphonyIPM__Patent_Country_Code__c ='US' OR SymphonyIPM__Patent_Country_Code__c ='WO') and SymphonyIPM__Is_Manual_Entry__c =false and MxOCRStatus__c ='completed' and Document_Name__c =null];         
       
                if(ifwwithnodocs.size()>0){
                     for (SymphonyIPM__IFW_Data_v1__c ifwrec : ifwwithnodocs) 
                    this.ifwidlist.add(ifwrec.id);
                }
                
       }
            
        } catch (Exception e) {
            strAuditTrailLogText += '[ Error raised:' + e.getMessage() + ' | ' + e.getStackTraceString() + ' ]';
        } finally {
            strAuditTrailLogText += '[ Stopped - GetOCRDataBatch - Execute]';
            SymphonyIPM__AuditTrail__c objAuditTrail = null;
            if (SymphonyIPM__AuditTrail__c.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.isUpdateable() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.isAccessible() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.isCreateable()) {
                objAuditTrail = new SymphonyIPM__AuditTrail__c();
                if (Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Action__c.isCreateable())
                    objAuditTrail.SymphonyIPM__Action__c = 'Insert';
                if (Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__CObjectName__c.isCreateable())
                    objAuditTrail.SymphonyIPM__CObjectName__c = 'GetOCRDataBatch - Execute';
                if (Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Description__c.isCreateable())
                    objAuditTrail.SymphonyIPM__Description__c = strAuditTrailLogText ;
                if (Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Status__c.isCreateable())
                    objAuditTrail.SymphonyIPM__Status__c = 'Success';
                if (Schema.sObjectType.SymphonyIPM__AuditTrail__c.isCreateable() && SymphonyIPM__AuditTrail__c.sObjectType.getDescribe().isCreateable())
                    insert objAuditTrail;
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        system.debug('strValue1 :' + strValue);
        system.debug('query :' + query);
         if (!ifwidlist.isEmpty()) {
              list<SymphonyIPM__IFW_Data_v1__c> ifwdatarecstogetdoc=[select  SymphonyIPM__Mail_Room_Date__c,SymphonyIPM__Asset__c,id,name,SymphonyIPM__PDFFileName__c,SymphonyIPM__Asset__r.SymphonyIPM__Docket_No__c,MxOCRStatus__c,SymphonyIPM__Document_Code__c from 
                                                                     SymphonyIPM__IFW_Data_v1__c where id in:ifwidlist];
             
             if(!test.isRunningTest())
                 Database.executeBatch(new CreateDocumentFromOCRBatch(ifwdatarecstogetdoc), 1);
             } 
             
             
        }
}