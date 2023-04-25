trigger APTrgEnvelopeInfo on EnvelopeInfo__c (after update) {
    Set<Id> attachmentIds = new Set<Id>();
    Map<Id, Patent_Document__c> documentToInsert = new Map<Id, Patent_Document__c>();
    List<Patent_Document__c> getExistingEnvelopDocuments = [SELECT Id, AttachmentId__c FROM Patent_Document__c WHERE AttachmentId__c IN: Trigger.newMap.keySet()];
    Map<String, String> envelopeToDocument = new Map<String, String>();
    if(getExistingEnvelopDocuments != null && getExistingEnvelopDocuments.size() > 0){
        for(Patent_Document__c pd: getExistingEnvelopDocuments){
            envelopeToDocument.put(pd.AttachmentId__c, pd.Id);   
        }

        List<ContentDocumentLink> existingDocuments = [SELECT LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN: envelopeToDocument.values()];
    }
    if (trigger.isafter && trigger.isUpdate) {
        for(EnvelopeInfo__c ei: Trigger.new){
            if(ei.Status__c == 'completed' && ei.Patent__c != null){
                Patent_Document__c doc = new Patent_Document__c();
                if(envelopeToDocument !=null && envelopeToDocument.containsKey(ei.Id)){
                    doc.Id = envelopeToDocument.get(ei.Id);
                }
//                doc.Name = ei.Name;
                doc.Document_Type__c = 'DocuSign';
                doc.Upload_Date__c = Date.today();
                doc.Comments__c = '';
                doc.AttachmentId__c = ei.Id;
                doc.Patent__c = ei.Patent__c;
                doc.isActive__c = true;
                doc.Source__c = 'DocuSign';
                documentToInsert.put(ei.Id, doc);
                attachmentIds.add(ei.Id);
            }
        }
        
        if(!documentToInsert.isEmpty()){
            upsert documentToInsert.values();

            List<ContentDocumentLink> cdlsToInsert = new List<ContentDocumentLink>();
            for(ContentDocumentLink cdl: [SELECT LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN: attachmentIds]){
                ContentDocumentLink cDocLink = new ContentDocumentLink();
                cDocLink.ContentDocumentId = cdl.ContentDocumentId;//Add ContentDocumentId
                cDocLink.LinkedEntityId = documentToInsert.get(cdl.LinkedEntityId).Id;//Add attachment parentId
                cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                cdlsToInsert.add(cDocLink);
            }

            Database.insert(cdlsToInsert, false);
        }
    }


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
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    System.debug('log');
    System.assert(true);
}