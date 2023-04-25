@isTest
public class GetIFWDataBatchTest {
    @testSetup static void TestSetup_Method(){
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        
        //For trgPatent_apple class for creating dummy patent record and for loadFHATransactionDetails Method
        SymphonyIPM__Entity__c objEntity=new SymphonyIPM__Entity__c();
        objEntity.Name='Apple Inc.';
       // objEntity.Third_Party_Law_Firm__c = true;
        insert objEntity;
        
        // jurisdiction
        SymphonyIPM__Country__c objCountry = new SymphonyIPM__Country__c(); 
        objCountry.Name = 'India';
        insert objCountry;
        SymphonyIPM__Law_Firm__c objLawFirm = new SymphonyIPM__Law_Firm__c();
        objLawFirm.City__c='Chennai';
       // objLawFirm.Country__c=objCountry.Id;
        objLawFirm.Name='Test_Law_Firm7';
        insert objLawFirm;     
        
        SymphonyIPM__Patent__c objpatent = new SymphonyIPM__Patent__c();  
        objpatent.Name = 'Patent';
        objpatent.SymphonyIPM__Title_of_Invention__c = 'Hello World';
        objpatent.SymphonyIPM__Case_Type__c = 'Provisional';
        objpatent.SymphonyIPM__Country__c = objCountry.Id;
        objpatent.Law_Firm__c=objLawFirm.Id;
       // objpatent.Create_FHA_Draft__c=true;
        objpatent.SymphonyIPM__Country_Code__c='US';
        objpatent.SymphonyIPM__Outside_Counsel__c=u.Id;
        objpatent.SymphonyIPM__Asset_Type__c = 'Patent';
        objpatent.SymphonyIPM__Status__c = 'Issued';
        INSERT objpatent;
        
        //For Deletedocactivity Method and getDocketingActivities Method
        SymphonyIPM__Docketing_Activity_v2__c ObjDocAct = new SymphonyIPM__Docketing_Activity_v2__c(SymphonyIPM__Trigger__c = 'Filing date');
        objDocAct.SymphonyIPM__Patent__c = objpatent.id;
        objDocAct.SymphonyIPM__Actions__c = 'Adjusted Expiry';
        objDocAct.SymphonyIPM__Due_Date__c = Date.today();
        ObjDocAct.SymphonyIPM__Is_Completed__c = true;
        ObjDocAct.SymphonyIPM__Reason_to_Complete__c = 'complete';
        ObjDocAct.SymphonyIPM__Completion_Date__c = date.today();
        ObjDocAct.SymphonyIPM__Activity_Date__c = date.today();
        insert ObjDocAct;
        
        
        
        
        //For Doc Rule Engine
        SymphonyIPM__Docketing_Rule_Engine__c objDocRuleEng = new SymphonyIPM__Docketing_Rule_Engine__c();
        objDocRuleEng.SymphonyIPM__Trigger__c = 'at case creation';
        objDocRuleEng.SymphonyIPM__Docket_Action__c = 'Expiry';
        objDocRuleEng.Name = 'Expiry';
       // objDocRuleEng.FHA_Event_Master__c  = objFHAMas.Id;
        objDocRuleEng.SymphonyIPM__Jurisdiction__c=objCountry.Id;
        objDocRuleEng.SymphonyIPM__Trigger__c='CTAV';
        objDocRuleEng.SymphonyIPM__Trigger_Type__c='Event';
        objDocRuleEng.SymphonyIPM__Asset_Type__c='Patent';
        objDocRuleEng.SymphonyIPM__Case_Type__c = 'Provisional';
        insert objDocRuleEng;
        
        //Object IFW_data_V1
        SymphonyIPM__IFW_Data_v1__c ObjIFWdata = new SymphonyIPM__IFW_Data_v1__c();
       // ObjIFWdata.SymphonyIPM__Asset__r=objpatent.id;
        ObjIFWdata.SymphonyIPM__Activity_Id__c = '30028276';
        ObjIFWdata.SymphonyIPM__Application_ID__c = Null;
        ObjIFWdata.SymphonyIPM__Application_Number__c = 'E2000087';
        ObjIFWdata.SymphonyIPM__Asset__c = objpatent.Id;
        ObjIFWdata.SymphonyIPM__Auto_Approve_Override__c = false;
        ObjIFWdata.SymphonyIPM__CustomDate1__c = Null;
        ObjIFWdata.SymphonyIPM__CustomDate2__c = Null;
        ObjIFWdata.SymphonyIPM__Document_Code__c='CTAV';
        ObjIFWdata.SymphonyIPM__Document_Description__c='desc';
        ObjIFWdata.SymphonyIPM__OCR_File_Name__c='ocr';
        ObjIFWdata.SymphonyIPM__PDFFileName__c='pdf1';
        ObjIFWdata.SymphonyIPM__Trigger__c='ISR & Written Opinion Transmittal';
        ObjIFWdata.SymphonyIPM__Is_Manual_Entry__c = False;
        insert ObjIFWdata;
        
        //Application_Data_v1
        SymphonyIPM__Application_Data_v1__c AppDatav1 = new SymphonyIPM__Application_Data_v1__c();
        AppDatav1.Name='APNO-US15780754';
        AppDatav1.SymphonyIPM__AIA_First_Inventor_to_File__c = Null;
        AppDatav1.SymphonyIPM__Application_ID__c = '1049999';
        AppDatav1.SymphonyIPM__Asset__c=objpatent.id;
        AppDatav1.SymphonyIPM__Application_Number__c ='US1254697007';
        AppDatav1.SymphonyIPM__Application_Type__c = 'Utility';
        AppDatav1.SymphonyIPM__Asset__c = objpatent.Id;
        insert AppDatav1;       
        
        PAIR_API__c PA = new PAIR_API__c();
        PA.Name = 'Pair Api';
        PA.apipassword__c='password';
        PA.API_URL__c='';
        PA.ClientId__c='1';
        PA.crawlerId__c='3';
        PA.apikey__c ='key';
        Insert PA;
        
    }
    @isTest static void Test_GetIFWDataBatch(){
        //GetIFWDataBatch();
        SymphonyIPM__Patent__c objpatent = [select id,SymphonyIPM__Application_Number__c from SymphonyIPM__Patent__c limit 1];  
     // objpatent.Create_FHA_Draft__c=true;
      //  update objpatent;
        IFWProsecutionHistoryNew.IFWsync(objpatent.Id);
        Test.setMock(HttpCalloutMock.class, new GetIFWDataBatchMockImpl());
        
        Test.startTest();
        GetIFWDataBatch obj = new GetIFWDataBatch();
        DataBase.executeBatch(obj);
        Test.stopTest();
    }
  /*  @isTest static void Test_GetIFWDataBatch2(){
        //GetIFWDataBatch();
        SymphonyIPM__Patent__c objpatent = [select id,SymphonyIPM__Application_Number__c from SymphonyIPM__Patent__c limit 1];  
        IFWProsecutionHistoryNew.IFWsync(objpatent.Id);
        Test.setMock(HttpCalloutMock.class, new GetIFWDataBatchMockImpl());
        list<string> appno= new list<string>();
        appno.add(objpatent.SymphonyIPM__Application_Number__c); 
        Test.startTest();
        GetIFWDataBatch obj = new GetIFWDataBatch(appno);
        DataBase.executeBatch(obj);
        Test.stopTest();
    }*/
    
}