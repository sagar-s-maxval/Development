@isTest
public class IDFRecordDetailPageControllerTest 
{
	@TestSetup
    public static void TestData()
    {
        SymphonyIPM__Invention_Disclosure_New__c objInventionDisclosure = new SymphonyIPM__Invention_Disclosure_New__c();
        objInventionDisclosure.SymphonyIPM__Title__c = 'Test IDF';
        objInventionDisclosure.PRB_Decision__c = 'Withdrawn';
        objInventionDisclosure.Managing_Segment_New__c = 'Amil';
        INSERT objInventionDisclosure;
        
        SymphonyIPM__Inventor__c objInventor = new SymphonyIPM__Inventor__c();
        objInventor.Name = 'Test Inventor';
        objInventor.Nick_Name__c = 'Nick';
        objInventor.First_Name__c = 'Test';
        objInventor.Last_Name__c = 'Inventor';
        objInventor.SymphonyIPM__Email__c = 'testinventor@test.com';
        objInventor.RecordTypeId = Schema.SObjectType.SymphonyIPM__Inventor__c.getRecordTypeInfosByName().get('Inventor').getRecordTypeId();
        objInventor.SymphonyIPM__RecordTypeName__c = 'Inventor';
        INSERT objInventor;
        
        SymphonyIPM__Additional_Inventor__c objAdditionalInv = new SymphonyIPM__Additional_Inventor__c();
        objAdditionalInv.SymphonyIPM__Invention_Disclosure_New__c = objInventionDisclosure.id;
        objAdditionalInv.SymphonyIPM__Inventor__c = objInventor.id;
        INSERT objAdditionalInv;
    }
    
    @isTest static void GetRecordDetailsTest()
    {
        String objectName;
        string fieldname = 'Managing_Segment_New__c';
        SymphonyIPM__Invention_Disclosure_New__c objIdf = [SELECT id,Name,SymphonyIPM__Title__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE SymphonyIPM__Title__c = 'Test IDF'];
    	IDFRecordDetailPageController.GetRecordDetails(objIdf.id);
      
    }
}