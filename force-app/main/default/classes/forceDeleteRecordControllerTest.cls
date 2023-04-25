@IsTest
public with sharing class forceDeleteRecordControllerTest {

    @IsTest
    public static void testDeletion() {
        insert new EmailMessage();

        forceDeleteRecordController.deleteEmailMessage([SELECT Id FROM EmailMessage].Id);

        System.assert([SELECT Id FROM EmailMessage].isEmpty());
    }

    @IsTest
    private static void testDeletion2() {

        insert new Account(Name = 'test');

        Id accountId = [SELECT Id FROM Account].Id;

        insert new EmailMessage(RelatedToId = accountId);

        Id emailId = [SELECT Id FROM EmailMessage].Id;
        Id relId = forceDeleteRecordController.getRelatedTo(emailId);

        System.assert(relId != null);
    }

}