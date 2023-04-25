@isTest
public class PatentAttachmentsTriggerTest {
     @IsTest
    public static void test1() {
         SymphonyIPM__Patent__c patent1 = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'TestPatent', SymphonyIPM__Country_Code__c='CN',SymphonyIPM__Asset_Type__c='Design',SymphonyIPM__Docket_No__c = 'TP100029DEEPV2', SymphonyIPM__Status__c = 'Pending');
        insert patent1;
        SymphonyIPM__Patent_Attachments__c doc =new SymphonyIPM__Patent_Attachments__c();
        //doc.File_Name_Big__c = attachment.SymphonyIPM__Document_Type__c;
        doc.SymphonyIPM__Version__c='Final';
        doc.SymphonyIPM__Actor_Status__c='Approved';
       doc.SymphonyIPM__Patent__c=patent1.id;
        insert doc;
    }

    
}