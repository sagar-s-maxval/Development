@isTest
public class IDFControllerTest {

    
     static testMethod void IDFControllerTest()
     {
         SymphonyIPM__Hierarchy__c path = new SymphonyIPM__Hierarchy__c();
         path.name = 'Test';
         insert path;
         
         list<SymphonyIPM__Hierarchy__c> lstpath = new list<SymphonyIPM__Hierarchy__c>();
         lstpath.add(path);
         
         IDFController.getpaths();
          
     }
    static testMethod void IDFgetinv()
     {
         SymphonyIPM__Inventor__c inv = new SymphonyIPM__Inventor__c();
         inv.name = 'Test';
         inv.Nick_Name__c = 'nicky';
         inv.First_Name__c = 'hey';
         inv.Last_Name__c = 'sai';
         
         insert inv;
         
         list<SymphonyIPM__Inventor__c> lstinv = new list<SymphonyIPM__Inventor__c>();
         lstinv.add(inv);
         
         IDFController.getinventors();
          
     }
    static testMethod void IDFgetstage()
     {
       SymphonyIPM__Invention_Disclosure_New__c dis = new SymphonyIPM__Invention_Disclosure_New__c();
         dis.Current_Stage_of_Invention__c='Test';
       //  insert dis;
         list<string> stage = new list<string>();
         stage.add(dis.Current_Stage_of_Invention__c);
         IDFController.getstage('SymphonyIPM__Invention_Disclosure_New__c','Test');
         
     }
    static testMethod void IDFgetManagingSegment()
     {
       SymphonyIPM__Invention_Disclosure_New__c dis = new SymphonyIPM__Invention_Disclosure_New__c();
         dis.Current_Stage_of_Invention__c='Test';
    list<string> Managingsegment = new list<string>();
         Managingsegment.add(dis.Managing_Segment_New__c);
         IDFController.getBusinessSegment('SymphonyIPM__Invention_Disclosure_New__c','Test');
         
     }
}