public with sharing class DocuSignService {

    public static String sendAndCreateDocuSignEnvelope(Id recordId, List<Id> contentVersionIds, String emailSubject, String emailBlurb, List<Id> recipientIds, List<Id> ccPersonsIds, Boolean isPatent) {

        DocuSignDto.DocuSignEnvelope envelope = buildDocuSignApi(contentVersionIds, emailSubject, emailBlurb, recipientIds, ccPersonsIds);
        String response = new DocuSignAPI().send('POST', 'envelopes', envelope.toString()).getBody();

        System.debug(envelope.toString());
        System.debug(response);

        DocumentDocuSignResponse objResponse = (DocumentDocuSignResponse) JSON.deserializeStrict(response, DocumentDocuSignResponse.class);

        if (objResponse.errorCode == null) {
            insert new DocuSignEnvelope__c(
                    Name = emailSubject,
                    EnvelopeId__c = objResponse.envelopeId.toUpperCase(),
                    Patent__c = isPatent ? recordId : null,
                    Invention_Disclosure__c = isPatent ? null : recordId,
                    Status__c = 'Sending');
            return objResponse.status;
        } else {
            throw new AuraHandledException(objResponse.message);
        }
    }

    public static DocuSignDto.DocuSignEnvelope buildDocuSignApi(List<Id> contentVersionIds, String emailSubject, String emailBlurb, List<Id> recipientIds, List<Id> ccPersonsIds) {
        List<ContentVersion> objContentVersions = ContentDocumentSelector.getContentVersionByDocumentIds(contentVersionIds);
        Map<Id, List<DocuSignTab__c>> templateToDocuSignTabMap = getTemplateToTabMap(contentVersionIds);
        Map<Id, SDOC__SDoc__c> sDocMap = getSDocMap(contentVersionIds);

        List<SymphonyIPM__Inventor__c> ccRecipients = InventorSelector.getInventorsByIds(ccPersonsIds);
        List<SymphonyIPM__Inventor__c> signerRecipients = InventorSelector.getInventorsByIds(recipientIds);

        // Envelope
        DocuSignDto.DocuSignEnvelope envelope = new DocuSignDto.DocuSignEnvelope();
        envelope.emailBlurb = emailBlurb;
        envelope.emailSubject = emailSubject;
        envelope.status = 'sent';

        // Documents
        Integer documentId = 1;
        for (ContentVersion contentVersion : objContentVersions) {
            DocuSignDto.DocuSignDocument document = new DocuSignDto.DocuSignDocument();
            document.documentId = String.valueOf(documentId++);
            document.documentBase64 = EncodingUtil.base64Encode(contentVersion.VersionData);
            document.name = contentVersion.Title;
            document.fileExtension = contentVersion.FileExtension;
            document.templateId = sDocMap.get(contentVersion.Description)?.SDOC__SDTemplate__c;
            envelope.documents.add(document);
        }

        // Recipients
        Integer recipientId = 1;
        // CC Person
        for (SymphonyIPM__Inventor__c inventor : ccRecipients) {

            DocuSignDto.DocuSignCarbonCopy carbonCopy = new DocuSignDto.DocuSignCarbonCopy();

            carbonCopy.name = inventor.Name;
            carbonCopy.email = inventor.SymphonyIPM__Email__c;
            carbonCopy.recipientId = String.valueOf(recipientId);
            carbonCopy.routingOrder = '1';
            envelope.recipients.carbonCopies.add(carbonCopy);
            recipientId++;
        }

//         Signer
        for (SymphonyIPM__Inventor__c inventor : signerRecipients) {

            DocuSignDto.DocuSignSigners signer = new DocuSignDto.DocuSignSigners();

            signer.name = inventor.Name;
            signer.email = inventor.SymphonyIPM__Email__c;
            signer.recipientId = String.valueOf(recipientId);
            signer.routingOrder = '1';

            for (DocuSignDto.DocuSignDocument document : envelope.documents) {

                List<DocuSignTab__c> docuSignTabs = templateToDocuSignTabMap.get(document.templateId);
                System.debug('document.templateId>>>>' + document.templateId);

                for (DocuSignTab__c tab : docuSignTabs) {
                    DocuSignDto.DocuSignTabData docuSignTabData = new DocuSignDto.DocuSignTabData();
                    docuSignTabData.anchorString = tab.AnchorString__c + inventor.Name;
                    docuSignTabData.anchorXOffset = String.valueOf(tab.XPosition__c);
                    docuSignTabData.anchorYOffset = String.valueOf(tab.YPosition__c);
                    docuSignTabData.anchorIgnoreIfNotPresent = String.valueOf(true);
                    docuSignTabData.tabLabel = tab.textTabsField__c;
                    docuSignTabData.anchorUnits = tab.anchorUnits__c;
                    docuSignTabData.recipientId = String.valueOf(recipientId);
                    docuSignTabData.documentId = String.valueOf(document.documentId);

                    switch on tab.Tabs__c {
                        when 'signHereTabs' {
                            signer.tabs.signHereTabs.add(docuSignTabData);
                        }
                        when 'dateSignedTabs' {
                            signer.tabs.dateSignedTabs.add(docuSignTabData);
                        }
                    }
                }
            }
            envelope.recipients.signers.add(signer);
            recipientId++;
        }
        return envelope;
    }

    private static Map<Id, SDOC__SDoc__c> getSDocMap(List<Id> contentVersionIds) {
        return new Map<Id, SDOC__SDoc__c>([SELECT Id, SDOC__SDTemplate__c FROM SDOC__SDoc__c WHERE SDOC__File_ID__c IN :contentVersionIds]);
    }

    private static Map<Id, List<DocuSignTab__c>> getTemplateToTabMap(List<Id> contentVersionIds) {
        Set<Id> templateIds = new Set<Id>();

        for (SDOC__SDoc__c sDoc : getSDocMap(contentVersionIds).values()) {
            templateIds.add(sDoc.SDOC__SDTemplate__c);
        }

        List<DocuSignTab__c> docuSignTabsByTemplateIds = DocuSignTabSelector.getDocuSignTabsBySDocTemplateId(templateIds);

        Map<Id, List<DocuSignTab__c>> templateToDocuSignTabMap = new Map<Id, List<DocuSignTab__c>>();

        for (DocuSignTab__c signTab : docuSignTabsByTemplateIds) {
            if (!templateToDocuSignTabMap.containsKey(signTab.SDoc_Template__c)) {
                templateToDocuSignTabMap.put(signTab.SDoc_Template__c, new List<DocuSignTab__c>());
            }
            if (signTab.SDoc_Template__c != null) {
                templateToDocuSignTabMap.get(signTab.SDoc_Template__c).add(signTab);
            }
        }
        return templateToDocuSignTabMap;
    }

    public static String resendEnvelope(String envelopeId) {
        String path = 'envelopes/' + envelopeId + '?resend_envelope=true';

        HttpResponse response = new DocuSignAPI().send('PUT', path, '{}');

        return response.getBody();
    }
}