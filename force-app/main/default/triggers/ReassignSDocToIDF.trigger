trigger ReassignSDocToIDF on ContentDocumentLink (before insert) {

    Set<Id> entitiesIds = new Set<Id>();
    for(ContentDocumentLink cdl : Trigger.new) {
        String sobjectType = cdl.LinkedEntityId.getSobjectType().getDescribe().getName();
        if (sobjectType == 'SymphonyIPM__Additional_Inventor__c') {
            entitiesIds.add(cdl.LinkedEntityId);
        }
    }
    Map<Id, SymphonyIPM__Additional_Inventor__c> inventorMap = new Map<Id, SymphonyIPM__Additional_Inventor__c>([SELECT Id, SymphonyIPM__Invention_Disclosure_New__c FROM SymphonyIPM__Additional_Inventor__c WHERE Id IN :entitiesIds ]);
    for (ContentDocumentLink cdl : Trigger.new) {
        if (inventorMap.containsKey(cdl.LinkedEntityId)) {
            cdl.LinkedEntityId = inventorMap.get(cdl.LinkedEntityId).SymphonyIPM__Invention_Disclosure_New__c;
        }
    }
}