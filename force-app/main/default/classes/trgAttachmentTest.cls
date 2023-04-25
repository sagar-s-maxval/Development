@istest
public class trgAttachmentTest {
    
    static testMethod void testAttachments()
    {
        SymphonyIPM__Patent__c patent = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'TestPatent', SymphonyIPM__Docket_No__c = 'TP100029DEEPV2',SymphonyIPM__Case_Type__c='Provisional');
        insert patent;
        EmailMessage  em= new EmailMessage ();
        em.RelatedToId =patent.id;
        em.Subject='[TP104314USCON4]Sep 22-2';
        em.HtmlBody ='	<div dir="ltr">Without attachments</div>';
        em.ToAddress='inboundemails@q-21ska6d1k5sqs1k4olg40s5c7xvguubarwcnp90yg1ssc9jn74.8l-4emuuay.cs224.apex.sandbox.salesforce.com';
        em.FromAddress='yuvasree.s@maxval.com';
        insert em;
 Emai_Tracker__c emt=new Emai_Tracker__c();
        emt.Email_Message_Id__c=em.id;
        insert emt;
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=em.id;
        insert attach;
    	
            
    	List<Attachment> attachments=[select id, name from Attachment where parent.id=:em.id];
    	System.assertEquals(1, attachments.size());
    }

}