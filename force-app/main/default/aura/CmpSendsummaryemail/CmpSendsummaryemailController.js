({
	doInit : function(component, event, helper) {
        console.log('coming');
        var myPageRef = component.get("v.pageReference");
         console.log('coming-->'+JSON.stringify(myPageRef));
       // console.log(myPageRef);  && myPageRef != undeinfed
        if(myPageRef != null ){
            var recordId = myPageRef.state.c__recordId;
      
               var action = component.get("c.sendemail");
         action.setParams({ recid : recordId });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              var res= response.getReturnValue();
               component.set("v.response",res);
           component.set("v.loaded",false);
             var reflink='/'+recordId;
                console.log('REf link is '+reflink);
             window.location.replace(reflink);   
                 
            }
           else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                         component.set("v.errormsg", errors[0].message);
                      component.set("v.loaded",false);
                    }
                } else {
                    component.set("v.errormsg", "Unknown error");
                    console.log("Unknown error");
                      component.set("v.loaded",false);
                }
            }
        });
 
        $A.enqueueAction(action);   
            
        }
        else{
            console.log('Coming in Popup');
        var action = component.get("c.sendemail");
         action.setParams({ recid : component.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
             var res= response.getReturnValue();
             var dismissActionPanel = $A.get("e.force:closeQuickAction");
             dismissActionPanel.fire();
                component.set("v.response",res);
			   var toastEvent = $A.get("e.force:showToast");
               toastEvent.setParams({
               "title": "Success!",
               "message": res,
               "type":"success"
               });
             toastEvent.fire(); 
             
            }
           else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                         component.set("v.errormsg", errors[0].message);
                    }
                } else {
                    component.set("v.errormsg", "Unknown error");
                    console.log("Unknown error");
                }
            }
        });
 
        $A.enqueueAction(action);
        }
    }   
})