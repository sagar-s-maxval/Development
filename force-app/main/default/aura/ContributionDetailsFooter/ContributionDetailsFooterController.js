({
   onButtonPressed: function(component, event, helper) {
//      // Figure out which action was called
      var actionClicked = event.getSource().getLocalId();

      console.log('ACTION: ' + actionClicked);
      if (actionClicked === 'SAVE') {
          component.set('v.buttonClicked', 'Save');
          component.set('v.openFlow', false);
//          var navigate = component.get('v.navigateFlow');
//          navigate('NEXT');
      } else if (actionClicked === 'FINISH') {
          component.set('v.showModal', true);
      }
   },

   closeModel: function(component, event, helper) {
      component.set("v.showModal", false);
   },

   submitDetails: function(component, event, helper) {
      component.set('v.buttonClicked', 'Submit');
      component.set('v.openFlow', false);
//      var navigate = component.get('v.navigateFlow');
//      navigate('NEXT');
   },
})