@isTest
private class UHGRedirectTest {
    static testMethod void runPositiveTestCases() {
        SymphonyIPM__Invention_Disclosure_New__c idf = new SymphonyIPM__Invention_Disclosure_New__c(Name = 'IDF-000001');
        insert idf;
        
        SymphonyIPM__Patent__c pat = new SymphonyIPM__Patent__c(SymphonyIPM__Docket_No__c = 'P-000001-00-US-ORG1');
        insert pat;
        
        //Invention Disclosure docket number to test
        String externalDiscId = 'IDF-000001';
        
        System.debug('Testing redirect to ' + externalDiscId);
        
        //Set URL for apex page
        PageReference pageDiscRef = new PageReference('/apex/ism?externalId=' + externalDiscId);
        Test.setCurrentPage(pageDiscRef);
        
        //run apex controller
        UHGRedirectToDetailRecord redirectDiscTest = new UHGRedirectToDetailRecord();
        redirectDiscTest.redirectURL();
        
        //get ID from database
        SymphonyIPM__Invention_Disclosure_New__c discRecord = [select id from SymphonyIPM__Invention_Disclosure_New__c where id =: idf.Id];
        
        //get ID from redirect
        String id = ApexPages.currentPage().getParameters().get('id');
        
        //compare IDs
       // System.assertEquals(discRecord.id, id);
        
        //Patent docket number to test
        String externalPatId = 'P-000001-00-US-ORG1';
        
        System.debug('Testing redirect to ' + externalPatId);
        
        //Set URL for apex page
        PageReference pagePatRef = new PageReference('/apex/ism?externalId=' + externalPatId);
        Test.setCurrentPage(pagePatRef);
        
        //Run apex controller
        UHGRedirectToDetailRecord redirectPatTest = new UHGRedirectToDetailRecord();
        redirectPatTest.redirectURL();
        
        //Get ID from database
        SymphonyIPM__Patent__c patRecord = [select id from SymphonyIPM__Patent__c where id =: pat.id];
        
        //Get ID from redirect
        id = ApexPages.currentPage().getParameters().get('id');
        
        //Compare IDs
       // System.assertEquals(patRecord.id, id);
    }
}