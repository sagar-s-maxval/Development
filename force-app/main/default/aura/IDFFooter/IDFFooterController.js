({
   onButtonPressed: function(cmp, event, helper) {
      // Figure out which action was called
      var actionClicked = event.getSource().getLocalId();
      // Fire that action
      console.log(actionClicked);
      let actionSelected;
      let executeAction;
      if (actionClicked === 'PREVIOUS') {
          actionSelected = 'Previous';
          executeAction = 'BACK';
      } else if (actionClicked === 'PREVIOUS1') {
          actionSelected = 'Previous';
          executeAction = 'NEXT';
      } else if (actionClicked === 'NEXT') {
          actionSelected = 'Save and Proceed';
          executeAction = 'NEXT';
      } else if (actionClicked === 'EXIT') {
          actionSelected = 'Save and Exit';
          executeAction = 'NEXT';
      } else if (actionClicked === 'DELETE') {
          cmp.set('v.showModal', true);
          return;
      } else if (actionClicked === 'FINISH') {
          actionSelected = 'Save and Proceed';
          executeAction = 'NEXT';
      }
      cmp.set('v.isButtonNotAvailable', true);

      cmp.set('v.buttonClicked', actionSelected);
      var navigate = cmp.get('v.navigateFlow');
      navigate(executeAction);
   },

   closeModel: function(component, event, helper) {
      component.set("v.showModal", false);
      cmp.set('v.isButtonNotAvailable', false);
   },

   submitDetails: function(component, event, helper) {
      component.set('v.buttonClicked', 'Delete');
      var navigate = component.get('v.navigateFlow');
      navigate('NEXT');
   },

    showToolTip : function(component, event, helper) {
        component.set("v.tooltip" , true);

    },
    HideToolTip : function(component, event, helper){
        component.set("v.tooltip" , false);
    },

    showToolTip2 : function(component, event, helper) {
        component.set("v.tooltip2" , true);

    },
    HideToolTip2 : function(component, event, helper){
        component.set("v.tooltip2" , false);
    },

    handleExceedingLimit: function (component, event, helper){

        let value = event.getParam("isExceededLimit");
        component.set('v.isDisable', value);

    }
})