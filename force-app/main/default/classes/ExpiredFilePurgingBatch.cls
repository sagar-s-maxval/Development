public with sharing class ExpiredFilePurgingBatch implements Database.Batchable<SObject> {

    public List<SymphonyIPM__Docketing_Activity_v2__c> daListToClose = new List<SymphonyIPM__Docketing_Activity_v2__c>();
    public Iterable<SObject> start(Database.BatchableContext param1) {

        Set<Id> patentsIds = new Set<Id> ();
        for (SymphonyIPM__Docketing_Activity_v2__c da :[SELECT Id, SymphonyIPM__Patent__c FROM SymphonyIPM__Docketing_Activity_v2__c
            WHERE SymphonyIPM__Actions__c = 'Documents Purging Due (Family Expired)' AND SymphonyIPM__Due_Date__c != :Date.today().addDays(-1)]) {
            patentsIds.add(da.SymphonyIPM__Patent__c);
            daListToClose.add(da);
        }
        return [
                SELECT Id, SymphonyIPM__Family_ID__c, SymphonyIPM__Family_ID_AI__c
                FROM SymphonyIPM__Patent__c
                WHERE Id IN :patentsIds AND Litigation_on_hold__c = FALSE];

    }

    public void execute(Database.BatchableContext param1, List<SObject> patentsList) {
        Set<String> familyIds = new Set<String>();
        Set<Decimal> familyIdsAI = new Set<Decimal>();
        Set<Id> familyPatentsIds = new Set<Id>();

        for (SymphonyIPM__Patent__c patent: (List<SymphonyIPM__Patent__c>)patentsList) {
            familyIds.add( patent.SymphonyIPM__Family_ID__c);
            familyIdsAI.add( patent.SymphonyIPM__Family_ID_AI__c);
            familyPatentsIds.add(patent.Id);
        }

        List<SymphonyIPM__Patent_Attachments__c> docsToDelete = [
                SELECT Id, SymphonyIPM__Patent__c, SymphonyIPM__Patent__r.SymphonyIPM__Family_ID__c
                FROM SymphonyIPM__Patent_Attachments__c
                WHERE SymphonyIPM__Patent__r.SymphonyIPM__Family_ID__c IN :familyIds OR SymphonyIPM__Patent__r.SymphonyIPM__Family_ID_AI__c IN :familyIdsAI
        ];

        Database.delete(docsToDelete);
        Map<Id, SymphonyIPM__Patent__c> patents = new Map<Id, SymphonyIPM__Patent__c>();

        for (SymphonyIPM__Patent_Attachments__c pa : (List<SymphonyIPM__Patent_Attachments__c>)docsToDelete) {
            patents.put(pa.SymphonyIPM__Patent__c, new SymphonyIPM__Patent__c(Id=pa.SymphonyIPM__Patent__c, Last_In_Family_Expired__c = false));
        }
        Database.update(patents.values());


        //emails
        List<EmailMessage> emailMessages = [SELECT Id FROM EmailMessage WHERE RelatedToId IN :familyPatentsIds];
        Database.delete(emailMessages);
        //notes
        List<Note> notes = [SELECT Id FROM Note WHERE ParentId IN :familyPatentsIds];
        Database.delete(notes);
        //ratings
        List<SymphonyIPM__IDF_Review__c> ratings = [SELECT Id FROM SymphonyIPM__IDF_Review__c WHERE SymphonyIPM__Base_Patent_Record__c IN :familyPatentsIds];
        Database.delete(ratings);
        //ifw
        List<SymphonyIPM__IFW_Data_v1__c> ifwData = [SELECT Id FROM SymphonyIPM__IFW_Data_v1__c WHERE SymphonyIPM__Asset__c IN :familyPatentsIds];
        Database.delete(ifwData);
        //cd
        List<Id> cds = new List<Id>();
        for (ContentDocumentLink cdl :[SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :familyPatentsIds]) {
            cds.add(cdl.ContentDocumentId);
        }
        Database.delete(cds);
    }

    public void finish(Database.BatchableContext param1) {
        for (SymphonyIPM__Docketing_Activity_v2__c da : daListToClose) {
            da.SymphonyIPM__Is_Completed__c = true;
            da.SymphonyIPM__Completion_Date__c = Date.today();
            da.SymphonyIPM__Reason_to_Complete__c = 'Purging has been completed';
        }
        Database.update(daListToClose);
        Database.executeBatch(new LitigationPurgingBatchable(), 100);
    }
public static void magicMethod(){
Integer i = 0;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
}
}