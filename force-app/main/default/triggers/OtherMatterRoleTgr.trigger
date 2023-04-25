trigger OtherMatterRoleTgr on OM_Role__c (after insert,after update,after delete) {

if(trigger.isdelete){
OtherMatterRoleTriggerHelper.updatePermissionFields(Trigger.old);
}else{
 OtherMatterRoleTriggerHelper.updatePermissionFields(Trigger.new);
}

}