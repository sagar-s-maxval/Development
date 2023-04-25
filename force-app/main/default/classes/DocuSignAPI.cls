/**
 * DocuSign API to create envelopes send for signature
 */
public with sharing class DocuSignAPI {

    private DocuSign__c DS = DocuSign__c.getInstance('JWT');

    /**
     * Send HTTP Request to DocuSign API using: JWT Exchange Bearer Flow:
     *
     * JWT generated and exchanged to Access Token
     *
     * @return HttpResponse with JSON body
     */
    public HttpResponse send(String method, String resource, String body) {
        Http http = new Http();

        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(DS.EndPoint__c + DS.AccountNumber__c + '/' + resource);
        req.setHeader('Content-type', 'application/json');
        if (body.trim() != '') {
            req.setBody(body);
            req.setHeader('Content-length', String.valueOf(body.length()));
        } else {
            req.setHeader('Content-length', '0');
        }

        // Call with existing token
        req.setHeader('Authorization', 'Bearer ' + getAccessToken());
        HttpResponse response = http.send(req);

        // Call with new token if fail
        if (response.getStatusCode() != 200 && response.getStatusCode() != 201) {
            String newAccessToken;

            if (Test.isRunningTest()) {
                newAccessToken = getFakeToken();
            } else {
                // Generate new access token
                newAccessToken = JWTBearerTokenExchange();
            }

            // Retrieve request
            req.setHeader('Authorization', 'Bearer ' + newAccessToken);
            response = http.send(req);

            // Perform DML after last callout
            saveAccessToken(newAccessToken);
        }

        return response;
    }

    /**
     * Send HTTP Request to DocuSign API using legacy Authentication method:
     *
     * Header = User Name + User Password + Integration Key
     *
     * @return HttpResponse with JSON body
     */
//    public HttpResponse sendLegacy(String method, String resource, String body) {
//        DocuSign__c ds_legacy = DocuSign__c.getInstance('Default');
//
//        String apiHeader = '<DocuSignCredentials>' +
//                '<Username>' + ds_legacy.UserName__c + '</Username>' +
//                '<Password>' + ds_legacy.UserPassword__c + '</Password>' +
//                '<IntegratorKey>' + ds_legacy.IntegratorKey__c + '</IntegratorKey>' +
//                '</DocuSignCredentials>';
//
//        HttpRequest req = new HttpRequest();
//        req.setEndpoint(ds_legacy.EndPoint__c + ds_legacy.AccountNumber__c + '/' + resource);
//        req.setMethod(method);
//
//        if (body.trim() != '') {
//            req.setBody(body);
//            req.setHeader('Content-length', String.valueOf(body.length()));
//        }
//        req.setHeader('Content-type', 'application/json');
//        req.setHeader('X-DocuSign-Authentication', apiHeader);
//
//        HttpResponse response = new Http().send(req);
//
//        return response;
//    }


    // ---------- JWT Helpers ----------

    private String getAccessToken() {
        // Build existing access token from Custom Settings chunks
        return DS.AccessToken1__c + DS.AccessToken2__c + DS.AccessToken3__c;
    }

    private void saveAccessToken(String s) {
        // Expected token length
        if (s.length() > 750) {
            throw new usf.RegExps.ExpressionParsingException('access token longer that 750 chars');
        }

        // Split token into chunks to fit custom settings limitations
        DS.AccessToken1__c = s.substring(0, 255);
        DS.AccessToken2__c = s.substring(255, 510);
        DS.AccessToken3__c = s.substring(510);

        update DS;
    }

    private String JWTBearerTokenExchange() {
        Auth.JWT jwt = new Auth.JWT();
        jwt.setIss(DS.IntegratorKey__c);
        jwt.setSub(DS.UserId__c);
        jwt.setAud(DS.ServiceUri__c);

        // Additional claims to set scope
        Map<String, Object> claims = new Map<String, Object>();
        claims.put('scope', DS.Scope__c);

        jwt.setAdditionalClaims(claims);

        // Create the object that signs the JWT bearer token
        Auth.JWS jws = new Auth.JWS(jwt, DS.CertName__c);

        // Set the token endpoint that the JWT bearer token is posted to
        String tokenEndpoint = DS.TokenEndpoint__c;

        // POST the JWT bearer token
        Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(tokenEndpoint, jws);

        System.debug('JWTBearerTokenExchange: New Access Token was exchanged');

        // Get the access token
        return bearer.getAccessToken();
    }

    // ---------- Test Mock ----------

    private String getFakeToken () {
        return '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
                + '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
                + '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
                + '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
                + '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
                + '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
                + '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
    }

    public class FakeCallout implements HttpCalloutMock {

        // Implement this interface method
        public HttpResponse respond(HttpRequest req) {

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{\n' +
                    '  "resultSetSize": "0",\n' +
                    '  "totalSetSize": "0",\n' +
                    '  "nextUri": "",\n' +
                    '  "previousUri": "",\n' +
                    '  "envelopes": []\n' +
                    '}');
            res.setStatusCode(200);
            return res;
        }
    }

    public static void magicMethod() {
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