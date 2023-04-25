trigger AssetInventorTrigger on SymphonyIPM__Asset_Inventor_v1__c (before insert, after insert, after update) {

    if (Trigger.isBefore) {
        Set<Id> patentIds = new Set<Id>();
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
        for (SymphonyIPM__Asset_Inventor_v1__c inventor : Trigger.new) {
            patentIds.add(inventor.SymphonyIPM__Asset__c);
        }

        Set<Id> idfIds = new Set<Id>();
        for (SymphonyIPM__Patent__c patent: [SELECT Id, SymphonyIPM__Base_Invention_Disclosure_New__c FROM SymphonyIPM__Patent__c WHERE Id IN :patentIds AND SymphonyIPM__Base_Invention_Disclosure_New__c != NULL]) {
            idfIds.add(patent.SymphonyIPM__Base_Invention_Disclosure_New__c);
        }

        Map<Id, Boolean> personExternalMap = new Map<Id, Boolean>();
        for (SymphonyIPM__Additional_Inventor__c inventor : [SELECT Id, SymphonyIPM__Inventor__c, Is_External_Inventor_New__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Invention_Disclosure_New__c IN :idfIds]) {
            personExternalMap.put(inventor.SymphonyIPM__Inventor__c, inventor.Is_External_Inventor_New__c);
        }

        for (SymphonyIPM__Asset_Inventor_v1__c inventor : Trigger.new) {
            inventor.Is_External_Inventor__c = personExternalMap.containsKey(inventor.SymphonyIPM__Inventor__c) && personExternalMap.get(inventor.SymphonyIPM__Inventor__c);
        }
    } else {
        Map<Id, SymphonyIPM__Asset_Inventor_v1__c> idInventorsMap = new Map<Id, SymphonyIPM__Asset_Inventor_v1__c>([SELECT Id, SymphonyIPM__Inventor__c, SymphonyIPM__Asset__c FROM SymphonyIPM__Asset_Inventor_v1__c WHERE Id IN :Trigger.newMap.keySet()]);
        Map<Id, SymphonyIPM__Asset_Inventor_v1__c> inventorsChecked = new Map<Id,SymphonyIPM__Asset_Inventor_v1__c>();
        Set<Id> patentIdsUnchecked = new Set<Id>();
        for (SymphonyIPM__Asset_Inventor_v1__c idInventor : Trigger.new) {
            if (idInventor.SymphonyIPM__Primary_Inventor__c && (Trigger.isInsert || !Trigger.oldMap.get(idInventor.Id).SymphonyIPM__Primary_Inventor__c)) {
                inventorsChecked.put(idInventorsMap.get(idInventor.Id).SymphonyIPM__Asset__c, idInventorsMap.get(idInventor.Id));
            } else if (!idInventor.SymphonyIPM__Primary_Inventor__c && Trigger.isUpdate && Trigger.oldMap.get(idInventor.Id).SymphonyIPM__Primary_Inventor__c) {
                patentIdsUnchecked.add(idInventorsMap.get(idInventor.Id).SymphonyIPM__Asset__c);
            }
        }
        List<SymphonyIPM__Patent__c> patentsToUpdateUnchecked = [SELECT Id FROM SymphonyIPM__Patent__c WHERE Id IN :patentIdsUnchecked];
        for (SymphonyIPM__Patent__c idf: patentsToUpdateUnchecked) {
            idf.SymphonyIPM__Primary_Inventor__c = null;
        }
        if (!patentsToUpdateUnchecked.isEmpty()) {
            update patentsToUpdateUnchecked;
        }

        List<SymphonyIPM__Patent__c> patentsToUpdateChecked = [SELECT Id FROM SymphonyIPM__Patent__c WHERE Id IN :inventorsChecked.keySet()];
        for (SymphonyIPM__Patent__c patent: patentsToUpdateChecked) {
            patent.SymphonyIPM__Primary_Inventor__c = inventorsChecked.get(patent.Id).SymphonyIPM__Inventor__c;
        }

        if (!patentsToUpdateChecked.isEmpty()) {
            update patentsToUpdateChecked;
        }
    }
}