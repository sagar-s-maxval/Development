public class Keywordchunk implements Database.Batchable<sObject>{
    public List <SymphonyIPM__Keyword__c> keystopass = new List<SymphonyIPM__Keyword__c>();
     public List<SObject> start(Database.BatchableContext BC){
      return keystopass;
   }
     public Keywordchunk(List<SymphonyIPM__Keyword__c> keys){
   keystopass = keys;          
   }
     public void execute(Database.BatchableContext BC,List<sObject> scope){
         system.debug('record'+scope);
      for(sObject s : scope){
           update s;
                  }      
      update scope;
   }

   public void finish(Database.BatchableContext BC){

   }

}