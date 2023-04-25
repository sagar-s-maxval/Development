({
	onButtonPressed : function(component, event, helper) {
          component.set("v.SelectedButton",event.getSource().get("v.label"));
          // Figure out which action was called
          var actionClicked = event.getSource().getLocalId();
          // Fire that action
         
          var navigate = component.get('v.navigateFlow');
            navigate(actionClicked);
         if(component.get("v.SelectedButton") == 'Save and Exit' || component.get("v.SelectedButton") == 'Delete')
         {
           
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": "/lightning/page/home"
            });
            urlEvent.fire();
         }
        /* if(component.get("v.SelectedButton") == 'Submit')
         {
            window.location.reload();
         }*/
	}
})