//Added trigger//
trigger AdditionalInventorTrigger on SymphonyIPM__Additional_Inventor__c (before insert, before update, after insert, after update) {

    if (Trigger.isBefore) {
        AdditionalInventorTriggerHelper.beforeHandler(Trigger.new, Trigger.oldMap);
    } else {
        //Added by Syed - MVSL1364 - OPS12345//
        AdditionalInventorTriggerHelper.afterHandler(Trigger.new, Trigger.oldMap);
         AdditionalInventorTriggerHelper.populateinventors(Trigger.new);
         //ended by syed - MVSL1364 - OPS12345//
    }
}