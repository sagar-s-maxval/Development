public with sharing class DocuSignReviewerSelector {
    public static List<DocuSignReviewer__c> getReviewersPatentOrInvDiscId(Id patentOrInvDiscId) {
        return [
            SELECT Id,
                Recipient_Type__c,
                Person__c,
                Person__r.Name,
                Person__r.SymphonyIPM__Email__c,
                Person__r.SymphonyIPM__Employment_status__c,
                CurrencyIsoCode
            FROM DocuSignReviewer__c
            WHERE (Invention_Disclosure__c = :patentOrInvDiscId OR Patent__c = :patentOrInvDiscId)
        ];
    }

    public static List<DocuSignReviewer__c> getSelectedReviewers(Id recordId, List<Id> selectedReviewers) {
        return [
                SELECT Id, Patent__c, Person__r.Id, Person__r.Name, Person__r.SymphonyIPM__Email__c
                FROM DocuSignReviewer__c
                WHERE Person__r.Id IN :selectedReviewers AND (Patent__c = :recordId OR Invention_Disclosure__c = :recordId)
        ];
    }
}