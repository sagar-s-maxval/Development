@IsTest
public class PatentTriggerTest {

  @IsTest
    static void test1() {
        SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name = 'test', SymphonyIPM__FirstName__c = 'test', SymphonyIPM__LastName__c = 'testLastName', SymphonyIPM__Email__c = 'abc@ex.com', Is_External_Person__c = true, External_Comments__c = 'never gonna give you up');
        insert inventor;
        SymphonyIPM__Entity__c Entity = new SymphonyIPM__Entity__c();
        insert Entity;

        SymphonyIPM__Patent__c patent = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'TestPatent', SymphonyIPM__Docket_No__c = 'TP100029DEEPV2',SymphonyIPM__Case_Type__c='Provisional', SymphonyIPM__Status__c = 'Pending');
        insert patent;
        Patent_Assignee__c patassign = new Patent_Assignee__c(Patent__c=patent.id,Entity__c=Entity.id);
        insert patassign;
      
        
        SymphonyIPM__Asset_Inventor_v1__c assetInventor = new SymphonyIPM__Asset_Inventor_v1__c(Name = 'Test', SymphonyIPM__Asset__c = patent.Id, SymphonyIPM__Inventor__c = inventor.Id);
        insert assetInventor;
        
         SymphonyIPM__Patent__c patent2 = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'TestPatent 1', SymphonyIPM__Docket_No__c = 'TP100029DEEPr2',SymphonyIPM__Case_Type__c='Utility Non-Provisional',SymphonyIPM__ClonedFromAsset__c=patent.id,SymphonyIPM__Root_Patent__c=patent.id, SymphonyIPM__Issue_Date_of_Patent__c = null);
        insert patent2;
        patent2.SymphonyIPM__Country_Code__c='CN';
        patent2.SymphonyIPM__Asset_Type__c='Design';
        update patent2;
    }
    @TestSetup
  static void setup() 
  {
      PatentService.magicMethod();
  }

}