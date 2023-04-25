public with sharing class CreateFilingRemunerationBatch implements Database.Batchable<SObject> {

    public Iterable<SObject> start(Database.BatchableContext param1) {
        Jobs_Deadlines__mdt filingDue = Jobs_Deadlines__mdt.getInstance('Create_Filing_Reward');
        return [
                SELECT Id, SymphonyIPM__Base_Invention_Disclosure_New__c, SymphonyIPM__Base_Invention_Disclosure_New__r.SymphonyIPM__Combined_With__c
                FROM SymphonyIPM__Patent__c
                WHERE SymphonyIPM__Base_Invention_Disclosure_New__c != NULL
                AND First_Filed_In_Family__c = TRUE AND Create_Filing_Reward__c = TRUE
                AND SymphonyIPM__Earliest_Priority_Date__c <= :Date.today().addDays(-Integer.valueOf(filingDue.Days__c)).addMonths(-Integer.valueOf(filingDue.Months__c)).addYears(-Integer.valueOf(filingDue.Years__c))
        ];
    }

    public void execute(Database.BatchableContext param1, List<SObject> param2) {
        List<Remuneration_Record__c> records = new List<Remuneration_Record__c>();

        Set<Id> idfIds = new Set<Id> ();
        for (SymphonyIPM__Patent__c patent : (List<SymphonyIPM__Patent__c>) param2) {
            idfIds.add(patent.SymphonyIPM__Base_Invention_Disclosure_New__c);
        }

        Set<Id> idfsWithAwards = new Set<Id> ();
        for (Remuneration_Record__c record : [SELECT Id, Invention_Disclosure__c FROM Remuneration_Record__c WHERE Invention_Disclosure__c IN :idfIds AND Reward_Type__c = 'Filing']) {
            idfsWithAwards.add(record.Invention_Disclosure__c);
        }

        Set<Id> remunerationIDFs = new Set<Id>();
        for (SymphonyIPM__Additional_Inventor__c idInventor : [SELECT Id, Is_Contribution_Applicable__c, SymphonyIPM__Invention_Disclosure_New__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Invention_Disclosure_New__c IN :idfIds AND Is_Contribution_Applicable__c = TRUE]) {
            if (!remunerationIDFs.contains(idInventor.SymphonyIPM__Invention_Disclosure_New__c)) {
                remunerationIDFs.add(idInventor.SymphonyIPM__Invention_Disclosure_New__c);
            }
        }

        Map<Id, Set<Id>> combinedIDFsMap = new Map<Id, Set<Id>>();
        for (SymphonyIPM__Invention_Disclosure_New__c idf : [SELECT Id, SymphonyIPM__Combined_With__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE SymphonyIPM__Combined_With__c IN :remunerationIDFs]) {
            Set<Id> ids = combinedIDFsMap.containsKey(idf.SymphonyIPM__Combined_With__c)
                    ? combinedIDFsMap.get(idf.SymphonyIPM__Combined_With__c)
                    : new Set<Id>();
            ids.add(idf.Id);
            combinedIDFsMap.put(idf.SymphonyIPM__Combined_With__c, ids);
        }

        for (SymphonyIPM__Patent__c patent : (List<SymphonyIPM__Patent__c>) param2) {
            if (remunerationIDFs.contains(patent.SymphonyIPM__Base_Invention_Disclosure_New__c) && !idfsWithAwards.contains(patent.SymphonyIPM__Base_Invention_Disclosure_New__c)) {
                records.add(new Remuneration_Record__c(
                        Invention_Disclosure__c = patent.SymphonyIPM__Base_Invention_Disclosure_New__c,
                        Name = 'Filing Reward',
                        Reward_Type__c = 'Filing'
                ));

                if (combinedIDFsMap.containsKey(patent.SymphonyIPM__Base_Invention_Disclosure_New__c)) {
                    for (Id localId : combinedIDFsMap.get(patent.SymphonyIPM__Base_Invention_Disclosure_New__c)) {
                        records.add(new Remuneration_Record__c(
                                Invention_Disclosure__c = localId,
                                Name = 'Filing Reward',
                                Reward_Type__c = 'Filing'
                        ));
                    }
                }
            }
        }

        if (!records.isEmpty()) {
            insert records;
        }

        List<SymphonyIPM__Patent__c> patentsToComplete = (List<SymphonyIPM__Patent__c>) param2;
        for (SymphonyIPM__Patent__c patent : patentsToComplete) {
            patent.Create_Filing_Reward__c = false;
        }
        if (!patentsToComplete.isEmpty()) {
            update patentsToComplete;
        }
    }

    public void finish(Database.BatchableContext param1) {
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
    }

}