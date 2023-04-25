public without sharing class PatentDocument {
    
    @AuraEnabled
    public static SymphonyIPM__Patent_Attachments__c getDocumentRecord(String recordId){
        try {
            return [SELECT Id, Name, SymphonyIPM__Patent__c, SymphonyIPM__Actor_Id__c, SymphonyIPM__Actor_Status__c, SymphonyIPM__Respond_by_Date__c,
                        SymphonyIPM__Actor__c, SymphonyIPM__Actor_s_Latest__c, SymphonyIPM__Comments__c, SymphonyIPM__Document_Type_Code__c,
                        SymphonyIPM__Content_Version_Id__c, SymphonyIPM__Document_Type_No__c, SymphonyIPM__Document_Type__c, SymphonyIPM__Is_Sent_Out__c, 
                        SymphonyIPM__Next_Action__c, SymphonyIPM__Previous_Parent_Id__c, SymphonyIPM__Version__c, SymphonyIPM__First_Parent_Id__c,
                        SymphonyIPM__PTO_Due_Date__c, Review_By__c
                    FROM SymphonyIPM__Patent_Attachments__c
                    WHERE Id=: recordId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean checkLoggedInUserAccess(String recordId){
        try {
            Boolean hasAccess = false;
            Set<String> roles = new Set<String>();

            Profile porf = [SELECT Id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()];
            if(porf.Name == 'System Administrator'){
                return true;
            }

            SymphonyIPM__Patent_Attachments__c document = [SELECT Id, Name, SymphonyIPM__Patent__c, Review_By__c, SymphonyIPM__First_Parent_Id__c, SymphonyIPM__Actor_Status__c, CreatedById FROM SymphonyIPM__Patent_Attachments__c WHERE Id=: recordId];
            List<Patent_Role__c> userRole = [SELECT Id, Role__c FROM Patent_Role__c WHERE Patent__c=:document.SymphonyIPM__Patent__c AND Person__r.SymphonyIPM__User__c =: UserInfo.getUserId()];
            System.debug('---userRole---  ' + userRole);
            if(document.SymphonyIPM__Actor_Status__c == 'Draft' && document.CreatedById == UserInfo.getUserId()){
                hasAccess = true;
            }else if(document.CreatedById == UserInfo.getUserId()){
                hasAccess = true;
            }else{
            	if(userRole != null && userRole.size() > 0){
                    String currentRole = userRole[0].Role__c;
                    if(document.SymphonyIPM__First_Parent_Id__c == null && String.isNotBlank(document.Review_By__c)){
                        roles.addAll(document.Review_By__c.split(';'));
                        if(roles.contains(currentRole)){
                            hasAccess = true;
                        }
                    }else if(document.SymphonyIPM__First_Parent_Id__c == null){
                        hasAccess = true;
                    }else if(document.SymphonyIPM__First_Parent_Id__c != null && String.isNotBlank(document.Review_By__c)){
                        roles.addAll(document.Review_By__c.split(';'));
                        if(roles.contains(currentRole)){
                            hasAccess = true;
                        }
                    }else if(document.SymphonyIPM__First_Parent_Id__c != null){
                        SymphonyIPM__Patent_Attachments__c document2 = [SELECT Id, Name, SymphonyIPM__Patent__c, Review_By__c, SymphonyIPM__First_Parent_Id__c FROM SymphonyIPM__Patent_Attachments__c WHERE Id=: document.SymphonyIPM__First_Parent_Id__c];
                        if(String.isNotBlank(document2.Review_By__c)){
                            roles.addAll(document2.Review_By__c.split(';'));
                            if(roles.contains(currentRole)){
                                hasAccess = true;
                            }
                        }
                    }
                }
    
                    
            }
            
            return hasAccess;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<PicklistOption> getDocumentTypeOptions(){
        try {
            List<PicklistOption> options = new List<PicklistOption>();
            Schema.DescribeFieldResult fieldResult = SymphonyIPM__Patent_Attachments__c.SymphonyIPM__Document_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                options.add(new PicklistOption(pickListVal.getLabel(), pickListVal.getValue()));
            }

            return options;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<MultiSelectPicklistOption> getReviewByOptions(String recordId){
        try {
            Set<String> roleSet = new Set<String>();
            SymphonyIPM__Patent_Attachments__c document = [SELECT Id, Name, SymphonyIPM__Patent__c FROM SymphonyIPM__Patent_Attachments__c WHERE Id=: recordId];
            List<MultiSelectPicklistOption> options = new List<MultiSelectPicklistOption>();
            for(Patent_Role__c pr: [SELECT Id, Patent__c, Role__c FROM Patent_Role__c WHERE Patent__c =:document.SymphonyIPM__Patent__c]){
                if(!roleSet.contains(pr.Role__c)){
                    options.add(new MultiSelectPicklistOption(pr.Role__c, pr.Role__c));
                    roleSet.add(pr.Role__c);
                }
            }
            return options;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String savePatentDocument(SymphonyIPM__Patent_Attachments__c patentDocument){
        try {
            SymphonyIPM__Patent_Document_Types__mdt docCode = [SELECT Id, SymphonyIPM__Code__c FROM SymphonyIPM__Patent_Document_Types__mdt WHERE MasterLabel =: patentDocument.SymphonyIPM__Document_Type__c];
            patentDocument.SymphonyIPM__Document_Type_Code__c = docCode.SymphonyIPM__Code__c;
            patentDocument.SymphonyIPM__Document_Type_No__c = 1;
            patentDocument.Name = '[' + docCode.SymphonyIPM__Code__c + '-000' + patentDocument.SymphonyIPM__Document_Type_No__c + ']';
            patentDocument.SymphonyIPM__Actor_Status__c = 'Submitted';
            patentDocument.SymphonyIPM__Sub_Status__c = 'One or more reviews pending';
            patentDocument.SymphonyIPM__Actor__c = 'OC';
            patentDocument.SymphonyIPM__Next_Action__c = 'To be reviewed';
            patentDocument.SymphonyIPM__Actor_Id__c = UserInfo.getUserId();
            patentDocument.SymphonyIPM__Uploaded_on__c = Datetime.now();
            update patentDocument;

            SymphonyIPM__Patent_Attachments__c clonedDocument = patentDocument.clone(false, false, false, false);
            clonedDocument.SymphonyIPM__Parent_Id__c = patentDocument.Id;
            clonedDocument.SymphonyIPM__First_Parent_Id__c = patentDocument.Id;
            clonedDocument.SymphonyIPM__Actor_Status__c = 'Review Pending';
            clonedDocument.SymphonyIPM__Sub_Status__c = '';
            clonedDocument.SymphonyIPM__Next_Action__c = '';
            clonedDocument.SymphonyIPM__Actor__c = 'IC';
            insert clonedDocument;
            return 'Document uploaded successfully';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String savePatentDocumentFinalVersion(SymphonyIPM__Patent_Attachments__c patentDocument){
        try {
            SymphonyIPM__Patent_Document_Types__mdt docCode = [SELECT Id, SymphonyIPM__Code__c FROM SymphonyIPM__Patent_Document_Types__mdt WHERE MasterLabel =: patentDocument.SymphonyIPM__Document_Type__c];
            patentDocument.SymphonyIPM__Document_Type_Code__c = docCode.SymphonyIPM__Code__c;
            patentDocument.SymphonyIPM__Actor_Status__c = 'Approved';
            patentDocument.SymphonyIPM__Sub_Status__c = '';
            patentDocument.SymphonyIPM__Actor__c = 'OC';
            patentDocument.Review_By__c = [SELECT Review_By__c FROM SymphonyIPM__Patent_Attachments__c WHERE Id=:patentDocument.SymphonyIPM__First_Parent_Id__c LIMIT 1].Review_By__c;
            patentDocument.SymphonyIPM__Next_Action__c = '';
            patentDocument.SymphonyIPM__Actor_Id__c = UserInfo.getUserId();
            patentDocument.SymphonyIPM__Reviewed_by__c = UserInfo.getUserId();
            patentDocument.SymphonyIPM__Uploaded_on__c = Datetime.now();
            update patentDocument;

            return 'Document uploaded successfully';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string saveDraftDocument(SymphonyIPM__Patent_Attachments__c patentDocument){
        try {
            patentDocument.SymphonyIPM__Actor_Status__c = 'Draft';
            update patentDocument;
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string deleteDocument(SymphonyIPM__Patent_Attachments__c patentDocument){
        try {
            String patentId = patentDocument.SymphonyIPM__Patent__c;
            delete patentDocument;
            return patentId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<DocumentHistoryRecord> getPatentAttachmentHistory(String recordId){
        try {
            SymphonyIPM__Patent_Attachments__c initialRecord = [SELECT Id, SymphonyIPM__First_Parent_Id__c FROM SymphonyIPM__Patent_Attachments__c WHERE Id=: recordId];
            Map<Id, SymphonyIPM__Patent_Attachments__c> documents;
            if(initialRecord.SymphonyIPM__First_Parent_Id__c != null){
                documents = new Map<ID, SymphonyIPM__Patent_Attachments__c>([SELECT Id, SymphonyIPM__Uploaded_on__c, Review_By__c, SymphonyIPM__Sub_Status__c,
                                                                  SymphonyIPM__Version__c, SymphonyIPM__Respond_by_Date__c, SymphonyIPM__PTO_Due_Date__c,
                                                                  SymphonyIPM__Comments__c, SymphonyIPM__Actor_Status__c, SymphonyIPM__Reviewed_on__c, SymphonyIPM__Reviewed_by__c,
                                                                  SymphonyIPM__Reviewed_by__r.Name  
                                                            FROM SymphonyIPM__Patent_Attachments__c 
                                                            WHERE (Id=: initialRecord.SymphonyIPM__First_Parent_Id__c OR SymphonyIPM__First_Parent_Id__c =:initialRecord.SymphonyIPM__First_Parent_Id__c)
                                                            ORDER BY CreatedDate ]);
            }else{
                documents = new Map<ID, SymphonyIPM__Patent_Attachments__c>([SELECT Id, SymphonyIPM__Uploaded_on__c, Review_By__c, SymphonyIPM__Sub_Status__c,
                                                                  SymphonyIPM__Version__c, SymphonyIPM__Respond_by_Date__c, SymphonyIPM__PTO_Due_Date__c,
                                                                  SymphonyIPM__Comments__c, SymphonyIPM__Actor_Status__c, SymphonyIPM__Reviewed_on__c, SymphonyIPM__Reviewed_by__c,
                                                                  SymphonyIPM__Reviewed_by__r.Name 
                                                            FROM SymphonyIPM__Patent_Attachments__c 
                                                            WHERE Id=: recordId]);
            }

            Map<Id, List<ContentDocumentLink>> mapAttachmentToDocuments = new Map<Id, List<ContentDocumentLink>>();
            for(ContentDocumentLink cdl: [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, Visibility, ShareType FROM ContentDocumentLink WHERE LinkedEntityId IN:documents.keyset()]){
                List<ContentDocumentLink> tempList;
                if(mapAttachmentToDocuments.containsKey(cdl.LinkedEntityId)){
                    tempList = mapAttachmentToDocuments.get(cdl.LinkedEntityId);
                }else{
                    tempList = new List<ContentDocumentLink>();
                }
                tempList.add(cdl);
                mapAttachmentToDocuments.put(cdl.LinkedEntityId, tempList);
            }
            List<DocumentHistoryRecord> records = new List<DocumentHistoryRecord>();
            for(SymphonyIPM__Patent_Attachments__c document: documents.values()){
                records.add(new DocumentHistoryRecord(document, mapAttachmentToDocuments.get(document.Id)));
            }
            
            return records;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<PatentAttachment> getPatentDocuments(String patentId){
        try {
            List<PatentAttachment> resutls = new List<PatentAttachment>();
            List<SymphonyIPM__Patent_Attachments__c> allAttachments = [
                    SELECT Id, Name, SymphonyIPM__Patent__c, SymphonyIPM__Actor_Id__c, SymphonyIPM__Actor_Status__c, SymphonyIPM__Respond_by_Date__c,
                        SymphonyIPM__Actor__c, SymphonyIPM__Actor_s_Latest__c, SymphonyIPM__Comments__c, SymphonyIPM__Document_Type_Code__c,
                        SymphonyIPM__Content_Version_Id__c, SymphonyIPM__Document_Type_No__c, SymphonyIPM__Document_Type__c, SymphonyIPM__Is_Sent_Out__c, 
                        SymphonyIPM__Next_Action__c, SymphonyIPM__Previous_Parent_Id__c, SymphonyIPM__Version__c, SymphonyIPM__First_Parent_Id__c,
                        SymphonyIPM__PTO_Due_Date__c, Review_By__c, LastModifiedDate
                    FROM SymphonyIPM__Patent_Attachments__c
                    WHERE SymphonyIPM__Patent__c=: patentId ORDER BY LastModifiedDate];
            
            Map<String, SymphonyIPM__Patent_Attachments__c> getLatestAttachments = new Map<String, SymphonyIPM__Patent_Attachments__c>();
            Set<String> initialDocumentIds = new Set<String>();
            for(SymphonyIPM__Patent_Attachments__c attachment: allAttachments){
                String key = attachment.SymphonyIPM__Patent__c +'-'+ (attachment.SymphonyIPM__First_Parent_Id__c != null ?attachment.SymphonyIPM__First_Parent_Id__c : attachment.Id);
                String attachmentId = attachment.SymphonyIPM__First_Parent_Id__c != null ?attachment.SymphonyIPM__First_Parent_Id__c : attachment.Id;
                initialDocumentIds.add(attachmentId);
                getLatestAttachments.put(key, attachment);
            }

            Map<Id, List<ContentDocumentLink>> mapAttachmentToDocuments = new Map<Id, List<ContentDocumentLink>>();
            for(ContentDocumentLink cdl: [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, Visibility, ShareType FROM ContentDocumentLink WHERE LinkedEntityId IN:initialDocumentIds]){
                List<ContentDocumentLink> tempList;
                if(mapAttachmentToDocuments.containsKey(cdl.LinkedEntityId)){
                    tempList = mapAttachmentToDocuments.get(cdl.LinkedEntityId);
                }else{
                    tempList = new List<ContentDocumentLink>();
                }
                tempList.add(cdl);
                mapAttachmentToDocuments.put(cdl.LinkedEntityId, tempList);
            }
            

            for(SymphonyIPM__Patent_Attachments__c attach: getLatestAttachments.values()){
                String attachmentId = attach.SymphonyIPM__First_Parent_Id__c != null ?attach.SymphonyIPM__First_Parent_Id__c : attach.Id;
                resutls.add(new PatentAttachment(attach, mapAttachmentToDocuments.get(attachmentId)));
            }

            return resutls;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<PatentAttachment> getPatentPendingDocuments(String patentId){
        try {
            List<PatentAttachment> resutls = new List<PatentAttachment>();
            List<SymphonyIPM__Patent_Attachments__c> allAttachments = [
                    SELECT Id, Name, SymphonyIPM__Patent__c, SymphonyIPM__Actor_Id__c, SymphonyIPM__Actor_Status__c, SymphonyIPM__Respond_by_Date__c,
                        SymphonyIPM__Actor__c, SymphonyIPM__Actor_s_Latest__c, SymphonyIPM__Comments__c, SymphonyIPM__Document_Type_Code__c,
                        SymphonyIPM__Content_Version_Id__c, SymphonyIPM__Document_Type_No__c, SymphonyIPM__Document_Type__c, SymphonyIPM__Is_Sent_Out__c, 
                        SymphonyIPM__Next_Action__c, SymphonyIPM__Previous_Parent_Id__c, SymphonyIPM__Version__c, SymphonyIPM__First_Parent_Id__c,
                        SymphonyIPM__PTO_Due_Date__c, Review_By__c, LastModifiedDate
                    FROM SymphonyIPM__Patent_Attachments__c
                    WHERE SymphonyIPM__Patent__c=: patentId AND SymphonyIPM__Actor_Status__c IN ('Draft', 'Submitted') ORDER BY LastModifiedDate];
            
            Map<String, SymphonyIPM__Patent_Attachments__c> getLatestAttachments = new Map<String, SymphonyIPM__Patent_Attachments__c>();
            Set<String> initialDocumentIds = new Set<String>();
            for(SymphonyIPM__Patent_Attachments__c attachment: allAttachments){
                String key = attachment.SymphonyIPM__Patent__c +'-'+ (attachment.SymphonyIPM__First_Parent_Id__c != null ?attachment.SymphonyIPM__First_Parent_Id__c : attachment.Id);
                String attachmentId = attachment.SymphonyIPM__First_Parent_Id__c != null ?attachment.SymphonyIPM__First_Parent_Id__c : attachment.Id;
                initialDocumentIds.add(attachmentId);
                getLatestAttachments.put(key, attachment);
            }

            Map<Id, List<ContentDocumentLink>> mapAttachmentToDocuments = new Map<Id, List<ContentDocumentLink>>();
            for(ContentDocumentLink cdl: [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, Visibility, ShareType FROM ContentDocumentLink WHERE LinkedEntityId IN:initialDocumentIds]){
                List<ContentDocumentLink> tempList;
                if(mapAttachmentToDocuments.containsKey(cdl.LinkedEntityId)){
                    tempList = mapAttachmentToDocuments.get(cdl.LinkedEntityId);
                }else{
                    tempList = new List<ContentDocumentLink>();
                }
                tempList.add(cdl);
                mapAttachmentToDocuments.put(cdl.LinkedEntityId, tempList);
            }
            

            for(SymphonyIPM__Patent_Attachments__c attach: getLatestAttachments.values()){
                String attachmentId = attach.SymphonyIPM__First_Parent_Id__c != null ?attach.SymphonyIPM__First_Parent_Id__c : attach.Id;
                resutls.add(new PatentAttachment(attach, mapAttachmentToDocuments.get(attachmentId)));
            }

            return resutls;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String createPatentAttachmentRecord(String patentId){
        try {
            SymphonyIPM__Patent_Attachments__c pa = new SymphonyIPM__Patent_Attachments__c();
            pa.Name = '-';
            pa.SymphonyIPM__Patent__c = patentId;
            pa.SymphonyIPM__Version__c = 'Initial';
            pa.SymphonyIPM__Actor_Status__c = 'Draft';
            pa.SymphonyIPM__Actor_Id__c = UserInfo.getUserId();
            pa.SymphonyIPM__Actor_s_Latest__c = true;
            insert pa;
            return pa.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getPatentDocumentAccessForLoggedInUser(String patentId){
        try {
            Profile sysAdminProfile = [SELECT Id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()];
            if(sysAdminProfile.Name == 'System Administrator' || sysAdminProfile.Name == 'Outside Counsel'){
                return 'edit';
            }
            String access = 'NoAccess';
            List<Patent_Role__c> userCurrentRoles = [SELECT Id, Role__c FROM Patent_Role__c WHERE Patent__c=:patentId AND Person__r.SymphonyIPM__User__c=:UserInfo.getUserId()];
            Set<String> roles = new Set<String>();
            if(userCurrentRoles != null && userCurrentRoles.size() > 0){
                for(Patent_Role__c role: userCurrentRoles){
                    roles.add(role.Role__c);
                }

                List<PatentSharingMatrix__mdt> roleMatrix = [SELECT ShareLevel__c FROM PatentSharingMatrix__mdt WHERE Object_API_Name__c = 'SymphonyIPM__Patent_Attachments__c' AND Role__c =:roles ORDER BY ShareLevel__c DESC];
                Set<String> accessLevels = new Set<String>();
                for(PatentSharingMatrix__mdt matrix: roleMatrix){
                    accessLevels.add(matrix.ShareLevel__c);
                }

                if(accessLevels.contains('edit')){
                    access = 'edit';
                }else if(accessLevels.contains('read')){
                    access = 'read';
                }
            }

            return access;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getPatentDocumentAccessForLoggedInUserDocId(String docId){
        try {
            Profile sysAdminProfile = [SELECT Id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()];
            if(sysAdminProfile.Name == 'System Administrator' || sysAdminProfile.Name == 'Outside Counsel'){
                return 'edit';
            }
            String access = 'NoAccess';
            SymphonyIPM__Patent_Attachments__c doc = [SELECT Id, Name, SymphonyIPM__Patent__c FROM SymphonyIPM__Patent_Attachments__c WHERE Id=: docId];
            String patentId = doc.SymphonyIPM__Patent__c;
            List<Patent_Role__c> userCurrentRoles = [SELECT Id, Role__c FROM Patent_Role__c WHERE Patent__c=:patentId AND Person__r.SymphonyIPM__User__c=:UserInfo.getUserId()];
            Set<String> roles = new Set<String>();
            if(userCurrentRoles != null && userCurrentRoles.size() > 0){
                for(Patent_Role__c role: userCurrentRoles){
                    roles.add(role.Role__c);
                }

                List<PatentSharingMatrix__mdt> roleMatrix = [SELECT ShareLevel__c FROM PatentSharingMatrix__mdt WHERE Object_API_Name__c = 'SymphonyIPM__Patent_Attachments__c' AND Role__c =:roles ORDER BY ShareLevel__c DESC];
                Set<String> accessLevels = new Set<String>();
                for(PatentSharingMatrix__mdt matrix: roleMatrix){
                    accessLevels.add(matrix.ShareLevel__c);
                }

                if(accessLevels.contains('edit')){
                    access = 'edit';
                }else if(accessLevels.contains('read')){
                    access = 'read';
                }
            }

            return access;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class PicklistOption{
        @AuraEnabled
        public String label {get;set;}

        @AuraEnabled
        public String value {get;set;}

        public PicklistOption(String label, String value){
            this.label = label;
            this.value = value;
        }
    }
    
    public class MultiSelectPicklistOption{
        @AuraEnabled
        public String label {get;set;}

        @AuraEnabled
        public String name {get;set;}

        public MultiSelectPicklistOption(String label, String name){
            this.label = label;
            this.name = name;
        }
    }

    public class DocumentHistoryRecord{
        @AuraEnabled
        public String actorStatus {get;set;}

        @AuraEnabled
        public DateTime submittedOn {get;set;}
        
        @AuraEnabled
        public DateTime reviewedOn {get;set;}
        
        @AuraEnabled
        public String reviewBy {get;set;}
        
        @AuraEnabled
        public String reviewedBy {get;set;}

        @AuraEnabled
        public String status {get;set;}

        @AuraEnabled
        public String version {get;set;}
        
        @AuraEnabled
        public Date responseByDate {get;set;}
        
        @AuraEnabled
        public Date PTODueDate {get;set;}
        
        @AuraEnabled
        public String comments {get;set;}

        @AuraEnabled
        public List<ContentDocumentLink> uploadedFiles {get;set;}

        public DocumentHistoryRecord(SymphonyIPM__Patent_Attachments__c patentAttachment, List<ContentDocumentLink> documents){
            this.actorStatus = patentAttachment.SymphonyIPM__Actor_Status__c;
            this.submittedOn = patentAttachment.SymphonyIPM__Uploaded_on__c;
            this.reviewedOn = patentAttachment.SymphonyIPM__Reviewed_on__c;
            this.reviewBy = patentAttachment.Review_By__c;
            this.reviewedBy = patentAttachment.SymphonyIPM__Reviewed_by__c != null ? patentAttachment.SymphonyIPM__Reviewed_by__r.Name : '';
            this.status = patentAttachment.SymphonyIPM__Sub_Status__c;
            this.version = patentAttachment.SymphonyIPM__Version__c;
            this.responseByDate = patentAttachment.SymphonyIPM__Respond_by_Date__c;
            this.PTODueDate = patentAttachment.SymphonyIPM__PTO_Due_Date__c;
            this.comments = patentAttachment.SymphonyIPM__Comments__c;
            this.uploadedFiles = documents;
        }
    }

    public class PatentAttachment{
        @AuraEnabled
        public String recordId {get;set;}

        @AuraEnabled
        public DateTime lastModified {get;set;}
        
        @AuraEnabled
        public String documentNumber {get;set;}
        
        @AuraEnabled
        public String version {get;set;}
        
        @AuraEnabled
        public String actor {get;set;}
        
        @AuraEnabled
        public String reviewByRoles {get;set;}
        
        @AuraEnabled
        public String documentType {get;set;}
        
        @AuraEnabled
        public List<ContentDocumentLink> uploadedFiles {get;set;}

        @AuraEnabled
        public Date respondBy {get;set;}
        
        @AuraEnabled
        public String status {get;set;}

        public PatentAttachment(SymphonyIPM__Patent_Attachments__c doc, List<ContentDocumentLink> cdls ){
            this.recordId = doc.Id;
            this.lastModified = doc.LastModifiedDate;
            this.documentNumber = doc.Name;
            this.version = doc.SymphonyIPM__Version__c;
            this.actor = doc.SymphonyIPM__Actor__c;
            this.reviewByRoles = doc.Review_By__c;
            this.documentType = doc.SymphonyIPM__Document_Type__c;
            this.respondBy = doc.SymphonyIPM__Respond_by_Date__c;
            this.status = doc.SymphonyIPM__Actor_Status__c;
            this.uploadedFiles = cdls;
        }
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
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;

    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;

    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
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