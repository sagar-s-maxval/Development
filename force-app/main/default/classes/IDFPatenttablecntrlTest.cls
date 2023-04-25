@IsTest
public class IDFPatenttablecntrlTest {
    
     @TestSetup
    public static void testSetup() {
         SymphonyIPM__Patent__c patent = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'test da',
                                                                    Name = 'test',SymphonyIPM__Family_ID__c='123');
             insert patent;
        SymphonyIPM__Invention_Disclosure_New__c idf = new SymphonyIPM__Invention_Disclosure_New__c(Name = 'Test', 
        SymphonyIPM__Title__c = 'Test',SymphonyIPM__Related_Patent__c=patent.id);
        insert idf;
    
    }
    @IsTest
    static void test1() {
        Test.startTest();
        SymphonyIPM__Patent__c pat= [select id from SymphonyIPM__Patent__c limit 1];
        IDFPatenttablecntrl.getidfinfo(pat.id);
        Test.stopTest();
    }
    

}