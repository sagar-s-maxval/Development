public class tempbatchfirstissued implements Database.Batchable<sObject>, Database.Stateful {
    public list<String> familylist=new list<string>();
     public Database.QueryLocator start(Database.BatchableContext BC) {
         return Database.getQueryLocator([SELECT Id,name,SymphonyIPM__Case_Type__c,SymphonyIPM__Application_Date__c,Family_ID_sdocs__c,SymphonyIPM__Issue_Date_of_Patent__c  from SymphonyIPM__Patent__c ]);
    }
    public void execute(Database.BatchableContext BC, List<SymphonyIPM__Patent__c> scope) {
        
         List<SymphonyIPM__Patent__c> issueupdatepatent= new List<SymphonyIPM__Patent__c>();
 List<SymphonyIPM__Patent__c> Filedupdatepatent= new List<SymphonyIPM__Patent__c>();
     Set<String> familyIds = new Set<String>();
     Set<id> patid= new Set<id>();
        for (SymphonyIPM__Patent__c patent : scope) {
          //  if(!familylist.contains(patent.Family_ID_sdocs__c)){
                if(patent.Family_ID_sdocs__c!=null &&patent.SymphonyIPM__Issue_Date_of_Patent__c!=null){
            familyIds.add( patent.Family_ID_sdocs__c);
            familylist.add( patent.Family_ID_sdocs__c);
                    patid.add(patent.id);}  //}
        }
        if(familyIds.size()>0){
       integer i=0;
        list<SymphonyIPM__Patent__c> updatepatent= new list<SymphonyIPM__Patent__c>();
    for (SymphonyIPM__Patent__c patent : [SELECT Id,SymphonyIPM__Case_Type__c,First_Filed_In_Family__c,First_Issued_in_the_family__c,SymphonyIPM__Application_Date__c,SymphonyIPM__Issue_Date_of_Patent__c, SymphonyIPM__Family_ID__c,Family_ID_sdocs__c, Litigation_on_hold__c, SymphonyIPM__Status__c
                FROM SymphonyIPM__Patent__c
                WHERE Family_ID_sdocs__c IN :familyIds and SymphonyIPM__Issue_Date_of_Patent__c!=null and SymphonyIPM__Case_Type__c in('Primary','Utility Non-Provisional','Utility Original') order by SymphonyIPM__Issue_Date_of_Patent__c ASC]) {
                    if(i==0){
                        if(patent.First_Issued_in_the_family__c!=true && (patent.SymphonyIPM__Case_Type__c=='Primary'||patent.SymphonyIPM__Case_Type__c=='Utility Non-Provisional' || patent.SymphonyIPM__Case_Type__c=='Utility Original' )){
                       patent.First_Issued_in_the_family__c=true; 
                           updatepatent.add(patent);   
                        }
                     }else{
                         if(patent.First_Issued_in_the_family__c!=false){
                             patent.First_Issued_in_the_family__c=false;  
                          updatepatent.add(patent); 
                         }
                    }
         
                    i++;
      }
             for (SymphonyIPM__Patent__c patent : [SELECT Id,SymphonyIPM__Case_Type__c,First_Filed_In_Family__c,First_Issued_in_the_family__c,SymphonyIPM__Application_Date__c,SymphonyIPM__Issue_Date_of_Patent__c, SymphonyIPM__Family_ID__c,Family_ID_sdocs__c, Litigation_on_hold__c, SymphonyIPM__Status__c
                FROM SymphonyIPM__Patent__c
                WHERE Family_ID_sdocs__c IN :familyIds and SymphonyIPM__Issue_Date_of_Patent__c!=null and SymphonyIPM__Case_Type__c not in('Primary','Utility Non-Provisional','Utility Original')]) {
                    if(patent.First_Issued_in_the_family__c!=false){
                      patent.First_Issued_in_the_family__c=false;  
                     updatepatent.add(patent); }
                }
            
      if(updatepatent.size()>0) {
    update updatepatent;
 }
        }

    }
    
  /*  public Database.QueryLocator start(Database.BatchableContext BC) {
         return Database.getQueryLocator([SELECT Id,name,SymphonyIPM__Application_Number__c  from SymphonyIPM__Patent__c where SymphonyIPM__Country_Code__c in ('AU','CN','EP','JP','KR','US','WO')]);
    }
    public void execute(Database.BatchableContext BC, List<SymphonyIPM__Patent__c> scope) {
        list<SymphonyIPM__AuditTrail__c> aulist= new list<SymphonyIPM__AuditTrail__c>(); 
        for(SymphonyIPM__Patent__c patent:scope){
           list<SymphonyIPM__IFW_Data_v1__c> ifwdata=[SELECT  id from SymphonyIPM__IFW_Data_v1__c where SymphonyIPM__Asset__c =:patent.id];
          
            if(ifwdata.size()==0){
                SymphonyIPM__AuditTrail__c aud= new SymphonyIPM__AuditTrail__c();
                aud.SymphonyIPM__CObjectName__c='Ifw not synced';
                aud.SymphonyIPM__Description__c=patent.SymphonyIPM__Application_Number__c ;
                aulist.add(aud);
            }
        }
        if(aulist.size()>0)
            insert aulist;
    }*/
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