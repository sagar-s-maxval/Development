public class UHGRedirectToDetailRecord {

    public PageReference redirectURL() {
        //get the external id from the URL
        String externalId = ApexPages.currentPage().getParameters().get('externalId');
        String pageRef = '';
        try
                {
        if( externalId.length() > 9 ) {
            
            if( externalId.substring(0,1).toUpperCase() == 'I') {
                
                //query the Invention Disclosure record.
                SymphonyIPM__Invention_Disclosure_New__c discRecord = [select id from SymphonyIPM__Invention_Disclosure_New__c where Name =: externalId];
                pageRef = '/' + discRecord.id;
            
            }
            else if(externalId.substring(0,1).toUpperCase() == 'P') {
                //query the Patent record.
                SymphonyIPM__Patent__c patRecord = [select id from SymphonyIPM__Patent__c where SymphonyIPM__Docket_No__c =: externalId];
                pageRef = '/' + patRecord.id;
            
            }
                }
                }
                catch(Exception e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
}
                
        
            return new pageReference(pageRef);
        //redirect to detail page of the above record.
        
    }


}