trigger PatentAssigneeTrigger on Patent_Assignee__c (before insert, before update) {

    Set<Id> patentIds = new Set<Id>();
    for (Patent_Assignee__c assignee : Trigger.new) {
        patentIds.add(assignee.Patent__c);
    }

    Set<Id> patentsWithCurrentAssignee = new Set<Id>();
    Map<Id, Set<Id>> patentsEntities = new Map<Id, Set<Id>>();

    for (Patent_Assignee__c assignee : [SELECT Id, Is_Current_Assignee__c, Entity__c, Patent__c FROM Patent_Assignee__c WHERE Patent__c IN :patentIds]) {
        if (assignee.Is_Current_Assignee__c) {
            patentsWithCurrentAssignee.add(assignee.Patent__c);
        }
        Set<Id> entityIds = new Set<Id>();
        if (patentsEntities.containsKey(assignee.Patent__c)) {
            entityIds = patentsEntities.get(assignee.Patent__c);
        }
        entityIds.add(assignee.Entity__c);
        patentsEntities.put(assignee.Patent__c, entityIds);
    }

    for (Patent_Assignee__c assignee :Trigger.new) {
        if (assignee.Is_Current_Assignee__c && ((patentsWithCurrentAssignee.contains(assignee.Patent__c) && Trigger.isInsert) || (Trigger.isUpdate && patentsWithCurrentAssignee.contains(assignee.Patent__c) && !Trigger.oldMap.get(assignee.Id).Is_Current_Assignee__c) )) {
            assignee.addError('Is_Current_Assignee__c', 'Current Assignee already exists for selected Patent.');
        }
        if ((patentsEntities.containsKey(assignee.Patent__c) && patentsEntities.get(assignee.Patent__c).contains(assignee.Entity__c)) && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(assignee.Id).Entity__c != assignee.Entity__c))) {
            assignee.addError('Entity__c', 'Selected Entity already exists in the Patent.');
        }
    }
}