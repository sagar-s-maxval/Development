({
     toggleAccordion : function(component) {
        component.set('v.showAccordion', !component.get('v.showAccordion'));
    },
    getdata: function(component, event) {
        var action = component.get('c.getHiearchySettings'); 
        action.setCallback(this,$A.getCallback(function (response) {// console.log('result-->'+response);
             var state = response.getState();
            if (state === "SUCCESS")  { 
             console.log(response.getReturnValue());
             var res=response.getReturnValue();
             component.set("v.richtext",res);
                                                  } else if (state === "ERROR") { var errors = response.getError();
                                                                                  alert(JSON.stringify(errors));
                                                                                  console.error(errors);
                                                                                 }} ) );
        $A.enqueueAction(action);
    },
    
	save : function(component, event) {
		console.log('Text-->'+component.get("v.richtext"));
          var action = component.get('c.savedata');
         action.setParams({
            "str" : component.get("v.richtext")});
        action.setCallback(this,$A.getCallback(function (response)
                                               { console.log('result-->'+response);
                                                   var state = response.getState();
                                                   if (state === "SUCCESS")  { 
                                                      var toastEvent = $A.get("e.force:showToast");
                                              toastEvent.setParams({
                                                "title": "Success!",
                                                  duration:' 5000',
                                              "message": "Changes Saved successfully.",
                                                    type: "success"
                                                    });
                                        toastEvent.fire();  
                                                      // this.getdata(component, event);
                                                  } else if (state === "ERROR") { var errors = response.getError();
                                                                                  alert(JSON.stringify(errors));
                                                                                  console.error(errors);
                                                                                 }} ) );
        $A.enqueueAction(action);
	}
})