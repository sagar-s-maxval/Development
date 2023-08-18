trigger CreatePrcTask on SymphonyIPM__PRC_Meeting_Details__c (after insert) {
 if(trigger.isInsert && Trigger.isAfter){
        CreatePrcTaskwithReviewer_Handler obj = new CreatePrcTaskwithReviewer_Handler();
        obj.CreateTask(trigger.new);
    }
}