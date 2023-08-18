public class HRIntegration {
    
    public string CLIENT_ID {get;set;}
    public string CLIENT_SECRET {get;set;}
    public string APIEndPoint {get;set;}
    public string APIEndPointForEmployeeDetails {get;set;}
    public string APIEndPointForEmployeeIds {get;set;}
    public static String accesstoken{get;set;}
  public HRIntegration(){
        String prerequisite = 'Prerequisites';
        String EmployeeDetailsAPI = 'EmployeeDetailsAPI';
        String EmployeeIdsAPI ='EmployeeIdsAPI';
        if(Schema.sObjectType.HRIntegration__c.isAccessible()) {
            if(Schema.sObjectType.HRIntegration__c.fields.Client_ID__c.isAccessible() && Schema.sObjectType.HRIntegration__c.fields.Client_ID__c.isUpdateable())
            {
                CLIENT_ID = HRIntegration__c.getInstance(prerequisite).Client_ID__c;
            }
            if(Schema.sObjectType.HRIntegration__c.fields.Client_Secret__c.isAccessible() && Schema.sObjectType.HRIntegration__c.fields.Client_Secret__c.isUpdateable())
            {
                CLIENT_SECRET = HRIntegration__c.getInstance(prerequisite).Client_Secret__c;
            }
            if(Schema.sObjectType.HRIntegration__c.fields.API_URL__c.isAccessible() && Schema.sObjectType.HRIntegration__c.fields.API_URL__c.isUpdateable())
            {
                APIEndPoint = HRIntegration__c.getInstance(prerequisite).API_URL__c;
                APIEndPointForEmployeeDetails = HRIntegration__c.getInstance(EmployeeDetailsAPI).API_URL__c;
                APIEndPointForEmployeeIds = HRIntegration__c.getInstance(EmployeeIdsAPI).API_URL__c;
            }    
        }
    }
  public String getOAuthToken()
    {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setHeader('Cookie','TS010aed22=01f6cec0f5d227bf220fceec27c4521fb8a87d51131c64cf1b04b57bda9bc7d7522e61a96cc2255c9fce49038717b6fb67e37a50cc');
        req.setEndpoint(APIEndPoint);
        req.setBody('grant_type=client_credentials&client_id='+ CLIENT_ID +'&client_secret='+ CLIENT_SECRET);
        System.debug('Request Body'+req.getBody());
        Http h = new Http();
        HTTPResponse response = h.send(req);
        if(response.getStatusCode() == 200)
        {
            System.debug('Successfully retrieved access token');
            System.debug('Body ' + response.getBody());
            Map<string,Object> resultMap = (map<string,Object>)JSON.deserializeUntyped(response.getBody());
               accesstoken = (String)resultMap.get('access_token'); 
              //instanceURL = (String)resultMap.get('instance_url'); 
        }
        else{
             System.debug('## Could not retrieve the access token' ); 
             System.debug('## Response Status :' + response.getStatus()); 
             System.debug('## Response Message :' + response.getBody());
             System.debug('Status code ' + response.getStatusCode());
        }   
        return accesstoken;
    }
    public List<String> getAllEmployeesIDS(String accesstoken)
    {
        //String accesstoken =getOAuthToken();
        //String EmployeeIds;
        List<List<String>> result = new List<List<String>>();
        List<String> empIdsLst=new List<String>();
       //------------------------------------------------------------------------- 
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(APIEndPointForEmployeeIds);
        req.setHeader('Authorization','Bearer ' + accessToken);
        HttpResponse res = h.send(req);
        System.debug('Response final'+res.getBody());
        if(res.getStatusCode() == 200) {
            System.debug('Successfully retrieved Employee Ids');
            System.debug('[Body]' + res.getBody()); 
            empIdsLst = (List<String>)JSON.deserialize(res.getBody(), List<String>.class);
            System.debug('[Emp Size]' + empIdsLst.size());
        } else {
                System.debug('## Could not retrieve Employee Ids' ); 
                System.debug('## Response Status :' + res.getStatus()); 
                System.debug('## Response Message :' + res.getBody());
                System.debug('Status code ' + res.getStatusCode());
            }  
       //HRIntegrationBatch hrBatch =new HRIntegrationBatch(result);
       System.debug('result'+result);
       return empIdsLst;
     }
    
    public List<WrapperEmployees> getEmployeeDetails(String accesstoken ,List<String> empIdsLst)
    {
        String strAuditTrailLogText;
        List<WrapperEmployees> employeeLst =new List<WrapperEmployees>();
        try{
            String requestbody=JSON.serialize(empIdsLst);
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(APIEndPointForEmployeeDetails);
            req.setHeader('Authorization','Bearer ' + accessToken);
            req.setBody(requestbody);
            HttpResponse res = h.send(req);
            //strAuditTrailLogText+=strAuditTrailLogText+'Response final'+res.getBody(); 
            employeeLst =(List<WrapperEmployees>)System.JSON.deserialize(res.getBody(), List<WrapperEmployees>.class);
            strAuditTrailLogText+=strAuditTrailLogText+'Response final'+employeeLst; 
            System.debug('Response JSON'+employeeLst.size());
            System.debug('Response JSON'+employeeLst);
        }
     catch(Exception e)
    {
        //strStatus = 'Fail';
        strAuditTrailLogText += '[CatchBlock:' + e.getMessage() + ' | ' +  e.getStackTraceString() + ' ]';
    }
    finally
    {
       
        SymphonyIPM__AuditTrail__c objAuditTrail = new SymphonyIPM__AuditTrail__c();
        strAuditTrailLogText += '[Finally]';
        objAuditTrail = new SymphonyIPM__AuditTrail__c();
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Action__c.isCreateable())
            objAuditTrail.SymphonyIPM__Action__c = 'Insert';
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__CObjectName__c.isCreateable())
            objAuditTrail.SymphonyIPM__CObjectName__c = 'HR BATCH - Integration';
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Description__c.isCreateable())
            objAuditTrail.SymphonyIPM__Description__c = strAuditTrailLogText ;
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Status__c.isCreateable())
            objAuditTrail.SymphonyIPM__Status__c = 'Success';
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.isCreateable() && SymphonyIPM__AuditTrail__c.sObjectType.getDescribe().isCreateable())
            INSERT objAuditTrail;     
    }
        return employeeLst;
     }

    public class WrapperEmployees{    
    public String dn;   //CN=jhagenko,CN=Users,DC=ms,DC=ds,DC=uhc,DC=com
    public String msid; //jhagenko
    public String firstName;    //Jill
    public String middleName;   //M
    public String lastName; //Hagenkord
    public String employeeId;   //001566917
    public String mail; //jill.hagenkord@optum.com
    public String activeStatus; //Active
    public String managerDN;    //CN=nseddon,CN=Users,DC=ms,DC=ds,DC=uhc,DC=com
    public String externalSegment;  //Optum Corporate
    public String externalSegmentCode;  //490
    public String internalSegment;  //Optum Corporate
    public String internalSegmentCode;  //490
    public String mailCode; //CA960-1000
    public String division; //Optum Corporate Strategy
    public String divisionCode; //52145
    public String marketGroup;  //Optum
    public String marketGroupCode;  //200
    public String business; //Optum Corporate
    public String businessCode; //121
    public string managers;    
    public String department;   //781520
    public String displayName;  //Hagenkord, Jill M
    public String businessUnit; //44310
    public String operatingUnit;    //08805
    public String title;    //NA Med Dir/CMO
    public String employeeType; //Employee
    public String streetAddresss;   //PO BOX 9472
    public String location; //Minneapolis
    public String state;    //MN
    public String country;  //USA
    public String postalCode;   //55440-9472
    public String telephoneNumber;  //+1(952) 205-7057   
    public String glLocation;   //USAMN051
    public String additionalInfo1;  //
    public String additionalInfo2;  //
    public String additionalInfo3;  //
    }
    
}