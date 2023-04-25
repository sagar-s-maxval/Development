public class PatentAssigneeTriggerHelper {

    public static void populateinventors(List<id> patids){
       //  Set<Id> PatIds = new Set<Id>();
      /*  for (Patent_Assignee__c Asspat : Asslist) {
            PatIds.add(Asspat.Patent__c);
        }*/
         Map<id,string> Assignmap = new Map<id,string>();
           Map<id,string> currrentAssignmap = new Map<id,string>();
        if(PatIds.size()>0){
             for(Patent_Assignee__c Assin:[select id,name,Patent__c,Entity__r.name,Is_Current_Assignee__c  from
            Patent_Assignee__c where Patent__c in:PatIds]){
                 string Assname='';
                 if(Assin.Is_Current_Assignee__c==true)
                 currrentAssignmap.put(Assin.Patent__c,Assin.Entity__r.name);
                if(Assignmap.containskey(Assin.Patent__c))
                     Assname=Assignmap.get(Assin.Patent__c)+','+Assin.Entity__r.name;
                else
                   Assname=Assin.Entity__r.name;
               Assignmap.put(Assin.Patent__c,Assname);
            }
        }
          list<SymphonyIPM__Patent__c> updatePat= new list<SymphonyIPM__Patent__c>();
        if(Assignmap.size()>0){
            for(SymphonyIPM__Patent__c Pat:[select id,Assignee_List__c from  SymphonyIPM__Patent__c where id in:Assignmap.keyset()]){
                   pat.Current_Assignee__c  =currrentAssignmap.get(Pat.id);
                   Pat.Assignee_List__c=Assignmap.get(Pat.id);                                  
                                   updatePat.add(Pat); }
         }
        if(updatePat.size()>0)
            update updatePat;
        
    }
}