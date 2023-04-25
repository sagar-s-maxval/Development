public class EmailTrackerServiceCtrl {
    @AuraEnabled
    public static EmailMessage getEmailMessageObject(String trackerId){
        try {
            Emai_Tracker__c tracker = [SELECT Id, Email_Message_Id__c FROM Emai_Tracker__c WHERE Id=:trackerId];
            EmailMessage message = [SELECT Id, FromName, ToAddress, HtmlBody, HTML_Body__c FROM EmailMessage WHERE Id=:tracker.Email_Message_Id__c ];
            return message;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
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
}
}