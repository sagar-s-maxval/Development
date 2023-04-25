public class RefreshDashboardController
{   @auraEnabled
    public static String refreshDashboardcont(String dashboardName){
         try{
                     
            RefreshDashboardController.refreshDashboard(dashboardName);
            List<AsyncApexJob> futureCalls = [Select Id, CreatedById, CreatedBy.Name, ApexClassId,MethodName,Status from AsyncApexJob where JobType = 'future' AND MethodName ='refreshDashboard' AND CreatedById = : UserInfo.getUserId() Order by CreatedDate desc limit 1];
            return futureCalls[0].Id;
        }
        catch(Exception e){
            System.debug(e.getMessage() + '--' + e.getStackTraceString());
            return e.getMessage() + '--' + e.getStackTraceString();
        }
   
    }
    @future(callout=true)
    public static void refreshDashboard(String developername){
            
            List<Dashboard> lstDashboard=[SELECT Id,Title FROM Dashboard WHERE Title = : developername ];

            if(!lstDashboard.isEmpty()){
                RefreshDashboardController.putRequest(lstDashboard[0].Id);
            }
            
    }
    
     public static String getRequest(Id dashboardId){
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(System.URL.getSalesforceBaseURL().toExternalForm()+'/services/data/v31.0/analytics/dashboards/'+dashboardId);
        req.setMethod('PUT');
        req.setBody('{"Id":"'+dashboardId+'","runningUser":"'+Userinfo.getUserId()+'"}');
        req.setHeader('Authorization', 'OAuth ' +UserInfo.getSessionId());

        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        /*Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        List<Object> items = (List<Object>)root.get('componentStatus');
        for (Object item : items) {
            Map<String, Object> i = (Map<String, Object>)item;
            System.debug(i.get('refreshDate'));
        }*/
        
        return res.getBody();
    }
    
    public static void putRequest(Id dashboardId){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(System.URL.getSalesforceBaseURL().toExternalForm()+'/services/data/v31.0/analytics/dashboards/'+dashboardId);
        req.setMethod('PUT');
        req.setBody('{"Id":"'+dashboardId+'","runningUser":"'+Userinfo.getUserId()+'"}');
        req.setHeader('Authorization', 'OAuth ' +UserInfo.getSessionId());

        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
    }
}