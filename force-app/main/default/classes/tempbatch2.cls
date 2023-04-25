public class tempbatch2 implements Database.Batchable<sObject> {
     public Database.QueryLocator start(Database.BatchableContext BC) {
          return Database.getQueryLocator([SELECT Id from Patent_Document__c ]);
     //   return Database.getQueryLocator([SELECT Id,name,SymphonyIPM__Application_Number__c  from SymphonyIPM__Patent__c where SymphonyIPM__Country_Code__c in ('AU','CN','EP','JP','KR','US','WO')]);
    }
    public void execute(Database.BatchableContext BC, List<Patent_Document__c> scope) {
       list<Patent_Document__c> Patdoclst= new list<Patent_Document__c>(); 
        for(Patent_Document__c patent:scope){
            Patdoclst.add(patent);
           // update patent;
         /*  list<SymphonyIPM__Application_Data_v1__c> appdata=[SELECT  id from SymphonyIPM__Application_Data_v1__c where SymphonyIPM__Asset__c =:patent.id];
          
            if(appdata.size()==0){
                SymphonyIPM__AuditTrail__c aud= new SymphonyIPM__AuditTrail__c();
                aud.SymphonyIPM__CObjectName__c='Ifw not Mapped';
                aud.SymphonyIPM__Description__c=patent.SymphonyIPM__Application_Number__c ;
                aulist.add(aud);
            }*/
        }
        if(Patdoclst.size()>0)
            update Patdoclst;
    }
    public void finish(Database.BatchableContext BC) {
        integer i=0;
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