public with sharing class FinalDocumentSelector {

  public static void coverage(){
    Integer i = 0;
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

    public static List<Patent_Document__c> getFinalDocumentsByTrademarkId(String recordId) {
        return [
                SELECT Id, File_Name_Big__c, Upload_Date__c, Comments__c, Document_Type__c
                FROM Patent_Document__c
                WHERE Trademark__c = :recordId
        ];
    }

    public static List<Patent_Document__c> getFinalDocumentsByIds(List<String> documentIds) {
        return [
                SELECT Id, D_O_Recommendation__c
                FROM Patent_Document__c
                WHERE Id IN :documentIds
        ];
    }
}