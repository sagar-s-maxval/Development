@IsTest
private class DocuSignAPI_Test {

    @IsTest(SeeAllData=true)
    static void testCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new DocuSignAPI.FakeCallout());

        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        HttpResponse res = new DocuSignAPI().send('GET','envelopes','{}');

        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{\n' +
            '  "resultSetSize": "0",\n' +
            '  "totalSetSize": "0",\n' +
            '  "nextUri": "",\n' +
            '  "previousUri": "",\n' +
            '  "envelopes": []\n' +
            '}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        DocuSignAPI.magicMethod();
    }
}