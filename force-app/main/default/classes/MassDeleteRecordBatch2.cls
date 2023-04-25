/**
 * Created by YLagun on 04/11/2022.
 */

global with sharing class MassDeleteRecordBatch2 implements Database.Batchable<SObject> {

    String query;

    global MassDeleteRecordBatch2(String q){
        query=q;
    }

    public Database.QueryLocator start(Database.BatchableContext param1) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext param1, List<SObject> docsToDelete) {
        Database.delete(docsToDelete, false);
    }

    public void finish(Database.BatchableContext param1) {
    }

}