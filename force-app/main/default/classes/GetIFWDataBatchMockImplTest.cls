@isTest
global class GetIFWDataBatchMockImplTest implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        integer ClientID = 39;
        integer CrawlerID = 110;
        String  doccode = '234';       
        String  AppNo = '123';       
        String urls  = 'https://symphony.maxval-ip.com/QA/PairService.svc/IfwDocumentDetails/ClientID/' + ClientID + '/CrawlerID/' + CrawlerID + '/DocumentHandle/' + doccode + '/ApplicationNo/' + AppNo + '';
        System.assertEquals(urls, req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('<?xml version="1.0" encoding="UTF-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates><fullName>Update_Known_Art_Fields</fullName></fieldUpdates></Workflow>');
        res.setStatusCode(200);
        return res;
    }
    
    @isTest static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new GetIFWDataBatchMockImplTest());
        //GetIFWDataBatchMockImpl.respond(req);
    }
    
}