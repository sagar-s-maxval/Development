public with sharing class AssetInventorSelector {

    public static List<SymphonyIPM__Asset_Inventor_v1__c> getAssetInventorsByPatentId(Id patentId) {
        return [
                SELECT Id, SymphonyIPM__Inventor__c
                FROM SymphonyIPM__Asset_Inventor_v1__c
                WHERE SymphonyIPM__Asset__c = :patentId
        ];
    }
}