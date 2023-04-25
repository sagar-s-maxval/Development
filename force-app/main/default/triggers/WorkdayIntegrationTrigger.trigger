// todo: rename to WorkdayIntegrationTrigger
trigger WorkdayIntegrationTrigger on Temp_Workday_Int__c (after insert, after update) {
    if(Trigger.isInsert || Trigger.isUpdate){
        WorkdayIntegrationTriggerHandler.insertUpdateUsers(Trigger.new);
    }
}