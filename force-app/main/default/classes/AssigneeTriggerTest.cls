@IsTest
public with sharing class AssigneeTriggerTest {

    @TestSetup
    public static void testSetup() {
        SymphonyIPM__Entity__c entity = new SymphonyIPM__Entity__c(Name='TEST ENTITY');
        insert entity;
        
        SymphonyIPM__Entity__c entity2 = new SymphonyIPM__Entity__c(Name='TEST ENTITY 2');
        insert entity2;
    }

    @IsTest
    public static void testOMAssignee() {
      /*  SymphonyIPM__Entity__c entity = [SELECT Id FROM SymphonyIPM__Entity__c LIMIT 1];

        Other_Matters__c om = new Other_Matters__c();
        insert om;

        Other_Matter_Assignee__c assignee = new Other_Matter_Assignee__c(Entity__c = entity.Id, Other_Matters__c = om.Id);
        insert assignee;

        System.assert(assignee.Id != null);*/
    }

    @IsTest
    public static void testPatentAssignee() {
        SymphonyIPM__Entity__c entity = [SELECT Id FROM SymphonyIPM__Entity__c where Name='TEST ENTITY'];
      SymphonyIPM__Entity__c entity2 = [SELECT Id FROM SymphonyIPM__Entity__c where Name='TEST ENTITY 2'];
        SymphonyIPM__Patent__c patent = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c='TEST');
        insert patent;

        Patent_Assignee__c assignee = new Patent_Assignee__c(Entity__c = entity.Id, Patent__c = patent.Id);
        insert assignee;
      //  assignee.Entity__c=entity2.id;
        update assignee;

        System.assert(assignee.Id != null);
    }

    @IsTest
    public static void testTrademarkAssignee() {
        SymphonyIPM__Entity__c entity = [SELECT Id FROM SymphonyIPM__Entity__c LIMIT 1];

        SymphonyIPM__Trademark_New__c trademark = new SymphonyIPM__Trademark_New__c();
        insert trademark;

        Trademark_Assignee__c assignee = new Trademark_Assignee__c(Entity__c = entity.Id, Trademark__c = trademark.Id);
        insert assignee;

        System.assert(assignee.Id != null);
    }
}