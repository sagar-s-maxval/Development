({
    doInit : function(component, event, helper) {

    },

    openModal : function(component, event, helper) {
        component.set("v.isOpen", true);
        let flow = component.find('flow');
        flow.startFlow('Create_New_Search_Project');
    },

    closeFlowModal : function(component, event, helper) {
        component.set("v.isOpen", false);
    },

    closeModalOnFinish : function(component, event, helper) {
        if(event.getParam('status') === "FINISHED") {
            component.set("v.isOpen", false);
        }
    }
});