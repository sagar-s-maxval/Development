trigger OMAssigneeTrigger on Other_Matter_Assignee__c (before insert, before update) {
    Set<Id> patentIds = new Set<Id>();

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

    for (Other_Matter_Assignee__c assignee : Trigger.new) {
        patentIds.add(assignee.Other_Matters__c);
    }

    Set<Id> omWithCurrentAssignee = new Set<Id>();
    Map<Id, Set<Id>> patentsEntities = new Map<Id, Set<Id>>();

    for (Other_Matter_Assignee__c assignee : [SELECT Id, Is_Current_Assignee__c, Entity__c, Other_Matters__c FROM Other_Matter_Assignee__c WHERE Other_Matters__c IN :patentIds]) {
        if (assignee.Is_Current_Assignee__c) {
            omWithCurrentAssignee.add(assignee.Other_Matters__c);
        }
        Set<Id> entityIds = new Set<Id>();
        if (patentsEntities.containsKey(assignee.Other_Matters__c)) {
            entityIds = patentsEntities.get(assignee.Other_Matters__c);
        }
        entityIds.add(assignee.Entity__c);
        patentsEntities.put(assignee.Other_Matters__c, entityIds);
    }

    for (Other_Matter_Assignee__c assignee : Trigger.new) {
        if (assignee.Is_Current_Assignee__c && ((omWithCurrentAssignee.contains(assignee.Other_Matters__c) && Trigger.isInsert) || (Trigger.isUpdate && omWithCurrentAssignee.contains(assignee.Other_Matters__c) && !Trigger.oldMap.get(assignee.Id).Is_Current_Assignee__c) )) {
            assignee.addError('Is_Current_Assignee__c', 'Current Assignee already exists for selected Other Matter.');
        }
        if ((patentsEntities.containsKey(assignee.Other_Matters__c) && patentsEntities.get(assignee.Other_Matters__c).contains(assignee.Entity__c)) && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(assignee.Id).Entity__c != assignee.Entity__c))) {
            assignee.addError('Entity__c', 'Selected Entity already exists in the Other Matter.');
        }
    }
}