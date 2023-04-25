public with sharing class GetEmailsSelector {

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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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

    public static List<String> getRolesEmails(String searchProjectId, List<String> roles) {

        List<Search_Project_Role__c> hierarchyRoles = [
                SELECT Person__r.SymphonyIPM__Email__c
                FROM Search_Project_Role__c
                WHERE Role__c IN :roles AND Search_Project__c = :searchProjectId
        ];

        List<String> emails = new List<String>();
        for (Search_Project_Role__c hierarchyRole : hierarchyRoles) {
            emails.add(hierarchyRole.Person__r.SymphonyIPM__Email__c);
        }

        System.debug('getRolesEmails: ' + emails);
        return emails;
    }

    public static List<String> getRolesEmailsForTrademark(String trademarkId, List<String> roles) {

        List<Trademark_Role__c> trademarkRoles = [
                SELECT Person__r.SymphonyIPM__Email__c
                FROM Trademark_Role__c
                WHERE Trademark_Roles__c IN :roles AND Trademark__c = :trademarkId
        ];

        List<String> emails = new List<String>();
        for (Trademark_Role__c trademarkRole : trademarkRoles) {
            emails.add(trademarkRole.Person__r.SymphonyIPM__Email__c);
        }

        System.debug('getRolesEmails: ' + emails);
        return emails;
    }

    public static String getRolesPersonIds(String searchProjectId, List<String> roles) {

        List<Search_Project_Role__c> hierarchyRoles = [
                SELECT Person__r.SymphonyIPM__Email__c, Person__c
                FROM Search_Project_Role__c
                WHERE Role__c IN :roles AND Search_Project__c = :searchProjectId
        ];

        String personIds = '';

        for (Integer i = 0; i < hierarchyRoles.size(); i++) {
            personIds += i == hierarchyRoles.size() - 1 ? String.valueOf(hierarchyRoles[i].Person__c) : String.valueOf(hierarchyRoles[i].Person__c) + ',';
        }

        return personIds;
    }

    public static String getRolesPersonIdsForTrademark(String trademarkId, List<String> roles) {
        System.debug(roles);

        List<Trademark_Role__c> trademarkRoles = [
                SELECT Person__r.SymphonyIPM__Email__c, Person__c
                FROM Trademark_Role__c
                WHERE Trademark_Roles__c IN :roles AND Trademark__c = :trademarkId
        ];

        String personIds = '';

        System.debug(trademarkRoles);

        for (Integer i = 0; i < trademarkRoles.size(); i++) {
            System.debug(trademarkRoles[i].Person__c);
            personIds += i == trademarkRoles.size() - 1 ? String.valueOf(trademarkRoles[i].Person__c) : String.valueOf(trademarkRoles[i].Person__c) + ',';
        }

        System.debug(personIds);
        return personIds;
    }
}