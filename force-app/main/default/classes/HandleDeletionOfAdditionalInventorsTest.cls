@isTest
public class HandleDeletionOfAdditionalInventorsTest 
{
	@testSetup static void DataSetup()
    {
        SymphonyIPM__Invention_Disclosure_New__c objInventionDisclosure = new SymphonyIPM__Invention_Disclosure_New__c();
        objInventionDisclosure.SymphonyIPM__Title__c = 'Test IDF';
        INSERT objInventionDisclosure;
    } 
    
    @isTest
	static Void Test_populateAdditionalInventors() 
    {
		Test.startTest();
		SymphonyIPM__Invention_Disclosure_New__c objidf = [SELECT id FROM SymphonyIPM__Invention_Disclosure_New__c WHERE SymphonyIPM__Title__c = 'Test IDF'];
		//SymphonyIPM__Inventor__c objInventor = [SELECT id,Name FROM SymphonyIPM__Inventor__c WHERE Name='Test Inventor']
		SymphonyIPM__Inventor__c objInventor = new SymphonyIPM__Inventor__c();
        objInventor.Name = 'Test Inventor';
        objInventor.SymphonyIPM__Email__c = 'testinventor@test.com';
        objInventor.RecordTypeId = Schema.SObjectType.SymphonyIPM__Inventor__c.getRecordTypeInfosByName().get('Inventor').getRecordTypeId();
        objInventor.SymphonyIPM__RecordTypeName__c = 'Inventor';
        objInventor.Nick_Name__c = 'Tester';
        INSERT objInventor;
        SymphonyIPM__Additional_Inventor__c objAdditionalInv = new SymphonyIPM__Additional_Inventor__c();
        objAdditionalInv.SymphonyIPM__Invention_Disclosure_New__c = objidf.id;
        objAdditionalInv.SymphonyIPM__Inventor__c = objInventor.id;
        INSERT objAdditionalInv;
        String temp = objidf.id+'-'+objInventor.id+':RoleOfConception:'+true+':testinventor@test.com';
		List<string> inputvalue = new List<string>();
        inputvalue.add(temp);
		HandleDeletionOfAdditionalInventors.DeleteAdditionalInventors(inputvalue);
		Test.stopTest();
	}
}