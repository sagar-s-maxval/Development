({
    doInit : function(component, event, helper) {
        let radioOptions = [
            { label: 'Yes', value: 'Yes'},
            { label: 'No', value: 'No'}
        ];

        component.set('v.optionValues', radioOptions);

        let abcdOptions = [
            { label: 'The invention relates to the business area of the company and is part of the inventor\'s job description', value: 'The invention relates to the business area of the company and is part of the inventor\'s job description'},
            { label: 'The invention relates to the business area of the company but is not part of the inventor\'s job description', value: 'The invention relates to the business area of the company but is not part of the inventor\'s job description'},
            { label: 'The invention does not relate to the business area of the company but is part of the inventor\'s job description', value: 'The invention does not relate to the business area of the company but is part of the inventor\'s job description'},
            { label: 'The invention does not relate to the business area of the company and is not part of the inventor\'s job description', value: 'The invention does not relate to the business area of the company and is not part of the inventor\'s job description'}
        ];

        component.set('v.abcdOptions', abcdOptions);

        helper.makeApexCall(component, event, helper);
        helper.getReceivedResponses(component, event, helper);
        helper.setColumns(component);
        helper.getMaxAllowedContribution(component, event, helper);
    },

    changeQd: function(component, event, helper) {
        let newValue = component.get('v.qdRadio');

        if (newValue !== 'Yes') {
            component.set('v.qd', null);
        }
    },

    changeQe: function(component, event, helper) {
        let newValue = component.get('v.qeRadio');

        if (newValue !== 'Yes') {
            component.set('v.qe', null);
        }
    },

    changeQf: function(component, event, helper) {
        let newValue = component.get('v.qfRadio');

        if (newValue !== 'Yes') {
            component.set('v.qf', null);
        }
    },

   onButtonPressed: function(cmp, event, helper) {
      // Figure out which action was called
      var actionClicked = event.getSource().getLocalId();

      if (actionClicked === 'SAVE') {
          cmp.set('v.buttonClicked', 'Save');
          var navigate = cmp.get('v.navigateFlow');
          navigate('NEXT');
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
   }
});