public with sharing class AdditionalInventorSelector {
    public static List<SymphonyIPM__Additional_Inventor__c> getAdditionalInventorsByInvDiscId(Id invDiscId) {
        return [
                SELECT Id, SymphonyIPM__Inventor__c,
                        SymphonyIPM__Invention_Disclosure_New__r.SymphonyIPM__Hierarchy__c
                FROM SymphonyIPM__Additional_Inventor__c
                WHERE SymphonyIPM__Invention_Disclosure_New__c = :invDiscId
                AND Is_Contribution_Applicable__c = TRUE
        ];
    }
    //Added//
    public static SymphonyIPM__Additional_Inventor__c getAdditionalInventorsById(Id addInvId) {
        return [
                SELECT Id, SymphonyIPM__Inventor__c,
                        SymphonyIPM__Invention_Disclosure_New__c,
                        SymphonyIPM__Invention_Disclosure_New__r.SymphonyIPM__Hierarchy__c
                FROM SymphonyIPM__Additional_Inventor__c
                WHERE Id = :addInvId
        ];
    }
    //Ended//
}