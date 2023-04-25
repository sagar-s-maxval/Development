//Adding comment//
trigger AssetRatingtrigger on SymphonyIPM__IDF_Review__c (after insert,after update,after delete) {

    if(Trigger.isInsert || Trigger.isUpdate){
        AssetRatingtriggerHelper.updateRatingField(Trigger.new);
    }else if(Trigger.isDelete){
         AssetRatingtriggerHelper.updateRatingField(Trigger.old);
    }
    
    
}