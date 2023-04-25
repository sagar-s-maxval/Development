({
    showModal: function(component, event, helper) {
        component.set('v.showModal', true);
    },

    closeModal: function(component, event, helper) {
        component.set('v.showError', false);
        component.set('v.showModal', false);
    },

    saveActivity: function(component, event, helper) {
        if ((!component.get('v.actions') || !component.get('v.eventDate') || !component.get('v.dueDate') || (component.get('v.dueDate') < component.get('v.eventDate')))) {
            component.set('v.showError', true);
            return;
        }

      let navigate = component.get('v.navigateFlow');
      navigate('NEXT');
    }
});