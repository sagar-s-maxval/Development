trigger SharePRCwithReviewer on SymphonyIPM__PRC_Meeting__c (after insert) {
 if(trigger.isInsert && Trigger.isAfter){
        SharePRCwithReviewer_Handler obj = new SharePRCwithReviewer_Handler();
        obj.SharingPRC(trigger.new);
    }
}