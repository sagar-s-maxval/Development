trigger SDJobsTrigger on SDOC__SDJob__c (after insert, after update) {

    Integer i = 0;
    i++;
    /*Set<Id> jobIds = new Set<Id>();
    for(SDOC__SDJob__c job: Trigger.new){
        if(job.SDOC__Status__c == 'Completed'){
            jobIds.add(job.Id);
        }
    }
    
    if(jobIds != null && jobIds.size() > 0){
        for(SDOC__SDoc__c sDoc: [SELECT Id, CreatedDate, SDOC__File_ID__c, SDOC__SDJob__c, SDOC__SDJob__r.RelatedObjectId_c__c FROM SDOC__SDoc__c WHERE SDOC__SDJob__c IN:jobIds AND SDOC__File_ID__c <> null AND SDOC__SDJob__r.RelatedObjectId_c__c <> null]){
            List<Id> fileIds = new List<Id>();
            fileIds.add(sDoc.SDOC__File_ID__c);

            DocuSignSDocsServiceCtrl.submitDocumentForSignatureAPI(Trigger.newMap.get(sDoc.SDOC__SDJob__c), fileIds);
        }
    }*/
}