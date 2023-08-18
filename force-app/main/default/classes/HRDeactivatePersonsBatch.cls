public with sharing class HRDeactivatePersonsBatch implements Database.Batchable<SObject>, Database.Stateful {
    public Set<String> dontDeactivate = new Set<String>();

    public HRDeactivatePersonsBatch(Set<String> ids) {
        dontDeactivate = ids;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('HRDeactivatePersonsBatch start ' + dontDeactivate.size() + ' ' + dontDeactivate);
        return Database.getQueryLocator(
        [
                SELECT Id, SymphonyIPM__RecordTypeName__c, SymphonyIPM__Law_Firm__c
                FROM SymphonyIPM__Inventor__c
                WHERE (SymphonyIPM__Employee_ID__c NOT IN :dontDeactivate AND Status__c != 'Deactivated')
        ]
        );
    }

    public void execute(Database.BatchableContext BC, List<SymphonyIPM__Inventor__c> persons) {
        List<SymphonyIPM__Inventor__c> updateThis = new List<SymphonyIPM__Inventor__c>();

        System.debug('HRDeactivatePersonsBatch updateThis ' + persons.size() + ' ' + persons);

        for (SymphonyIPM__Inventor__c person : persons) {
            if (!(person.SymphonyIPM__RecordTypeName__c == 'OC' && person.SymphonyIPM__Law_Firm__c != null)) {
                person.Status__c = 'Deactivated';
                
                
                // CR https://maxval.atlassian.net/browse/UCR-14
                // Changed on 17-Jul-2023 by AP
                person.Sync_Status__c = 'Deactivated';
                person.Last_Sync_Date__c=system.today();
                updateThis.add(person);
            }
        }

        System.debug('HRDeactivatePersonsBatch updateThis update done' + updateThis.size() + ' ' + updateThis);
        update updateThis;
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('HRDeactivatePersonsBatch finish');
    }
}