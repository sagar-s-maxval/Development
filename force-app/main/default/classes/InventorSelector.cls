public with sharing class InventorSelector {
    public static List<SymphonyIPM__Inventor__c> getInventorsByIds(List<Id> ids) {
        return [
                SELECT Id, Name, SymphonyIPM__Email__c, SymphonyIPM__Employment_status__c
                FROM SymphonyIPM__Inventor__c
                WHERE Id IN :ids
        ];
    }
}