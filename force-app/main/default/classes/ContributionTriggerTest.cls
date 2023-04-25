@IsTest
public with sharing class ContributionTriggerTest {

    @IsTest
    public static void testContribution() {
        SymphonyIPM__Invention_Disclosure_New__c idf = new SymphonyIPM__Invention_Disclosure_New__c(SymphonyIPM__Title__c='TEST');
        insert idf;

        Remuneration__c rem = new Remuneration__c(Invention_Disclosure__c = idf.Id);
        insert rem;

        System.assertEquals(1, [SELECT Id FROM Remuneration__c WHERE Invention_Disclosure__c = :idf.Id].size());
    }
}