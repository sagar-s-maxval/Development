({
	       getPatentEmailRecord : function( component, event, helper ) {
           var action = component.get("c.getPatentEmailRecord"); //Calling Apex class controller 'getPatentEmailRecord' method
           action.setParams({ "recId" : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var result = JSON.stringify(response.getReturnValue());
            if (component.isValid() && state === "SUCCESS")
                component.set("v.emailLst", response.getReturnValue());  // Adding values in Aura attribute variable.   
        });
        $A.enqueueAction(action);
                }
})