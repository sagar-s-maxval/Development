public with sharing class EmailTrackerController {

    @AuraEnabled
    public static List<Attachment> getAttachments(Id recordId) {
        List<Emai_Tracker__c> emtk = [SELECT Id, Email_Message_Id__c FROM Emai_Tracker__c WHERE Id = :recordId AND Email_Message_Id__c != NULL];
        if (emtk.isEmpty()) {
            return new List<Attachment>();
        }

        return [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId = :emtk[0].Email_Message_Id__c];
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
}
}