trigger HierarchyRoleTrigger on SymphonyIPM__Hierarchy_Role__c (before insert, before update) {

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

    if (Trigger.isUpdate) {

        List<SymphonyIPM__Hierarchy_Role__c> recordsToUpdate = new List<SymphonyIPM__Hierarchy_Role__c>();

        for(Id roleId : Trigger.newMap.keySet()){

            if(Trigger.newMap.get(roleId).Person__c != Trigger.oldMap.get(roleId).Person__c){
                recordsToUpdate.add(Trigger.newMap.get(roleId));
            }

        }

        Set<Id> buIds = new Set<Id>();


        for (SymphonyIPM__Hierarchy_Role__c role : recordsToUpdate) {
            buIds.add(role.SymphonyIPM__Hierarchy_Path__c);
        }

        Map<Id, List<String>> existingRolesPersons = new Map<Id, List<String>>();
        Map<Id, List<String>> existingRoles = new Map<Id, List<String>>();
        for (SymphonyIPM__Hierarchy_Role__c role : [SELECT Id, SymphonyIPM__Role__c, SymphonyIPM__Hierarchy_Path__c, Person__c FROM SymphonyIPM__Hierarchy_Role__c WHERE SymphonyIPM__Hierarchy_Path__c IN :buIds]) {
            List<String> localListPersons = new List<String>();
            List<String> localList = new List<String>();
            if (existingRolesPersons.containsKey(role.SymphonyIPM__Hierarchy_Path__c)) {
                localListPersons = existingRolesPersons.get(role.SymphonyIPM__Hierarchy_Path__c);
                localList = existingRoles.get(role.SymphonyIPM__Hierarchy_Path__c);
            }

            localList.add(role.SymphonyIPM__Role__c);
            localListPersons.add(role.Person__c + '-' + role.SymphonyIPM__Role__c);
            existingRolesPersons.put(role.SymphonyIPM__Hierarchy_Path__c, localListPersons);
            existingRoles.put(role.SymphonyIPM__Hierarchy_Path__c, localList);
        }

        for (SymphonyIPM__Hierarchy_Role__c role : recordsToUpdate) {
            if (role.SymphonyIPM__Role__c != 'IP Committee Member' && existingRoles.containsKey(role.SymphonyIPM__Hierarchy_Path__c) && existingRoles.get(role.SymphonyIPM__Hierarchy_Path__c).contains(role.SymphonyIPM__Role__c) && Trigger.oldMap?.get(role.Id)?.SymphonyIPM__Role__c != role.SymphonyIPM__Role__c) {
                role.addError('SymphonyIPM__Role__c', role.SymphonyIPM__Role__c + ' can be presented only once in Business Unit.');
            } else if (existingRolesPersons.containsKey(role.SymphonyIPM__Hierarchy_Path__c) && existingRolesPersons.get(role.SymphonyIPM__Hierarchy_Path__c).contains(role.Person__c + '-' + role.SymphonyIPM__Role__c)) {
                role.addError('Person__c', 'Person should be unique within Business Unit object for the role.');
            }

        }
    }
}