@isTest
public class IDFPDFGeneratorNewTest {
    
  public static testmethod void testMethod1()
    {
        IDFPDFGeneratorNew idfPDFGen = new IDFPDFGeneratorNew();
        
        String LstInventors = 'Inventor A';
        Date myDate = date.newinstance(2010,01,01);
                
        RecordType rTypeID = [SELECT Id FROM RecordType WHERE Name = 'Invention Information' LIMIT 1];
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User usr1 = new User(LastName = 'Test', FirstName='Symphony', Alias = 'stest', Email = 'symphonytest@xyz.com', Username = 'symphonytest@xyz.com',
                             ProfileId = pro.id, TimeZoneSidKey = 'GMT', LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US');        
        insert usr1;
        
       /* RecordType rTypeInventor = [SELECT Id FROM RecordType WHERE Name = 'Inventor' LIMIT 1];
        SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name = 'Inventor 1');
        insert inventor; */
         RecordType rTypeInventor = [SELECT Id FROM RecordType WHERE sObjectType = 'SymphonyIPM__Inventor__c' AND Name = 'Inventor'];
    SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name='JvrSana',SymphonyIPM__Email__c='fzzzz@gmail.com',RecordTypeId=rTypeInventor.id,SymphonyIPM__RecordTypeName__c ='Inventor');
       
        insert inventor;
        
       
        
        SymphonyIPM__IDF_Questions__c cSettings = new SymphonyIPM__IDF_Questions__c(Competing_Products_Solutions__c='',Current_Commercial_Use_Desc__c='',Current_Commercial_Use__c='',Current_stage_of_invention__c='',Description__c='',Detection__c='',Dont_Know__c='',External_Use_Desc__c='',
                                                          Future_Implementation_desc__c='',Future_Implementation__c='',Impossible_unless_3rd_party_admits__c='',
                                                          Mentor__c='',Name='Test IDF',Other_Description__c='',Other__c='',Primary_Contact__c='',Primary_Inventor__c='',Prior_Submissions__c='',
                                                          Public_Disclosures_Date__c='',Public_Disclosures__c='',Reading_product_literature_description__c='',Reading_product_literature__c='',
                                                          Reverse_engineering_desc__c='',Reverse_engineering_or_code__c='',SymphonyIPM__Add_Inventors__c='',SymphonyIPM__Email__c='',
                                                          SymphonyIPM__Export_Control__c='',SymphonyIPM__First_Use_Date__c='',SymphonyIPM__Invention_Country__c='',SymphonyIPM__Invention_Date__c='',
                                                          SymphonyIPM__Invention_Status__c='',SymphonyIPM__Invention_Title__c='',SymphonyIPM__made_or_used_this_Invention__c='',
                                                          SymphonyIPM__Namespace__c='SymphonyIPM__',SymphonyIPM__Open_Source__c='',SymphonyIPM__Question_1__c='',SymphonyIPM__Question_2__c='',SymphonyIPM__Question_3__c='',
                                                          SymphonyIPM__Question_4__c='',SymphonyIPM__Sale_Offer_Date__c='',SymphonyIPM__Select_a_Path__c='',SymphonyIPM__sold_or_offered_for_sale__c='',Testing_a_competitive_solution_desc__c='',Testing_a_competitive_solution__c='',Third_Party_Contributions_desc__c='',Third_Party_Contributions__c='');
        insert cSettings;
        
       /*  IDF_Mdt_Questions__mdt settings = [Select Invention_Title__c,Email__c,Invention_Date__c,Invention_Country__c,Question_1__c,Question_2__c,Question_3__c,Question_4__c,
                                          Namespace__c,made_or_used_this_Invention__c,First_Use_Date__c,sold_or_offered_for_sale__c,Sale_Offer_Date__c,Export_Control__c,
                                         Open_Source__c,Select_a_Path__c,Add_Inventors__c,Invention_Status__c from IDF_Mdt_Questions__mdt where Label='Invention Disclosure Questions'];
         */       
        SymphonyIPM__Invention_Disclosure_New__c inv = new SymphonyIPM__Invention_Disclosure_New__c(Name = 'TestInventionDisclosure', SymphonyIPM__Detailed_Description__c = 'Description', SymphonyIPM__Inventive_Features__c = 'Lorem Ipsum', SymphonyIPM__Invention_Advantages__c = 'Lorem Ipsum', 
                                                                          SymphonyIPM__Alternative_Implementations_New__c = 'Lorem Ipsum', SymphonyIPM__Made_or_Used_Date__c = myDate, SymphonyIPM__Sale_Date__c = myDate, recordtypeid = rTypeID.Id);
        insert inv;
        System.AssertEquals('TestInventionDisclosure',inv.Name);
        //system.assertEquals(expected, actual)
        System.debug('invName   '+inv.Name);
        
      //  Inventor__c invQuery = [SELECT Id, Name FROM Inventor__c LIMIT 1];
      //  Invention_Disclosure_New__c idQuery = [SELECT Id, Name FROM Invention_Disclosure_New__c LIMIT 1];
        
        SymphonyIPM__Additional_Inventor__c additionalInv = new SymphonyIPM__Additional_Inventor__c(SymphonyIPM__Invention_Disclosure_New__c = inv.Id, SymphonyIPM__Inventor__c = inventor.Id);
        insert additionalInv;
        
        System.runAs(usr1)
        {
            String pdfContent;
            Map<String, Schema.SObjectType> sobjectSchemaMap = Schema.getGlobalDescribe();
            Schema.DescribeSObjectResult objDescribe = sobjectSchemaMap.get(cSettings.SymphonyIPM__Namespace__c+'Invention_Disclosure_New__c').getDescribe();
            Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            List<Id> idList = new List<Id>{inv.Id};
            
            IDFPDFGeneratorNew.generateIDFPDF(idList);
           // IDFPDFGenerator.attachPDF(inv,pdfContent);
        }
    }
    
