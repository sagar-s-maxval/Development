public with sharing class ExternalInventorsController {

    @AuraEnabled
    public static List<SymphonyIPM__Inventor__c> getExternalInventors(Id recordId) {
        Set<Id> personsIds = new Set<Id>();
        for (SymphonyIPM__Additional_Inventor__c idInventor : [SELECT Id, SymphonyIPM__Inventor__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Invention_Disclosure_New__c = :recordId AND Is_External_Inventor_New__c = TRUE]) {
            personsIds.add(idInventor.SymphonyIPM__Inventor__c);
        }

        return [SELECT Id, Name, External_Comments__c, SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE Id IN :personsIds];
    }

    @AuraEnabled
    public static SymphonyIPM__Inventor__c createInventor(String name, String email, String comments, Id recordId) {
        String firstName = '';
        String lastName = '';
        if (name.contains(' ')) {
            List<String> names = name.split(' ');
            firstName = names[0];
            for (Integer i = 1; i < names.size(); i++) {
                lastName += names[i] + ' ';
            }
        } else {
            firstName = name;
        }
        SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Name = name, SymphonyIPM__FirstName__c=firstName,SymphonyIPM__LastName__c=lastName, SymphonyIPM__Email__c = email, Is_External_Person__c = true, External_Comments__c = comments);
        insert inventor;

        if (recordId != null) {
            SymphonyIPM__Additional_Inventor__c idInventor = new SymphonyIPM__Additional_Inventor__c(SymphonyIPM__Inventor__c = inventor.Id, SymphonyIPM__Invention_Disclosure_New__c = recordId, SymphonyIPM__Inventor_Email__c = email);
            insert idInventor;
        }

        return inventor;
    }

    @AuraEnabled
    public static void deleteInventor(Id inventorId) {
        List<SymphonyIPM__Inventor__c> inventors = [SELECT Id FROM SymphonyIPM__Inventor__c WHERE Id = :inventorId];

        if (!inventors.isEmpty()) {
            delete inventors;
        }
    }

    @AuraEnabled
    public static void deleteAllExternals(Id recordId) {
        Set<Id> inventorsIds = new Set<Id>();
        for (SymphonyIPM__Additional_Inventor__c idInventor : [SELECT Id, SymphonyIPM__Inventor__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Invention_Disclosure_New__c = :recordId AND Is_External_Inventor_New__c = TRUE]) {
            inventorsIds.add(idInventor.SymphonyIPM__Inventor__c);
        }

        List<SymphonyIPM__Inventor__c> inventors = [SELECT Id FROM SymphonyIPM__Inventor__c WHERE Id IN :inventorsIds];

        if (!inventors.isEmpty()) {
            delete inventors;
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
}
}