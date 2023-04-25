({
    fetchPatentDocuments : function(component) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getPatentDocuments");
        action.setParams({
            "patentId" : recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('--results 1--- ', result);
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
    },
    
    fetchPatentPendingDocuments : function(component) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getPatentPendingDocuments");
        action.setParams({
            "patentId" : recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('--results--- ', result);
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
    },

    checkAccess: function(component){
        var recordId = component.get("v.recordId");
        var action = component.get("c.getPatentDocumentAccessForLoggedInUser");
        action.setParams({
            "patentId" : recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('---result---', result);
                component.set("v.hasAccess", result);
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