    private static testmethod void testMethod2()
    {
        IDFPDFGeneratorNew idfPDFGen = new IDFPDFGeneratorNew();
        
        String LstInventors = 'Inventor A';
        Date myDate = date.newinstance(2010,01,01);
                
        RecordType rTypeID = [SELECT Id FROM RecordType WHERE Name = 'Invention Information' LIMIT 1];
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User usr1 = new User(LastName = 'Test', FirstName='Symphony', Alias = 'stest', Email = 'symphonytest@xyz.com', Username = 'symphonytest@xyz.com', ProfileId = pro.id, TimeZoneSidKey = 'GMT', 
                             LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US');        
        insert usr1;
        
       /* RecordType rTypeInventor = [SELECT Id FROM RecordType WHERE Name = 'Inventor' LIMIT 1];
        SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name = 'Inventor 1');
        insert inventor;*/
        
         RecordType rTypeInventor = [SELECT Id FROM RecordType WHERE sObjectType = 'SymphonyIPM__Inventor__c' AND Name = 'Inventor'];
   		 SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name='JvrSana',SymphonyIPM__Email__c='fzzzz@gmail.com',RecordTypeId=rTypeInventor.id,SymphonyIPM__RecordTypeName__c ='Inventor');
       
         insert inventor;
        SymphonyIPM__IDF_Questions__c cSettings = new SymphonyIPM__IDF_Questions__c(Name = 'Invention Disclosure Questions', SymphonyIPM__Add_Inventors__c = '', SymphonyIPM__Email__c = 'symphonytest@xyz.com', SymphonyIPM__Invention_Country__c = 'Invention Country', SymphonyIPM__Invention_Date__c = 'Invention Date', SymphonyIPM__Invention_Status__c = 'Disclosure Status',
                                                          SymphonyIPM__Invention_Title__c = 'Invention Title', SymphonyIPM__Namespace__c = 'SymphonyIPM__', SymphonyIPM__Question_1__c = 'Q1', SymphonyIPM__Question_2__c = 'Q2', SymphonyIPM__Question_3__c = 'Q3', SymphonyIPM__Question_4__c = 'Q4', SymphonyIPM__Sale_Offer_Date__c = 'Sale Date',
                                                          SymphonyIPM__Select_a_Path__c = 'Disclosure Path');
        insert cSettings;
        
         SymphonyIPM__Country__C con = New SymphonyIPM__Country__c();
        con.Name='India';
        con.SymphonyIPM__Country_Code__c='Ind';
        con.SymphonyIPM__Country_Id__c=34568;
        insert con;
        System.AssertEquals(con.Name,'India');
        
        SymphonyIPM__Invention_Disclosure_New__c inv = new SymphonyIPM__Invention_Disclosure_New__c(Name = 'TestInventionDisclosure', recordtypeid = rTypeID.Id,SymphonyIPM__Invention_Country__c=con.id);
        insert inv;
        System.AssertEquals(Inv.Name,'TestInventionDisclosure');
        //System.debug('invName   '+inv.Name);
        
        SymphonyIPM__Additional_Inventor__c additionalInv = new SymphonyIPM__Additional_Inventor__c(SymphonyIPM__Invention_Disclosure_New__c = inv.Id, SymphonyIPM__Inventor__c = inventor.Id);
        insert additionalInv;
        
        System.runAs(usr1)
        {
            String pdfContent;
            Map<String, Schema.SObjectType> sobjectSchemaMap = Schema.getGlobalDescribe();
            Schema.DescribeSObjectResult objDescribe = sobjectSchemaMap.get(cSettings.SymphonyIPM__Namespace__c+'Invention_Disclosure_New__c').getDescribe();
            Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            List<Id> idList = new List<Id>{inv.Id};
            
            IDFPDFGeneratorNew.generateIDFPDF(idList);
        }
    
}
}