({
   onButtonPressed: function(cmp, event, helper) {
      // Figure out which action was called
      var actionClicked = event.getSource().getLocalId();

      console.log('ACTION: ' + actionClicked);
      if (actionClicked === 'SAVE') {
          cmp.set('v.buttonClicked', 'Save');
          var navigate = cmp.get('v.navigateFlow');
          navigate('NEXT');
      } else if (actionClicked === 'FINISH') {
          cmp.set('v.showModal', true);
      } else {
          cmp.set('v.buttonClicked', 'Cancel');
          var navigate = cmp.get('v.navigateFlow');
          navigate('NEXT');
      }

   },

   closeModel: function(component, event, helper) {
      component.set("v.showModal", false);
   },

   submitDetails: function(component, event, helper) {
      component.set('v.buttonClicked', 'Submit');
      var navigate = component.get('v.navigateFlow');
      navigate('NEXT');
   },
})