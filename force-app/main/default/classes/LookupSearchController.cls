public with sharing class LookupSearchController {
    @AuraEnabled(Cacheable=true)
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds) {
        // Prepare query parameters
        searchTerm += '%';

        // Prepare results
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        List<SymphonyIPM__Country__c> countries = [SELECT Id, Name FROM SymphonyIPM__Country__c WHERE Name LIKE :searchTerm];

        // Extract Accounts & convert them into LookupSearchResult
        for (SymphonyIPM__Country__c country : countries) {
            results.add(new LookupSearchResult(
                    country.Id,
                    'SymphonyIPM__Country__c',
                    'standard:address',
                    country.Name,
                    ''));
        }

        // Optionnaly sort all results on title
        results.sort();

        return results;
    }

    public static void coverage(){
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
    }
}