@isTest
Public class MentorControllerTest 
{
    @testSetup static void DataSetup()
    {
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
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
        
        SymphonyIPM__Inventor__c inventor=new SymphonyIPM__Inventor__c(Name='Harsh',SymphonyIPM__Email__c='efg@gmail.com',SymphonyIPM__User__c=u.id,SymphonyIPM__RecordTypeName__c ='Inventor');
        insert inventor;
        
        SymphonyIPM__Inventor__c inventor1=new SymphonyIPM__Inventor__c(Name='Harsh1',SymphonyIPM__Email__c='xyz@gmail.com',SymphonyIPM__RecordTypeName__c ='Inventor');
        insert inventor1;
        SymphonyIPM__Inventor__c invent=new SymphonyIPM__Inventor__c(Name='dan',SymphonyIPM__Email__c='',SymphonyIPM__User__c=u.id,SymphonyIPM__RecordTypeName__c ='Inventor');
        insert invent;
        SymphonyIPM__Inventor__c invent1=new SymphonyIPM__Inventor__c(Name='dan1',SymphonyIPM__Email__c='',SymphonyIPM__RecordTypeName__c ='Inventor');
        insert invent1;
    }
    static TestMethod Void Test_searchInventors() 
    {
         User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
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
        
     //   Test.startTest();
       List<wrapperComboboxOption> objOptions = new List<wrapperComboboxOption>();
         SymphonyIPM__Inventor__c inv =new SymphonyIPM__Inventor__c(Name='Harsh',SymphonyIPM__Email__c='efg@gmail.com',SymphonyIPM__User__c=u.id,SymphonyIPM__RecordTypeName__c ='Inventor');
        insert inv;
      	
        list<SymphonyIPM__Inventor__c> lst = new list<SymphonyIPM__Inventor__c>();
        lst.add(inv);
              
        List<ID> ids=new List<ID>();
        ids.add(lst[0].id);
   //   list<SymphonyIPM__Inventor__c> lsts = [SELECT id,Name,SymphonyIPM__Email__c,SymphonyIPM__User__c,SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Email__c='xyz@gmail.com' LIMIT 1];
        objOptions=MentorController.searchInventors('efg@gmail.com',ids);
        System.debug( objOptions); 
       
       // MentorController.searchInventors('dan',ids);
        MentorController.searchInventors('dan1',ids);
       
    }
    
    static TestMethod Void Test_getSelectedInventors() 
    {
        Test.startTest();
        //User u = [SELECT Id FROM User WHERE CompanyName ='TEST1' LIMIT 1];
        //string uId = string.valueOf(u.Id);
        List<wrapperPillNew> objPills = new List<wrapperPillNew>();
        SymphonyIPM__Inventor__c objInventor = [SELECT Name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Email__c='efg@gmail.com' LIMIT 1];
        //SymphonyIPM__Inventor__c objInventor1 = [SELECT Name,SymphonyIPM__Email__c,SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c WHERE Name='dan' LIMIT 1];
        //SymphonyIPM__Inventor__c objInventor2 = [SELECT Name,SymphonyIPM__Email__c,SymphonyIPM__User__r.Email FROM SymphonyIPM__Inventor__c WHERE Name='dan1' LIMIT 1];
        List<ID> ids=new List<ID>();
        ids.add(objInventor.Id);
        //ids.add(objInventor1.Id);
        //ids.add(objInventor2.Id);
        objPills=MentorController.getSelectedInventors(ids);
        Test.stopTest();
        
        system.assertEquals('efg@gmail.com', objInventor.SymphonyIPM__Email__c);
    }
    static TestMethod Void Test_populateMentor() 
    {
        SymphonyIPM__Inventor__c objInventor = [SELECT Name,SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Email__c='efg@gmail.com' LIMIT 1];
             
        SymphonyIPM__Invention_Disclosure_New__c dis= new SymphonyIPM__Invention_Disclosure_New__c();
        dis.SymphonyIPM__Title__c ='test record';
        dis.MentorsIDs__c = objInventor.Id;
         insert dis;
        
        List<wrapperPillNew> objPillss = new List<wrapperPillNew>();
        String ment=dis.id;
       // ment.add(dis.MentorsIDs__c);
        
        objPillss=MentorController.populateMentor(ment);   
    }
    static TestMethod Void Test_fetchInventor() 
    {
	 SymphonyIPM__Inventor__c inventor1=new SymphonyIPM__Inventor__c(Name='Harsh1',SymphonyIPM__Email__c='xyz@gmail.com',SymphonyIPM__RecordTypeName__c ='Inventor');
        insert inventor1;
        string inv = inventor1.id;
    
       MentorController.fetchInventor(inv);
        
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
       list<SymphonyIPM__Inventor__c> lstinv = new list<SymphonyIPM__Inventor__c>();
        lstinv.add(inventor1);
        insert lstinv;
       MentorController.fetchUser();
     
    }
}