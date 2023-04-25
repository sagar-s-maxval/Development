({
    getHistoryRecords : function(component) {
        var action = component.get("c.getPatentAttachmentHistory");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('---history result--- ', result);
                component.set("v.records", result);
            }else if (state === "ERROR") {
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
    }
})