trigger DocketActivityTrigger on SymphonyIPM__Docketing_Activity_v2__c (after update) {

    Set<Id> activitiesIds = new Set<Id>();

    for (SymphonyIPM__Docketing_Activity_v2__c activity : Trigger.new) {
        if (activity.File_sIDS_in_pending_related_US_cases__c && !Trigger.oldMap.get(activity.Id).File_sIDS_in_pending_related_US_cases__c) {
            activitiesIds.add(activity.Id);
        }
    }

    PatentService.createSIDSDocketActivityManually(activitiesIds);
}