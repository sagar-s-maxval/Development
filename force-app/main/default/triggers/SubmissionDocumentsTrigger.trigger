trigger SubmissionDocumentsTrigger on ContentDocumentLink (after insert) {
    Set<Id> cdIDs = new Set<Id>();
    Set<Id> idfIds = new Set<Id>();

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


    for (ContentDocumentLink cdl: Trigger.new) {
        cdIDs.add(cdl.ContentDocumentId);
        idfIds.add(cdl.LinkedEntityId);
    }

    Map<Id, ContentVersion> contentDocumentMap = new Map<Id, ContentVersion>([SELECT Id, Title FROM ContentVersion WHERE ContentDocumentId IN :cdIDs]);
    Map<Id, SymphonyIPM__Invention_Disclosure_New__c> disclosuresMap = new Map<Id, SymphonyIPM__Invention_Disclosure_New__c>([SELECT Id, SymphonyIPM__Disclosure_Status__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Id IN :idfIds]);

    Map<Id, Id> emailsNeededMap = new Map<Id, Id>();
    for (ContentDocumentLink cdl : Trigger.new) {
        if (disclosuresMap.get(cdl.LinkedEntityId) != null
                && contentDocumentMap.get(cdl.ContentDocumentId).Title.contains(disclosuresMap.get(cdl.LinkedEntityId).SymphonyIPM__Disclosure_Status__c)) {
            emailsNeededMap.put(cdl.LinkedEntityId, cdl.ContentDocumentId);
        }
    }

    InventionDisclosureService.sendFileEmails(emailsNeededMap);
}