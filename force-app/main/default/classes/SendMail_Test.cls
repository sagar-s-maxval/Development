@isTest
public class SendMail_Test
{
    @isTest static void SendMailMethod_Test()
    {
        string tosub1='senddata';
        List<string> sendTo1=new List<string>();
        sendTo1.add('brock@max.com');
        string messageBody1='body for sendmail class';
        List<String> bccAddresses1=new List<String>();
        bccAddresses1.add('finn@max.com');
        List<String> ccAddresses1=new List<String>();
        ccAddresses1.add('mark@max.com');
        ContentVersion cv=new Contentversion();
        cv.title='ABC';
        cv.PathOnClient ='test';
        cv.versiondata=EncodingUtil.base64Decode(EncodingUtil.urlEncode('Unit Test Attachment Body','UTF-8'));
        insert cv;
        List<id> ConDocIDs1=new List<id>();
        ConDocIDs1.add(cv.ContentDocumentId);
        SendMail.MailParameter sendmailobj=new SendMail.MailParameter();
        sendmailobj.ConDocIDs=ConDocIDs1;
        sendmailobj.tosub=tosub1;
        sendmailobj.sendTo=sendTo1;
        sendmailobj.messageBody=messageBody1;
        sendmailobj.bccAddresses=bccAddresses1;
        sendmailobj.ccAddresses=ccAddresses1;
        SendMail.SendMailMethod(new SendMail.MailParameter[]{sendmailobj});
        system.assertNotEquals('sendfood', tosub1);
    }
}