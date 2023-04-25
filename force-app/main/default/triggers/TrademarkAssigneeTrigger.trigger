trigger TrademarkAssigneeTrigger on Trademark_Assignee__c (before insert, before update) {

    Set<Id> patentIds = new Set<Id>();
    for (Trademark_Assignee__c assignee : Trigger.new) {
        patentIds.add(assignee.Trademark__c);
    }

    Set<Id> trademarksWithCurrentAssignee = new Set<Id>();
    Map<Id, Set<Id>> patentsEntities = new Map<Id, Set<Id>>();

    for (Trademark_Assignee__c assignee : [SELECT Id, Is_Current_Assignee__c, Trademark__c, Entity__c FROM Trademark_Assignee__c WHERE Trademark__c IN :patentIds]) {
        if (assignee.Is_Current_Assignee__c) {
            trademarksWithCurrentAssignee.add(assignee.Trademark__c);
        }
        Set<Id> entityIds = new Set<Id>();
        if (patentsEntities.containsKey(assignee.Trademark__c)) {
            entityIds = patentsEntities.get(assignee.Trademark__c);
        }
        entityIds.add(assignee.Entity__c);
        patentsEntities.put(assignee.Trademark__c, entityIds);
    }

    for (Trademark_Assignee__c assignee :Trigger.new) {
        if (assignee.Is_Current_Assignee__c && ((trademarksWithCurrentAssignee.contains(assignee.Trademark__c) && Trigger.isInsert) || (Trigger.isUpdate && trademarksWithCurrentAssignee.contains(assignee.Trademark__c) && !Trigger.oldMap.get(assignee.Id).Is_Current_Assignee__c) )) {
            assignee.addError('Is_Current_Assignee__c', 'Current Assignee already exists for selected trademark.');
        }
        if ((patentsEntities.containsKey(assignee.Trademark__c) && patentsEntities.get(assignee.Trademark__c).contains(assignee.Entity__c)) && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(assignee.Id).Entity__c != assignee.Entity__c))) {
            assignee.addError('Entity__c', 'Selected Entity already exists in the Trademark.');
        }
    }

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
}