public with sharing class SDocTemplateSelector {
    public static SDOC__SDTemplate__c getTemplateById(Id templateId) {
        return [SELECT Id, Sign_Type__c FROM SDOC__SDTemplate__c WHERE Id = :templateId];
    }
}