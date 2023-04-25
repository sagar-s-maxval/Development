public with sharing class HierarchyRoleSelector {
    public static List<SymphonyIPM__Hierarchy_Role__c> getRolesByHierarchyId(Id hId){
        return [ 
                SELECT Id, Person__c
                FROM SymphonyIPM__Hierarchy_Role__c
                WHERE Function_Role__c != NULL AND
                SymphonyIPM__Hierarchy_Path__c = :hId
        ]; 
    }
}