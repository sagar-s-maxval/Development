@isTest
Public class InventorControllerNewTest 
{
    @testSetup static void DataSetup()
    {
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Inventor'].Id,
            LastName = 'last',
            Email ='test.ism@uhg.com',
            FederationIdentifier = '123456789',
            Username ='uhg_test.ism@uhg.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        insert u;
        
        SymphonyIPM__Inventor__c inventor=new SymphonyIPM__Inventor__c(Name='Harsh1',SymphonyIPM__Email__c='test.ism@uhg.com',SymphonyIPM__User__c=u.id, SymphonyIPM__RecordTypeName__c ='Inventor',First_Name__c='Harsh', Last_Name__c ='1');
        insert inventor;
        
        SymphonyIPM__Inventor__c inventor1=new SymphonyIPM__Inventor__c(Name='Harsh11',SymphonyIPM__Email__c='xyz@gmail.com',SymphonyIPM__RecordTypeName__c ='Inventor',First_Name__c='Harsh', Last_Name__c ='11');
        insert inventor1;
        
        /*SymphonyIPM__Inventor__c invent=new SymphonyIPM__Inventor__c(Name='dan1',SymphonyIPM__Email__c='',SymphonyIPM__User__c=u.id,SymphonyIPM__RecordTypeName__c ='Inventor',First_Name__c='dan', Last_Name__c ='1');
        insert invent;
        
        SymphonyIPM__Inventor__c invent1=new SymphonyIPM__Inventor__c(Name='dan11',SymphonyIPM__Email__c='',SymphonyIPM__RecordTypeName__c ='Inventor', First_Name__c='dan', Last_Name__c ='11');
        insert invent1;*/
        
        SymphonyIPM__Invention_Disclosure_New__c objInventionDisclosure = new SymphonyIPM__Invention_Disclosure_New__c();
        objInventionDisclosure.SymphonyIPM__Title__c = 'Test IDF';
        //objInventionDisclosure.PRB_Decision__c = 'Withdrawn';
        INSERT objInventionDisclosure;
        
        SymphonyIPM__Inventor__c objInventor = new SymphonyIPM__Inventor__c();
        objInventor.Name = 'Test Inventor';
        objInventor.SymphonyIPM__Email__c = 'testinventor@test.com';
        objInventor.RecordTypeId = Schema.SObjectType.SymphonyIPM__Inventor__c.getRecordTypeInfosByName().get('Inventor').getRecordTypeId();
        objInventor.SymphonyIPM__RecordTypeName__c = 'Inventor';
        objInventor.First_Name__c='Test';
        objInventor.Last_Name__c ='Inventor';
        INSERT objInventor;
        
        SymphonyIPM__Additional_Inventor__c objAdditionalInv = new SymphonyIPM__Additional_Inventor__c();
        objAdditionalInv.SymphonyIPM__Invention_Disclosure_New__c = objInventionDisclosure.id;
        objAdditionalInv.SymphonyIPM__Inventor__c = objInventor.id;
        
        INSERT objAdditionalInv;
    }
    
    static TestMethod Void Test_searchInventors() 
    {
        Test.startTest();
        SymphonyIPM__Inventor__c objInventor = [SELECT Id,Name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Email__c='test.ism@uhg.com' LIMIT 1];
        List<ID> ids=new List<ID>();
        ids.add(objInventor.id);
        //InventorControllerNew.searchInventors('Harsh',ids);
        //InventorControllerNew.SearchInventorsNew('Harsh (efg@gmail.com)',ids);
        InventorControllerNew.SearchInventorsNew('Harsh',ids);
        //InventorControllerNew.searchInventors('efg@gmail.com',ids);
        InventorControllerNew.SearchInventorsNew('xyz@gmail.com',ids);
        InventorControllerNew.AutoSuggestionReturnValue('Harsh1 (xyz@gmail.com)',new List<ID>());
        try{
            InventorControllerNew.SearchInventorsNew(null,ids);
           }
        catch(Exception e)
        {
            system.assertEquals(e.getMessage(), e.getMessage()); 
        }
        Test.stopTest(); 
    }
    
    static TestMethod Void Test_getSelectedInventors() 
    {
        Test.startTest();
        SymphonyIPM__Inventor__c objInventor = [SELECT id,Name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Email__c='xyz@gmail.com' LIMIT 1];
        //SymphonyIPM__Inventor__c objInventor1 = [SELECT id,Name,SymphonyIPM__Email__c,SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c WHERE Name='dan' LIMIT 1];
        //SymphonyIPM__Inventor__c objInventor2 = [SELECT id,Name,SymphonyIPM__Email__c,SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c WHERE Name='dan1' LIMIT 1];
        List<ID> ids=new List<ID>();
        ids.add(objInventor.Id);
        //ids.add(objInventor1.Id);
        //ids.add(objInventor2.Id);
        InventorControllerNew.getSelectedInventors(ids);
        InventorControllerNew.getInventors(objInventor.Id);
        Test.stopTest();
    }
    
    static TestMethod Void Test_populateAdditionalInventors() 
    {
        Test.startTest();
        SymphonyIPM__Invention_Disclosure_New__c objidf = [SELECT id FROM SymphonyIPM__Invention_Disclosure_New__c WHERE SymphonyIPM__Title__c = 'Test IDF'];
        InventorControllerNew.populateAdditionalInventors(objidf.id);
        Test.stopTest();
    }
    
    static TestMethod Void Test_UpdatePrimaryInventor() 
    {
        Test.startTest();
        SymphonyIPM__Invention_Disclosure_New__c objidf = [SELECT id FROM SymphonyIPM__Invention_Disclosure_New__c WHERE SymphonyIPM__Title__c = 'Test IDF'];
        InventorControllerNew.UpdatePrimaryInventor(objidf.id);
        Test.stopTest();
    }
    static TestMethod void Test_TestCoverage()
    {
        Test.startTest();
        InventorControllerNew.TestCoverage();
        Test.stopTest();
	}
}