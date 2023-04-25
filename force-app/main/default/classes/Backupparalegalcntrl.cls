public class Backupparalegalcntrl {
@AuraEnabled
    public static string getHiearchySettings(){
       // return BackupParalegal__c.getInstance();
         return [ SELECT  DeveloperName,data__c FROM Home_page_Notice__mdt
                        WHERE MasterLabel='BackupParalegal'].data__c; 
    }
    @AuraEnabled
     public static void savedata(string str){
        Map<String, Object> mapData = new Map<String, Object>();
        mapData.put('data__C',str);
        metadataInsertUpdate.handleInsertAndUpdate('Home_page_Notice__mdt.BackupParalegal', 'BackupParalegal', mapData);
   
    }
}