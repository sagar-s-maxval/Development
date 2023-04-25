public class NoticeOnHomepageCntrl {

    @AuraEnabled
    public static string  getconfidentilaitynotice(){
        return [ SELECT  DeveloperName,data__c FROM Home_page_Notice__mdt
                        WHERE DeveloperName='Confidentiality_Notice'].Data__c; 
    }
     @AuraEnabled
    public static string  getPrivaynotice(){
        return [ SELECT  DeveloperName,data__c FROM Home_page_Notice__mdt
                        WHERE DeveloperName='Privacy_Note'].Data__c; 
    }
  @AuraEnabled
    public static void savedataCNnotice(string str){
        
        Map<String, Object> mapData = new Map<String, Object>();
        mapData.put('data__C',str);
        metadataInsertUpdate.handleInsertAndUpdate('Home_page_Notice__mdt.Confidentiality_Notice', 'Confidentiality_Notice', mapData);
    }  
    @AuraEnabled
    public static void savedataPrivacynotice(string str){
        
        Map<String, Object> mapData = new Map<String, Object>();
        mapData.put('data__C',str);
        metadataInsertUpdate.handleInsertAndUpdate('Home_page_Notice__mdt.Privacy_Note', 'Privacy_Note', mapData);
    }  
}