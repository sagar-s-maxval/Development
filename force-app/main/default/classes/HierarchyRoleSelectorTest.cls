@IsTest
public with sharing class HierarchyRoleSelectorTest {
    @TestSetup
    static void setup() {
        SymphonyIPM__Hierarchy__c hierarchy = new SymphonyIPM__Hierarchy__c(Name = 'test');
        insert hierarchy;

        insert new SymphonyIPM__Hierarchy_Role__c(Function_Role__c = 'Director R&D', SymphonyIPM__Hierarchy_Path__c = hierarchy.Id);
    }

    @IsTest
    static void testGetRolesByHierarchyId() {
        SymphonyIPM__Hierarchy__c hierarchy = [SELECT Id FROM SymphonyIPM__Hierarchy__c];

        List<SymphonyIPM__Hierarchy_Role__c> hierarchyRoles = HierarchyRoleSelector.getRolesByHierarchyId(hierarchy.Id);
        System.assert(!hierarchyRoles.isEmpty());
    }

}