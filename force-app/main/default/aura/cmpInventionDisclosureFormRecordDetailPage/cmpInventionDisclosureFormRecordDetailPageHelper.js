({
	helperMethod : function(component,recid)
    {
		var action = component.get('c.GetRecordDetails');
        action.setParams
        ({
            IDFRecordId : recid
        });
        action.setCallback
        (
        	this,
            $A.getCallback
            (
            	function(response)
                {
                    var state = response.getState();
                    var result = response.getReturnValue();
                    if(state == 'SUCCESS')
                    {
                        component.set("v.wrapperRecordDetails",result);
                    }
                    else if(state == 'ERROR')
                    {
                        alert(JSON.stringify(errors));
                    }
                }
            )
        );
        $A.enqueueAction(action);
	}
})