({
    getPatentDocumentRecord : function(component){
        var action = component.get("c.getDocumentRecord");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.newDocument", result);
                console.log('---newdocument--- ', result);
            }else{
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
        var action = component.get("c.checkLoggedInUserAccess");
        action.setParams({
            'recordId' : component.get('v.recordId')
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('--result--- ', result);
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
    },
    
    getDocTypeOptions : function(component) {
        var action = component.get("c.getDocumentTypeOptions");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set("v.docTypeOptions", result);
                console.log('---doctype--- ', result);
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

    getRevByOptions : function(component) {
        var action = component.get("c.getReviewByOptions");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set("v.reviewByOptions", result);
                console.log('---reviewByOptions--- ', result);
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

    saveDocumentRecord : function(component){
        var action = component.get("c.savePatentDocument");
        action.setParams({
            "patentDocument" : component.get("v.newDocument")
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "This Document has been submitted.",
                    "type": "success"
                });
                toastEvent.fire();
                window.location.reload();
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

    saveFinalVersion: function(component){
        var action = component.get("c.savePatentDocumentFinalVersion");
        action.setParams({
            "patentDocument" : component.get("v.newDocument")
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "This Document has been submitted.",
                    "type": "success"
                });
                toastEvent.fire();
                window.location.reload();
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

    saveDocumentDraft : function(component){
        var action = component.get("c.saveDraftDocument");
        action.setParams({
            "patentDocument" : component.get("v.newDocument")
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "This Document has been saved.",
                    "type": "success"
                });
                toastEvent.fire();
                window.location.reload();
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

    handleDeleteDocument : function(component){
        var action = component.get("c.deleteDocument");
        action.setParams({
            "patentDocument" : component.get("v.newDocument")
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "This Document has been deleted.",
                    "type": "success"
                });
                toastEvent.fire();
                
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
    }
})