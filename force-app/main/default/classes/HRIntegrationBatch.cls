public class HRIntegrationBatch implements Database.Batchable<sobject>,Database.Stateful,Database.AllowsCallouts { 
    public List<String> EmployeeIdsList{get;set;}
    public Database.QueryLocator start(Database.BatchableContext BC)
      {                        
          return Database.getQueryLocator('SELECT Name,API_URL__c,Client_ID__c,Client_Secret__c FROM HRIntegration__c');
   	  } 
    public void execute(Database.BatchableContext BC,List<sobject> TokenCredentials) {
        HRIntegration hr=new HRIntegration();
        String accesstoken=hr.getOAuthToken();
        EmployeeIdsList=hr.getAllEmployeesIDS(accesstoken); 
    }

    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        HRFeedbatchClass hrBatch = new HRFeedbatchClass(EmployeeIdsList);
        Database.executeBatch(hrBatch,1);
    }  
    

}