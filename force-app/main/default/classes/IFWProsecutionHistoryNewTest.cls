@isTest
public class IFWProsecutionHistoryNewTest
{
  //@testsetup static void testData()
  public static testmethod void TrademarkControllerMethod()
  {
      
    SymphonyIPM__Patent__c pat=new SymphonyIPM__Patent__c();
    pat.Name='patent1';
    pat.SymphonyIPM__Title_of_Invention__c='title1';
    pat.SymphonyIPM__WIPO_App_No__c='EP08755145';
    insert pat;
    System.assertEquals('patent1',pat.Name);
    
    SymphonyIPM__MPatent_PAIR_Analytics__mdt setting = new SymphonyIPM__MPatent_PAIR_Analytics__mdt();
    setting.MasterLabel = 'Prerequisite';
    setting.SymphonyIPM__All_IFW_code__c = 'NOA,RXNIRC,RXCERT,SE.CRT.SNQ.N,SE.CRT.SNQ.Y,';
    setting.SymphonyIPM__First_Allowance_IFW_Code__c ='NOA,RXNIRC,RXCERT,SE.CRT.SNQ.N';
    setting.SymphonyIPM__First_Action_IFW_code__c ='CTFR,CTNF,RXR.NF,RXFR..,CTRS,NOA';
    
    date d=date.newInstance(2019,01,30);
    SymphonyIPM__IFW_Data_v1__c ifwdatav1=new SymphonyIPM__IFW_Data_v1__c();
    ifwdatav1.Name='test1';
    ifwdatav1.SymphonyIPM__Asset__c=pat.id;
    ifwdatav1.SymphonyIPM__Document_Code__c='doc1';
    ifwdatav1.SymphonyIPM__Document_Description__c='desc';
    ifwdatav1.SymphonyIPM__Mail_Room_Date__c=d;
    ifwdatav1.SymphonyIPM__OCR_File_Name__c='ocr';
    ifwdatav1.SymphonyIPM__PDFFileName__c='pdf1';
    ifwdatav1.SymphonyIPM__Application_Number__c ='123';
    insert ifwdatav1;
    System.assertEquals('test1',ifwdatav1.Name);
    
   /* SymphonyIPM__PAIR_API_PARAMETERSV1_P__c pair = new SymphonyIPM__PAIR_API_PARAMETERSV1_P__c();
    pair.name = 'Prerequisites';
    pair.SymphonyIPM__apikey__c = 'API key';
    pair.SymphonyIPM__apipassword__c = 'abcde';
    pair.SymphonyIPM__ClientId__c = '141';
    pair.SymphonyIPM__crawlerId__c ='141';
    pair.SymphonyIPM__apiurl__c = 'URl@url.com';
    insert pair;
    System.assertEquals('Prerequisites',pair.name);  */
    
    SymphonyIPM__AdminConfigSettingsV1__c adm = new SymphonyIPM__AdminConfigSettingsV1__c();
      adm.name = 'Admin Config';  
      adm.SymphonyIPM__Enable_Auto_Dedocketing__c = true; 
      adm.SymphonyIPM__Enable_Auto_Docketing__c = true; 
      adm.SymphonyIPM__Enable_Auto_Sync__c = true;  
      adm.SymphonyIPM__Enable_Download_PDF_for_IFW__c = true; 
      adm.SymphonyIPM__Options__c = true;
      adm.SymphonyIPM__Help_Doc_Key__c ='Symphony 2019'; 
      insert adm;
      System.assertEquals('Admin Config',adm.name);    
    
    SymphonyIPM__BatchScopeSize__c bss=new SymphonyIPM__BatchScopeSize__c();
    bss.Name='Default';
    bss.SymphonyIPM__IFWDataBatch__c=123;
    bss.SymphonyIPM__PAIRBiblioBatch__c=111;
    insert bss;
    System.assertEquals('Default',bss.Name);    
    
   /* test.startTest();
    IFWProsecutionHistory ifwdata = New IFWProsecutionHistory();
    IFWProsecutionHistory.fetchIFWProsecutionHistory1(pat.id);
    IFWProsecutionHistory.fetchIFWLastSyncedDate(pat.id);
    IFWProsecutionHistory.IFWsync(pat.id);
    IFWProsecutionHistory.PairAnalyticsync(pat.id);
    IFWProsecutionHistory.PairApplicationsync(pat.id);
    IFWProsecutionHistory.PairApplicationBibilosync(pat.id);
    PAIRServiceAppMapBatchforlght pa = new PAIRServiceAppMapBatchforlght();
    Database.executeBatch(pa);
    test.stopTest(); */
      
      
      IFWProsecutionHistoryNew.fetchIFWProsecutionHistory1(pat.id);
      IFWProsecutionHistoryNew.fetchIFWLastSyncedDate(pat.id);
      IFWProsecutionHistoryNew.IFWsync(pat.id);
      IFWProsecutionHistoryNew.PairAnalyticsync(pat.id);
      IFWProsecutionHistoryNew.PairApplicationsync(pat.id);
      IFWProsecutionHistoryNew.PairApplicationBibilosync(pat.id);
  }
  
}