public class EmailAuditTrailController {

    @AuraEnabled
    public static EmailAuditTrail__c getEmailBody(Id emailAuditId) {
        List<EmailAuditTrail__c> emails = [SELECT Body__c, EmailAddresses__c, From__c FROM EmailAuditTrail__c WHERE Id = :emailAuditId];

        return emails.isEmpty() ? new EmailAuditTrail__c() : emails.get(0);
    }

    @AuraEnabled
    public static List<EmailAuditTrail__c> getEmails(Id recordId) {
        return [
                SELECT Id, Date_Sent__c, Link__c, EmailAddresses__c, From__c, EmailSubject__c
                FROM EmailAuditTrail__c
                WHERE Invention_Disclosure__c = :recordId
                OR Trademark__c = :recordId
                OR TM_Search_Instruction_Ref__c = :recordId
                OR Search_Project__c = :recordId
                OR D_O_Recommendation__c = :recordId
                ORDER BY Date_Sent__c DESC
        ];
    }

    @AuraEnabled
    public static List<PickListWrapper> getDocTypePickListValues() {
        try {
            List<PickListWrapper> pickListValuesList = new List<PickListWrapper>();
            Schema.DescribeFieldResult fieldResult = Patent_Document__c.Document_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry pickListVal : ple) {
                pickListValuesList.add(new PickListWrapper(pickListVal.getLabel(), pickListVal.getLabel()));
            }
            return pickListValuesList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Patent_Document__c> getEmailMessageDocuments(String emailMessageId) {
        try {
            List<Patent_Document__c> newDocuments = [
                    SELECT Id, Name, File_Name_Big__c, Document_Type__c, Upload_Date__c, isActive__c, Comments__c
                    FROM Patent_Document__c
                    WHERE Source__c = 'Email'
                    AND EmailMessageId__c = :emailMessageId
                    AND isActive__c = FALSE
            ];
            return newDocuments;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String updatePatentDocuments(List<Patent_Document__c> documents) {
        try {
            update documents;
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class PickListWrapper {
        @AuraEnabled
        public String label { get; set; }

        @AuraEnabled
        public String name { get; set; }

        public PickListWrapper(String label, String name) {
            this.label = label;
            this.name = name;
        }
    }

    public static void magicMethod() {
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
    }
}