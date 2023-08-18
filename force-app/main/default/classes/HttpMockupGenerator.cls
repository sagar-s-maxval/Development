@isTest
global class HttpMockupGenerator implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req)
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint().endsWith('employeeIds'))
           {
               res.setHeader('Content-Type', 'application/json');
               res.setBody('["000704292","000690480"]');
               res.setStatusCode(200);
           }
        else if (req.getEndpoint().endsWith('token')) { 
               res.setHeader('Content-Type', 'application/json');
               res.setBody('{"token_type":"bearer","access_token":"U35RAO44j4xIFhl6","expires_in":3600}');
               res.setStatusCode(200);
            } 
        else  if (req.getEndpoint().endsWith('managers=1')){ 
               res.setHeader('Content-Type', 'application/json');
               //res.setBody('["000704292","000690480"]');
               res.setBody('[{"dn": "CN=dwichma,DC=com","msid": "dwichma","firstName": "David","middleName": "S","lastName": "Wichmann","employeeId": "000054315","mail": "david_s_wichmann@uhg.com","activeStatus": "Active","managerDN": "CN=dwichma,CN=Users,DC=ms,DC=ds,DC=uhc,DC=com","externalSegment": "Corporate","managers": "","externalSegmentCode": "100","internalSegment": "Corporate","internalSegmentCode": "100","mailCode": "MN008-T040","division": "Executive Management","divisionCode": "10100","marketGroup": "Corporate","marketGroupCode": "100","business": "Executive","businessCode": "101","department": "100000","displayName": "Wichmann David S","businessUnit": "20020", "operatingUnit": "01000","title": "CEO","employeeType": "Employee","streetAddresss": "9900 BREN RD EAST","location": "Minnetonka","state": "MN","country": "USA","postalCode": "55343","telephoneNumber": "+1(952) 936-7109","glLocation": "USASS800","additionalInfo1": "","additionalInfo2": "","additionalInfo3":""}]');
               res.setStatusCode(200);
            } 
            return res; 

    }
}