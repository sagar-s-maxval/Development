public class DocuSignFileUploadController {
    @AuraEnabled
    public static void saveFile(String fileName, Id recordId, Id contentVersionId){
        SDOC__SDoc__c sDoc = new SDOC__SDoc__c();
        sDoc.SDOC__Attachment_Name__c = fileName;
        sDoc.SDOC__ObjectID18__c = recordId;
        sDoc.Related_Patent_Or_ID__c = recordId;
        insert sDoc;

        update new ContentVersion(Id = contentVersionId, Description = sDoc.Id);
        //This is required to delete attachments
        sDoc.SDOC__File_ID__c = contentVersionId;
        upsert sDoc;
    }
}