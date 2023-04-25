@isTest
Private class CreateDocumentFromOCRBatchTest {
    // Set up for whole data
    @testSetup static void TestSetup_Method(){
             
        //For trgPatent_apple class for creating dummy patent record and for loadFHATransactionDetails Method
        SymphonyIPM__Entity__c objEntity=new SymphonyIPM__Entity__c();
        objEntity.Name='Apple Inc.';
        insert objEntity;
        
        // jurisdiction
        SymphonyIPM__Country__c objCountry = new SymphonyIPM__Country__c(); 
        objCountry.Name = 'India';
        insert objCountry;
        
         SymphonyIPM__Patent__c objpatent = new SymphonyIPM__Patent__c();  
        objpatent.SymphonyIPM__Title_of_Invention__c = 'Hello World';
        objpatent.SymphonyIPM__Case_Type__c = 'Provisional';
        objpatent.SymphonyIPM__Country__c = objCountry.Id;
        objpatent.SymphonyIPM__Asset_Type__c = 'Patent';
        objpatent.SymphonyIPM__Status__c = 'Issued';
        INSERT objpatent;
        
        SymphonyIPM__IFW_Data_v1__c ifw = new SymphonyIPM__IFW_Data_v1__c();
        ifw.SymphonyIPM__Asset__c = objpatent.Id;
        ifw.SymphonyIPM__Document_Code__c ='ISSUE.NTF';
        ifw.SymphonyIPM__Mail_Room_Date__c =system.today();
        ifw.SymphonyIPM__PDFFileName__c ='test';
        insert ifw;
        
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
        
       
        
        //for SymphonyIPM__Docketing_Rule_Engine__c object  select id,SymphonyIPM__Trigger__c,SymphonyIPM__Docket_Action__c from SymphonyIPM__Docketing_Rule_Engine__c where FHA_Event_Master__c=:listFHAEvt[0].FHA_Master__r.id
        SymphonyIPM__Docketing_Rule_Engine__c objDocRuleEng = new SymphonyIPM__Docketing_Rule_Engine__c();
        objDocRuleEng.SymphonyIPM__Trigger__c = 'at case creation';
        objDocRuleEng.SymphonyIPM__Docket_Action__c = 'Expiry';
        objDocRuleEng.Name = 'Expiry';
       // objDocRuleEng.FHA_Event_Master__c  = objFHAMas.Id;
        insert objDocRuleEng;
       
        
     
    }
    // for getPicklistValues(String objectName, String fieldapiname,Boolean nullRequired) Method
    @isTest static void Test_getPicklistValues(){
        Test.startTest();
        List<SymphonyIPM__IFW_Data_v1__c> ifwrec=[select  SymphonyIPM__Mail_Room_Date__c,SymphonyIPM__Asset__c,id,name,SymphonyIPM__PDFFileName__c,SymphonyIPM__Asset__r.SymphonyIPM__Docket_No__c,MxOCRStatus__c,SymphonyIPM__Document_Code__c from 
                                                                     SymphonyIPM__IFW_Data_v1__c];
        try{
             PAIR_API__c PA = new PAIR_API__c();
        PA.Name = 'Prerequisites';
        PA.apipassword__c='password';
        PA.API_URL__c='https://symphony.maxval-ip.com/QA/PairService.svc/';
        PA.ClientId__c='1';
        PA.crawlerId__c='3';
        PA.apikey__c ='key';
        Insert PA;
          //   CreateDocumentFromOCRBatch.process(ifwrec);
           Database.executeBatch(new CreateDocumentFromOCRBatch(ifwrec));
        }catch(Exception e){
        }
        Test.stopTest();
    }

}