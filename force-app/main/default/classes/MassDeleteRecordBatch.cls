global with sharing class MassDeleteRecordBatch implements Database.Batchable<SObject> {

    String query;

    global MassDeleteRecordBatch(String q){
        query=q;
    }


    public Iterable<SObject> start(Database.BatchableContext param1) {
        return [
                SELECT Id
                FROM SymphonyIPM__AuditTrail__c
                WHERE CreatedDate < 2022-11-25T01:02:03Z AND CreatedDate > 2022-11-10T01:02:03Z
                LIMIT 50000
        ];

    }

    public void execute(Database.BatchableContext param1, List<SObject> docsToDelete) {

        List<SObject> sObjects = Database.query(query);
        Database.delete(sObjects, false);
    }

    public void finish(Database.BatchableContext param1) {
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
    }



}