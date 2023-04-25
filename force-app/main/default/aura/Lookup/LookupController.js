({
	itemSelected : function(component, event, helper) {
	    console.log('ITEM SELECTED');
		helper.itemSelected(component, event, helper);
	},

    serverCall :  function(component, event, helper) {
		helper.serverCall(component, event, helper);
	},

    clearSelection : function(component, event, helper){
        helper.clearSelection(component, event, helper);
    } 
})