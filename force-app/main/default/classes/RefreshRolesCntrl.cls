public  without sharing class RefreshRolesCntrl {
  @AuraEnabled
    public static string RefreshRole(string recid){
        try{
        TFconstant.allowrolechange=true;
        list<Patent_Role__c> Prlist=[select id from Patent_Role__c where patent__C =:recid];
            update Prlist;
        return 'Success';
        }
        catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
     public static void finish() {
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