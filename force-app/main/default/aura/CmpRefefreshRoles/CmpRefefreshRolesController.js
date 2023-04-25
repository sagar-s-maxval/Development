({
	init: function (component, event, helper) {
          
      /*  let value = helper.getParameterByName(component, event, 'inContextOfRef');
        let context = JSON.parse(window.atob(value));
      //  component.set('v.patentId', context.attributes.recordId);*/
        var action = component.get("c.RefreshRole");
        action.setParams({  recid :   component.get("v.recordId"),          //context.attributes.recordId,
                           }); 
         action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS')
            {  if(response.getReturnValue()==='Success'){
               var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
                    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Success!",
        "type" : "success",
        "message": "The Roles has been Refreshed successfully."
    });
    toastEvent.fire();
                 
                }else{
                    console.log('Error-->'+response.getReturnValue());
                }
                
            } else if(state === 'ERROR'){
                var errors = response.getError();
                console.log(errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                       // alert(errors[0].message );
                        //alert('Custom Message');//Fetching Custom Message.
                    } } } });
        $A.enqueueAction(action); 
    }
})