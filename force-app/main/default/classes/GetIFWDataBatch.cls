global with sharing class GetIFWDataBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    public String query;
    public String ApplicationNo;
    public List<string> ApplicationNos;
    public boolean createfradt;
    @TestVisible private static Map<String, PAIR_API__c> customset = new Map<String, PAIR_API__c>();
    @TestVisible private static String prerequisite;
    @TestVisible private static String key;
    @TestVisible private static String password;
    @TestVisible private static String clientId;
    @TestVisible private static String crawlerId;
  //  public List<SymphonyIPM__IFW_Data_v1__c> listifw;
    public Map<String, SymphonyIPM__IFW_Data_v1__c> ifwmap;
      list<SymphonyIPM__IFW_Data_v1__c> ifwdocrec= new list<SymphonyIPM__IFW_Data_v1__c>();
    public list<id> ifwidlist{set; get;}

    public List<SymphonyIPM__IFW_Data_v1__c> listifwtoCreateActivities { set; get; }
    public List<ID> listIFWIDtoCreateActivities {set; get;}
    public string strValue { get; set; }
   
     list<string> countrylist=new list<string>{'AU','CN','EP','JP','KR','US','WO'};
   global GetIFWDataBatch() {                                                               
        listIFWIDtoCreateActivities = NEW List<ID>();
            ifwidlist = NEW List<ID>();
        listifwtoCreateActivities = NEW List<SymphonyIPM__IFW_Data_v1__c>();
      // list<string> countrylist=new list<string>{'AU','CN','EP','JP','KR','US','WO'};
        query = 'SELECT SymphonyIPM__Application_Number__c,SymphonyIPM__Asset__c FROM SymphonyIPM__Application_Data_v1__c WHERE SymphonyIPM__Application_Number__c != null and SymphonyIPM__Asset__r.SymphonyIPM__Country_Code__c in:countrylist and SymphonyIPM__Asset__r.Stop_Sync__c!=true ';
        system.debug(query);
     }
    global GetIFWDataBatch(string strApplicationNo) {
        ApplicationNo = strApplicationNo;
        listIFWIDtoCreateActivities = NEW List<ID>();
         ifwidlist = NEW List<ID>();
        listifwtoCreateActivities = NEW List<SymphonyIPM__IFW_Data_v1__c>();
        query = 'SELECT SymphonyIPM__Application_Number__c,SymphonyIPM__Asset__c FROM SymphonyIPM__Application_Data_v1__c WHERE SymphonyIPM__Application_Number__c != null AND SymphonyIPM__Application_Number__c =\'' + ApplicationNo + '\'';
        strValue = 'Start';
        system.debug(query);
        //system.debug(strValue);
    }
    global GetIFWDataBatch(List<string> strApplicationNos) {
        ApplicationNos = strApplicationNos;
        createfradt=false;
        listIFWIDtoCreateActivities = NEW List<ID>();
         ifwidlist = NEW List<ID>();
        listifwtoCreateActivities = NEW List<SymphonyIPM__IFW_Data_v1__c>();
        query = 'SELECT SymphonyIPM__Application_Number__c,SymphonyIPM__Asset__c FROM SymphonyIPM__Application_Data_v1__c WHERE SymphonyIPM__Application_Number__c != null AND SymphonyIPM__Application_Number__c IN: ApplicationNos ';
        strValue = 'Start';
        system.debug(query);
        //system.debug(strValue);
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
                                         system.debug('Node-->'+node.getName());
                                         if ( node.getName().equals('MxDocumentDataStatus') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.MxDocumentDataStatus__c.isCreateable()) {
                                              if (!String.isEmpty(node.getText())) { 
                                                  ifw.MxDocumentDataStatus__c = node.getText();}
                                             else{
                                                 ifw.MxDocumentDataStatus__c = '';  }
                                            }
                                         if ( node.getName().equals('MxOCRStatus') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.MxOCRStatus__c.isCreateable()) {
                                              if (!String.isEmpty(node.getText())) { 
                                                  ifw.MxOCRStatus__c = node.getText();}
                                             else{
                                                 ifw.MxOCRStatus__c = '';  }
                                             }
                                        if (!String.isEmpty(node.getText())) {
                                             if(node.getName().equals('ActivityId') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__Activity_Id__c.isCreateable()) {
                                                ifw.SymphonyIPM__Activity_Id__c = node.getText();
                                            } else if (node.getName().equals('ApplicationId') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__Application_ID__c.isCreateable()) {
                                                ifw.SymphonyIPM__Application_ID__c = node.getText();
                                            } else if (node.getName().equals('DocumentDescription') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__Document_Description__c.isCreateable()) {
                                                ifw.SymphonyIPM__Document_Description__c = node.getText();
                                            } else if (node.getName().equals('FileWrapperDocumentCode') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__Document_Code__c.isCreateable()) {
                                                ifw.SymphonyIPM__Document_Code__c = node.getText();
                                            } else if (node.getName().equals('MailRoomDate') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__Mail_Room_Date__c.isCreateable()) {
                                                String mrDate = node.getText();
                                                mrDate = mrDate.replace('T', ' ');
                                                Date datefmt = Date.valueOf(mrDate);
                                                ifw.SymphonyIPM__Mail_Room_Date__c = datefmt;
                                            } else if (node.getName().equals('PDFFileName') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__PDFFileName__c.isCreateable()) {
                                                ifw.SymphonyIPM__PDFFileName__c = node.getText();
                                            } else if (node.getName().equals('PageQuantity') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__Page_Quantity__c.isCreateable()) {
                                                ifw.SymphonyIPM__Page_Quantity__c = node.getText();
                                            } else if (node.getName().equals('IfwDocumentId') && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__IfwDocumentId__c.isCreateable()) {
                                                ifw.SymphonyIPM__IfwDocumentId__c = node.getText();
                                            }
                                        }
                                    }
                                    // listifw.add(ifw);
                                    // ifwmap.put(String.valueOf(ifw.Mail_Room_Date__c).split(' ')[0]+ifw.Document_Code__c, ifw);

                                    if (ifw.SymphonyIPM__Application_Number__c.startsWith('US')) {
                                        if (Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__Application_Number__c.isAccessible() && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__IfwDocumentId__c.isAccessible()) {
                                            ifwmap.put(ifw.SymphonyIPM__Application_Number__c + ifw.SymphonyIPM__IfwDocumentId__c, ifw);
                                        }
                                    } else {
                                        if (Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__Mail_Room_Date__c.isAccessible() && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__Document_Code__c.isAccessible())
                                            ifwmap.put(String.valueOf(ifw.SymphonyIPM__Mail_Room_Date__c).split(' ')[0] + ifw.SymphonyIPM__Document_Code__c, ifw);
                                    }
                                }
                            }
                        } else {
                            System.debug('Query Result : ' + queryresult.getText());
                        }
                    } else {
                        strAuditTrailLogText += '[ Response Status:' + res.getStatus() + ' ]';
                    }
            }
            if (Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.isAccessible() && Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.fields.SymphonyIPM__IFW_Reference_Id__c.isAccessible()) {
               for (SymphonyIPM__IFW_Data_v1__c ifwdata : [SELECT id,SymphonyIPM__IFW_Reference_Id__c FROM SymphonyIPM__IFW_Data_v1__c WHERE SymphonyIPM__Application_Number__c IN:ApplicationNoSet AND SymphonyIPM__IFW_Reference_Id__c != null]) {
                    System.debug('Inside');
                  ifwmap.remove(ifwdata.SymphonyIPM__IFW_Reference_Id__c);
                 // ifwinsertedids.add(ifwdata.id);
                }
            }

            //for(IFW_Data_v1__c ifwdata : [SELECT Application_Number__c, IfwDocumentId__c FROM IFW_Data_v1__c WHERE IfwDocumentId__c != null]){
            //                ifwmap.remove(ifwdata.Application_Number__c + ifwdata.IfwDocumentId__c);
            //}

            //Map<string, IFW_Data_v1__c> LstIFWDataNew = new Map<string, IFW_Data_v1__c>();
            //Map<string, IFW_Data_v1__c> ifwdataDBList = [SELECT IfwDocumentId__c, Application_Number__c  FROM IFW_Data_v1__c WHERE IfwDocumentId__c != null];

            if (!ifwmap.isEmpty()) {
                try {
                
                    if (Schema.sObjectType.SymphonyIPM__IFW_Data_v1__c.isCreateable() && SymphonyIPM__IFW_Data_v1__c.sObjectType.getDescribe().isCreateable()) {
                        // insert ifwmap.values();  Actual code
                        this.listifwtoCreateActivities.addAll(ifwmap.values());
                        Database.SaveResult[] succList = Database.insert(ifwmap.values(), false);
                        for (Database.SaveResult sr : succList) {
                            if (sr.isSuccess()) {
                                ifwinsertedids.add(sr.id);
                            } else {
                                for (Database.Error objErr : sr.getErrors()) {
                                    System.debug('Error Occured' + objErr.getStatusCode() + ': ' + objErr.getMessage());
                                }
                            }
                        }
                        // IFW Draft FHA creatiion logic
                       
                        // Finish IFW draft Event Creation logic
                        system.debug('Inserted values :' + ifwmap.values());
                        for (SymphonyIPM__IFW_Data_v1__c IFW : ifwmap.values()) {
                            listIFWIDtoCreateActivities.add(IFW.id);

                            strValue += ',' + IFW.id;
                            //system.debug(strValue);
                            //listifwtoCreateActivities.add(IFW);
                            //system.debug('Recs-2-->'+listifwtoCreateActivities);
                            //system.debug('Ids-2-->'+listIFWIDtoCreateActivities);
                        }
                    }
                    
                  
                    

                } catch (Exception e) {
                    strAuditTrailLogText += '[ Error raised while insert:' + e.getMessage() + ' | ' + e.getStackTraceString() + ' ]';
                }
            }
            
              
                   
        if (ifwinsertedids.size() > 0) {
           list<SymphonyIPM__IFW_Data_v1__c> ifwdatarecs=[select id,name,MxOCRStatus__c,SymphonyIPM__Asset__c,SymphonyIPM__Document_Code__c from 
           SymphonyIPM__IFW_Data_v1__c WHERE id  IN:ifwinsertedids];
            for (SymphonyIPM__IFW_Data_v1__c ifwrec : ifwdatarecs) {
               // if (ifwrec.MxOCRStatus__c=='Completed' &&) {
               if (ifwrec.SymphonyIPM__Document_Code__c!='NPL'&& ifwrec.SymphonyIPM__Document_Code__c!='FOR'  &&ifwrec.MxOCRStatus__c=='Completed' ) {
                  //  ifwdocrec.add(ifwrec);
                   this.ifwidlist.add(ifwrec.id);
                }  
             }
            
       }
       
            
        } catch (Exception e) {
            strAuditTrailLogText += '[ Error raised:' + e.getMessage() + ' | ' + e.getStackTraceString() + ' ]';
        } finally {
            strAuditTrailLogText += '[ Stopped - GetIFWDataBatch - Execute]';
            SymphonyIPM__AuditTrail__c objAuditTrail = null;
            if (SymphonyIPM__AuditTrail__c.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.isUpdateable() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.isAccessible() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.isCreateable()) {
                objAuditTrail = new SymphonyIPM__AuditTrail__c();
                if (Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Action__c.isCreateable())
                    objAuditTrail.SymphonyIPM__Action__c = 'Insert';
                if (Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__CObjectName__c.isCreateable())
                    objAuditTrail.SymphonyIPM__CObjectName__c = 'GetIFWDataBatch - Execute';
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
        system.debug('From Finish method of GetIFWDataBatch Size :' + listIFWIDtoCreateActivities.size());
         if(listIFWIDtoCreateActivities.size()>0)
        {
           // system.debug('From Finish method of GetIFWDataBatch when IFW is avalilable and size of List : '+listIFWIDtoCreateActivities.size());
            if(!test.isRunningTest()){
            SymphonyIPM.InsertIFWRelatedDocActBatch ifwbDA = NEW SymphonyIPM.InsertIFWRelatedDocActBatch(listIFWIDtoCreateActivities,'Patent','Document Code');
                Id batchJobId = Database.executeBatch(ifwbDA, 1); }           
        }
       
              if (!ifwidlist.isEmpty()) {
              list<SymphonyIPM__IFW_Data_v1__c> ifwdatarecstogetdoc=[select  Document_Name__c,SymphonyIPM__Mail_Room_Date__c,SymphonyIPM__Asset__c,id,name,SymphonyIPM__PDFFileName__c,SymphonyIPM__Asset__r.SymphonyIPM__Docket_No__c,MxOCRStatus__c,SymphonyIPM__Document_Code__c from 
                                                                     SymphonyIPM__IFW_Data_v1__c where id in:ifwidlist and Document_Name__c=null ];
             
             if(!test.isRunningTest())
                 Database.executeBatch(new CreateDocumentFromOCRBatch(ifwdatarecstogetdoc), 1);
             } 
             
             
        }
}