@istest(seealldata=true)
public class SendsummaryemailcntrlTest {
    
    @istest
    public static void testmethod1(){
        test.startTest();
      list<SymphonyIPM__PRC_Meeting__c> sslis=[SELECT Id From SymphonyIPM__PRC_Meeting__c Order by createddate DESC limit 5];
        for(SymphonyIPM__PRC_Meeting__c ss:sslis){
            string res=sendsummaryemialcntrl.sendemail(string.valueOf(ss.id));}
        PRBreviewompleteemailcntrl.codecalcualtion();
        test.stopTest();
    }

}