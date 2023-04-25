({
    init : function(component, event, helper) {
        // let value = helper.getParameterByName(component, event, 'inContextOfRef');
        // let context = JSON.parse(window.atob(value));
        //
        // component.set('v.recordId', context.attributes.recordId);
    },

    closeModal: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },

    openModal: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    }
});