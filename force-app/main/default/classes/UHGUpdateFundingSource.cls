public class UHGUpdateFundingSource {
    @Future
    public static void updateFundingSource() {
        List <SymphonyIPM__Patent__c> myPatents = new List<SymphonyIPM__Patent__c>();
        // Get SymphonyIPM__Patent__c that are missing value for Funding_Source_New__c
        myPatents = [SELECT Id, Funding_Source_New__c FROM SymphonyIPM__Patent__c WHERE Id != null AND Id != '' AND (Funding_Source_New__c = null OR Funding_Source_New__c = '') LIMIT 600];
        // loop through them and update the Funding_Source_New__c field
        for (SymphonyIPM__Patent__c myPatent : myPatents) {
            myPatent.Funding_Source_New__c = 'Business Segment';
        }
        // save the change you made
        update myPatents;
    }
}