({
	getLawfirms : function(component) {
		var action = component.get('c.getLawfirms');
        action.setCallback
        (
            this, 
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    if (state === "SUCCESS") 
                    {
                        component.set('v.optLawfirms', response.getReturnValue());
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
	},
    getOCs : function(component, SelectedLawifmrId) {
        //alert('MySelection:' + SelectedLawifmrId);
        var lawfirm = component.get("v.selectedLawfirm");
        var action = component.get('c.getOCs');
        action.setParams({
        	LawfirmId : lawfirm
    	});

        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    if (state === "SUCCESS") 
                    { console.log('Process recs'+JSON.stringify(response.getReturnValue()));
                        component.set('v.optOCs', response.getReturnValue());
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
	},

    getLawfirmList : function(component){
        var SelectedLawfirmId = component.get("v.selectedConfirmLawfirm");
        if(SelectedLawfirmId != null && SelectedLawfirmId != ''){
            //alert('Selected LawFirm----->'+SelectedLawfirmId);
            var action = component.get('c.getLawfirms');
            action.setParams({ LawFirmSupportType : SelectedLawfirmId });
            action.setCallback(this, $A.getCallback(function (response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    let result = response.getReturnValue();
                    component.set('v.optLawfirms', result);
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                }
            }));
            $A.enqueueAction(action);
        }
    }
   
})