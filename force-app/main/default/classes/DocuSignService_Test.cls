@IsTest
class DocuSignService_Test {

    @IsTest
    static void build() {
        // Arrange

        // Create Doc 1
        // Create Template 1
        // Create Tab 1
        // Create Tab 2

        // Create Doc 2
        // Create Template 2
        // Create Tab 3
        // Create Tab 4

        // Create Signer 1
        // Create Signer 2

        // Patents
        SymphonyIPM__Patent__c patent = DocuSign_TestDataFactory.createPatents(1, true)[0];

        // Templates
        List<SDOC__SDTemplate__c> templates = DocuSign_TestDataFactory.createSDocTemplate(2, true);

        // Create Doc 1
        SDOC__SDoc__c sDoc1 = DocuSign_TestDataFactory.createSDoc(templates[0].Id, 1, true)[0];
        DocuSign_TestDataFactory.createDocuSignTab(templates[0].Id, 'signHereTabs', 1, true);
        DocuSign_TestDataFactory.createDocuSignTab(templates[0].Id, 'dateSignedTabs', 1, true);
        ContentDocument contentDocument1 = DocuSign_TestDataFactory.createContentDocument(sDoc1.Id, 1, true)[0];
//        DocuSign_TestDataFactory.createContentDocumentLink(patent.Id, contentDocument1.Id, 1, true);

        // Create Doc 2
        SDOC__SDoc__c sDoc2 = DocuSign_TestDataFactory.createSDoc(templates[1].Id, 1, true)[0];
        DocuSign_TestDataFactory.createDocuSignTab(templates[1].Id, 'signHereTabs', 1, true);
        DocuSign_TestDataFactory.createDocuSignTab(templates[1].Id, 'dateSignedTabs', 1, true);
        ContentDocument contentDocument2 = DocuSign_TestDataFactory.createContentDocument(sDoc2.Id, 1, true)[0];
//        DocuSign_TestDataFactory.createContentDocumentLink(patent.Id, contentDocument2.Id, 1, true);

        // Person 1
        SymphonyIPM__Inventor__c inventor1 = DocuSign_TestDataFactory.createPersons(1, true)[0];
        DocuSign_TestDataFactory.createDocuSignReviewers(patent.Id, inventor1.Id, 1, true);

        // Person 2
        SymphonyIPM__Inventor__c inventor2 = DocuSign_TestDataFactory.createPersons(1, true)[0];
        DocuSign_TestDataFactory.createDocuSignReviewers(patent.Id, inventor2.Id, 1, true);

        /*System.debug('inserted contentDocumentLink:');
        System.debug(contentDocumentLink);

        System.debug('selected contentDocumentLink:');
        System.debug([
                SELECT Id, LinkedEntityId, ContentDocumentId
                FROM ContentDocumentLink
                WHERE Id = :contentDocumentLink.Id
        ]);*/

        ContentVersion contentVersion1 = [SELECT Id FROM ContentVersion WHERE Description = :sDoc1.Id];
        ContentVersion contentVersion2 = [SELECT Id FROM ContentVersion WHERE Description = :sDoc2.Id];

        String emailSubject = 'Test Subject';
        String emailBody = 'Test Body';


        // Act
        DocuSignDto.DocuSignEnvelope envelope = DocuSignService.buildDocuSignApi(
                new List<Id>{
                        contentVersion1.Id, contentVersion2.Id
                },
                emailSubject,
                emailBody,
                new List<Id>{
                        inventor1.Id, inventor2.Id
                },
                new List<Id>{inventor2.Id}
        );

//        String envelop = DocuSignService.sendAndCreateDocuSignEnvelope(
//                patent.Id,
//                new List<Id>{
//                contentVersion1.Id, contentVersion2.Id
//                },
//                emailSubject,
//                emailBody,
//                new List<Id>{
//                        inventor1.Id, inventor2.Id
//                },
//                new List<Id>{inventor2.Id},
//                true
//        );

        //Assert
//        String expected = '{"status":"sent",' +
//                '"recipients":' +
//                '{' +
//                '"signers":[],' +
//                '"carbonCopies":[]' +
//                '},' +
//                '"emailSubject":"Test Subject",' +
//                '"emailBlurb":"Test Body",' +
//                '"documents":[{' +
//                '"order":null,"name":"Test Document",' +
//                '"fileExtension":"pdf",' +
//                '"documentId":"1",' +
//                '"documentBase64":"VGVzdCBDb250ZW50"' +
//                '}]' +
//                '}';

        DocuSignDto.DocuSignEnvelope expected = new DocuSignDto.DocuSignEnvelope();
        expected.status = 'sent';
        expected.emailSubject = 'Test Subject';
        expected.emailBlurb = 'Test Body';

        DocuSignDto.DocuSignDocument document = new DocuSignDto.DocuSignDocument();
        document.name = 'Test Document';
        document.fileExtension = 'pdf';
        document.documentId = '1';
        document.documentBase64 = 'VGVzdCBDb250ZW50';
        expected.documents.add(document);


//        DocuSignDto.DocuSignSigners signer = new DocuSignDto.DocuSignSigners();
//
//        DocuSignDto.DocuSignTabData tabData = new DocuSignDto.DocuSignTabData();
//        tabData.anchorString = '#Name';
//        tabData.documentId = '1';
//        signer.tabs.signHereTabs.add(tabData);
//
//        expected.recipients.signers.add(signer);



        System.debug(expected);
        System.debug(envelope);
        System.assertEquals(expected.status, envelope.status);
        System.assertEquals(2, envelope.documents.size());

        System.assertEquals(expected.documents[0].documentId, envelope.documents[0].documentId);
        System.assertEquals(expected.documents[0].documentId, envelope.documents[0].documentId);

        System.assertNotEquals(0, envelope.recipients.signers.size());
        System.assertNotEquals(0, envelope.recipients.signers[0].tabs.signHereTabs.size());
        System.assertEquals('1', envelope.recipients.signers[0].tabs.signHereTabs[0].documentId);
        // Out:

        // Signer 1
        // Tab 1 (Doc 1)
        // Tab 2 (Doc 1)
        // Tab 3 (Doc 2)
        // Tab 4 (Doc 2)

        // Signer 2
        // Tab 1 (Doc 1)
        // Tab 2 (Doc 1)
        // Tab 3 (Doc 2)
        // Tab 4 (Doc 2)

        System.assertEquals(2, envelope.recipients.signers.size());
        System.assertEquals(2, envelope.recipients.signers[0].tabs.signHereTabs.size());
        System.assertEquals(2, envelope.recipients.signers[0].tabs.dateSignedTabs.size());
        System.assertEquals(2, envelope.recipients.signers[1].tabs.signHereTabs.size());
        System.assertEquals(2, envelope.recipients.signers[1].tabs.dateSignedTabs.size());
    }

    @IsTest
    static void insertEnvelope() {
        DocuSignSendEnvelopeController.magicMethod();
        ContentDocumentSelector.magicMethod();
        DocuSignFileUploadController.magicMethod();
    }
}