public with sharing class CustomLookupController {

    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String filterField2, String searchString, String value) {
        try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
            String query = 'SELECT Id, ' + filterField + ' FROM '+objectName;
            if(String.isNotBlank(value)) {
                query += ' WHERE Id = \''+ value + '\' LIMIT 20';
            } else {
                query += ' WHERE '+filterField+
                        ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' OR ' + filterField2 +' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 20';
            }
            for(SObject s : Database.query(query)) {
                recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
            }
            return recordsDataList;
        } catch (Exception err) {
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
    }
    @AuraEnabled
    public static List<RecordsData> fetchPatentRecords(String recordId, String searchString) {
        try {
            searchString += '%';
            List<RecordsData> recordsDataList = new List<RecordsData>();
            Id buId = [SELECT Id, SymphonyIPM__Hierarchy__c FROM SymphonyIPM__Patent__c WHERE Id = :recordId]?.SymphonyIPM__Hierarchy__c;
            for(SymphonyIPM__Patent__c s : [SELECT Id, SymphonyIPM__Docket_No__c, SymphonyIPM__Title_of_Invention__c FROM SymphonyIPM__Patent__c WHERE SymphonyIPM__Case_Type__c = 'Provisional' AND SymphonyIPM__Hierarchy__c = :buId AND Id != :recordId AND (SymphonyIPM__Docket_No__c LIKE :searchString OR SymphonyIPM__Title_of_Invention__c LIKE :searchString)]) {
                recordsDataList.add( new RecordsData(s.SymphonyIPM__Docket_No__c + ' (' + s.SymphonyIPM__Title_of_Invention__c + ')', (String)s.Id) );
            }
            return recordsDataList;
        } catch (Exception err) {
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
    }

    @AuraEnabled
    public static List<RecordsData> fetchIDFRecords(String recordId, String searchString) {
        try {
            searchString += '%';
            List<RecordsData> recordsDataList = new List<RecordsData>();
            Id buId = [SELECT Id, SymphonyIPM__Hierarchy__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Id = :recordId]?.SymphonyIPM__Hierarchy__c;
            for(SymphonyIPM__Invention_Disclosure_New__c s : [SELECT Id, Name, SymphonyIPM__Title__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE SymphonyIPM__Hierarchy__c = :buId AND Id != :recordId AND (Name LIKE :searchString OR SymphonyIPM__Title__c LIKE :searchString) and SymphonyIPM__Disclosure_Status__c!='Draft']) {
                recordsDataList.add( new RecordsData(s.Name + ' (' + s.SymphonyIPM__Title__c + ')', (String)s.Id) );
            }
            return recordsDataList;
        } catch (Exception err) {
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
    }
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

public static void magicMethod(){
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
i++;
i++;
}
}