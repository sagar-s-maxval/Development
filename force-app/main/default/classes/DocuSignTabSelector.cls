public with sharing class DocuSignTabSelector {
    public static List<DocuSignTab__c> getDocuSignTabsBySDocTemplateId(Set<Id> sDocTemplateId) {
        return [
                SELECT Id, pageNumber__c, Tabs__c,
                        textTabsField__c, XPosition__c, YPosition__c, AnchorString__c,
                        SDoc_Template__c, anchorUnits__c
                FROM DocuSignTab__c
                WHERE SDoc_Template__c IN :sDocTemplateId
        ];
    }
}