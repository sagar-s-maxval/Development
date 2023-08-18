@isTest
public class PrimaryContactControllerTest {

    @testSetup static void DataSetup()
    {
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Inventor'].Id,
            LastName = 'last',
            Email ='xyz@gmail.com',
            Username ='puser0067@amamama@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        insert u;
        
        SymphonyIPM__Inventor__c inventor=new SymphonyIPM__Inventor__c(Name='Harsh',SymphonyIPM__Email__c='efg@gmail.com',SymphonyIPM__User__c=u.id,SymphonyIPM__RecordTypeName__c ='Inventor');
        insert inventor;
        
        SymphonyIPM__Inventor__c inventor1=new SymphonyIPM__Inventor__c(Name='Harsh1',SymphonyIPM__Email__c='xyz@gmail.com',SymphonyIPM__User__c=u.id,SymphonyIPM__RecordTypeName__c ='Inventor');
        insert inventor1;
        SymphonyIPM__Inventor__c invent=new SymphonyIPM__Inventor__c(Name='dan',SymphonyIPM__Email__c='',SymphonyIPM__User__c=u.id,SymphonyIPM__RecordTypeName__c ='Inventor');
        insert invent;
        SymphonyIPM__Inventor__c invent1=new SymphonyIPM__Inventor__c(Name='dan1',SymphonyIPM__Email__c='',SymphonyIPM__RecordTypeName__c ='Inventor');
        insert invent1;
    }
    static TestMethod Void Test_searchInventors() 
    {
       Test.startTest();
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Inventor'].Id,
            LastName = 'last',
            Email ='xyz@gmail.com',
            Username ='puser0067@amamama@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        insert u;
        
        List<wrapperComboboxOption> objOptions = new List<wrapperComboboxOption>();
       // User objUser=[SELECT Email FROM User WHERE CompanyName = 'TEST1' LIMIT 1];
         SymphonyIPM__Inventor__c inventor=new SymphonyIPM__Inventor__c(Name='Harsh',SymphonyIPM__Email__c='efg@gmail.com',SymphonyIPM__User__c=u.id,SymphonyIPM__RecordTypeName__c ='Inventor');
        insert inventor;
        
       // SymphonyIPM__Inventor__c objInventor = [SELECT Name,SymphonyIPM__User__c,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Email__c='xyz@gmail.com' LIMIT 1];
        List<ID> ids=new List<ID>();
        ids.add(inventor.id);
        objOptions=PrimaryContactController.searchInventors('Harsh1',ids);
        PrimaryContactController.othersearchInventors('Harsh1',ids);
        System.debug( objOptions);
        //System.assertEquals('Harsh (efg@gmail.com)',objOptions.get(0).label); On 06/03/2020
        //System.debug( objOptions);
        objOptions=PrimaryContactController.searchInventors('dan',ids);
        //System.debug( objOptions);
        //System.assertEquals('dan (abc@gmail.com)',objOptions.get(0).label); on 06/03/2020
        objOptions=PrimaryContactController.searchInventors('dan1',ids);
        //System.debug( objOptions);
        //System.assertEquals('dan1',objOptions.get(0).label); // On 06/03/2020
        //InventorController.searchInventors(null,null);
        
    }
    
    static TestMethod Void Test_getSelectedInventors() 
    {
        Test.startTest();
        //User u = [SELECT Id FROM User WHERE CompanyName ='TEST1' LIMIT 1];
        //string uId = string.valueOf(u.Id);
        List<wrapperPillNew> objPills = new List<wrapperPillNew>();
        SymphonyIPM__Inventor__c objInventor = [SELECT Name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Email__c='xyz@gmail.com' LIMIT 1];
        //SymphonyIPM__Inventor__c objInventor1 = [SELECT Name,SymphonyIPM__Email__c,SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c WHERE Name='dan' LIMIT 1];
        //SymphonyIPM__Inventor__c objInventor2 = [SELECT Name,SymphonyIPM__Email__c,SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c WHERE Name='dan1' LIMIT 1];
        List<ID> ids=new List<ID>();
        ids.add(objInventor.Id);
        //ids.add(objInventor1.Id);
        //ids.add(objInventor2.Id);
        objPills=PrimaryContactController.getSelectedInventors(ids);
        PrimaryContactController.othergetSelectedInventors(ids);
        PrimaryContactController.getManagingSegment('SymphonyIPM__Invention_Disclosure_New__c','Other_Segment__c');
        Test.stopTest();     
        //system.assertEquals('dan', objInventor1.Name);
        
    }
    static TestMethod Void Test_populateMentor() 
    {
        SymphonyIPM__Inventor__c objInventor = [SELECT Name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Email__c='xyz@gmail.com' LIMIT 1];
        SymphonyIPM__Hierarchy__c path = new SymphonyIPM__Hierarchy__c();
        path.name = 'Test Path123';
        INSERT path;    
        SymphonyIPM__Invention_Disclosure_New__c dis= new SymphonyIPM__Invention_Disclosure_New__c();
        dis.SymphonyIPM__Title__c ='test record';
        dis.MentorsIDs__c = objInventor.Id;
        dis.SymphonyIPM__Hierarchy__c = path.id;
         insert dis;
        
        List<wrapperPillNew> objPillss = new List<wrapperPillNew>();
         List<wrapperPillNew> objPillss1 = new List<wrapperPillNew>();
        String ment=dis.id;
       // ment.add(dis.MentorsIDs__c);
        
        objPillss=PrimaryContactController.populateAdditionalInventors(ment);   
        objPillss1=PrimaryContactController.otherpopulateAdditionalInventors(ment);
        PrimaryContactController.getpaths(dis.id);
        PrimaryContactController.getpaths('false');
        PrimaryContactController.getstage('SymphonyIPM__Invention_Disclosure_New__c', 'Current_Stage_of_Invention__c');
        PrimaryContactController.getValues(ment);
    }
    static TestMethod Void Test_fetchInventor() 
    {
	 SymphonyIPM__Inventor__c inventor1=new SymphonyIPM__Inventor__c(Name='Harsh1',SymphonyIPM__Email__c='xyz@gmail.com',SymphonyIPM__RecordTypeName__c ='Inventor');
        insert inventor1;
        string inv = inventor1.id;
    
       PrimaryContactController.fetchInventor(inv);
        
    }
    static TestMethod Void Test_fetchUser() 
    {
        
       User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Inventor'].Id,
            LastName = 'last',
            Email ='abc@gmail.com',
            Username ='puser0067@amamama@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
            insert u;
        SymphonyIPM__Inventor__c inventor1=new SymphonyIPM__Inventor__c(Name='Harsh1',SymphonyIPM__Email__c='xyz@gmail.com',SymphonyIPM__User__c=u.id,SymphonyIPM__RecordTypeName__c ='Inventor');
       insert inventor1;
       PrimaryContactController.fetchUser();
    }

}