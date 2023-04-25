({
    doInit : function(component, event, helper) {
        helper.fetchPatentPendingDocuments(component);
        helper.checkAccess(component);
    },

    handleUpload : function(component, event, helper) {
        console.log('---handleUpload---');
        var recordId = component.get("v.recordId");
        var action = component.get("c.createPatentAttachmentRecord");
        action.setParams({
            "patentId" : recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('--state--- ', state);
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('---handleUpload-result--- ', result);
                var urlEvent = $A.get("e.force:navigateToSObject");
                urlEvent.setParams({
                    "recordId" : result
                });
                urlEvent.fire();
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
    },

    handleRecordFilter: function(component, event, helper){
        var changeValue = event.getParam("value");
        if(changeValue == 'all'){
            helper.fetchPatentDocuments(component);
        }else if(changeValue == 'pending'){
            helper.fetchPatentPendingDocuments(component);
        }
    }
})