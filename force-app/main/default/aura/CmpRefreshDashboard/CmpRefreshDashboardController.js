({
	doInit : function(component, event, helper) {
        var action=component.get("c.refreshDashboardcont");
        action.setParams({'dashboardName': component.get("v.DashboardId")});
        action.setCallback(this, function(response) { 
            console.log(response.getState());
            if (response.getState() === "SUCCESS") {
				console.log('Respose-->'+response.getReturnValue());
          /*  if(response.getReturnValue() != ''){
                component.set("v.asyncId",response.getReturnValue());
                var interval =window.setInterval(   
                    $A.getCallback(function() { 
                        var iterator=component.get("v.iterator");
                        if(iterator >8)
                        {
                            //window.clearInterval(component.get("v.setIntervalId"));
                            window.clearInterval(interval);
                        }
                        iterator++;
                        console.log('iterator::'+iterator);
                        component.set("v.iterator",iterator); 
                       // helper.checkStatus(component);
                    }), 120000
                ); 
            }else{
                component.set("v.asyncId",'');
                component.set("v.iterator",10); 
                //$A.get('e.force:refreshView').fire();
            }  */ 
            }else if (response.getState() === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})