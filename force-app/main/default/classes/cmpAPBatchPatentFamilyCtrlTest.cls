@isTest
public class cmpAPBatchPatentFamilyCtrlTest {
    @isTest public static void testing() {
        SymphonyIPM__Patent__c pat = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c='newpat',
                                                                SymphonyIPM__Application_Draft_Status__c ='Completed',
                                                               SymphonyIPM__Case_Type__c ='Defensive Publication',
                                                                SymphonyIPM__Application_Date__c=date.parse('1/24/2022'));
        insert pat;
        
        SymphonyIPM__Patent__c pat1 = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c='newpat',
                                                                SymphonyIPM__Application_Draft_Status__c ='Completed',
                                                               SymphonyIPM__Case_Type__c ='Defensive Publication',
                                                                SymphonyIPM__Application_Date__c=date.parse('1/24/2022'));
        insert pat1;
        
        SymphonyIPM__Patent__c pat2 = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c='newpat',
                                                                SymphonyIPM__Application_Draft_Status__c ='Completed',
                                                                SymphonyIPM__Case_Type__c ='Defensive Publication',
                                                                SymphonyIPM__Earliest_Priority_Date__c=date.parse('1/24/2022'));
        insert pat2;
        
        SymphonyIPM__Inventor__c inv = new SymphonyIPM__Inventor__c(SymphonyIPM__Is_Eligible_for_Inventor_Award__c =true,
                                                                    SymphonyIPM__EmploymentCategory__c='Company');
        insert inv;
        SymphonyIPM__Asset_Inventor_v1__c assinv = new SymphonyIPM__Asset_Inventor_v1__c(SymphonyIPM__Asset__c=pat.id,
                                                                                         SymphonyIPM__Inventor__c=inv.id);
        insert assinv;
        test.startTest();
        Id recordid = database.executeBatch(new cmpAPBatchPatentFamilyCtrl('3','Yes'));
        test.stopTest();
        
        
    }

}