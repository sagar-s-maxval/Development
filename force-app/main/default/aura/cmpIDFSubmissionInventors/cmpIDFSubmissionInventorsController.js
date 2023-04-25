({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
    },

    itemsChanged : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
    },

    removeInventor: function(component, event, helper) {
        let inventorId = event.getParam('row').Id;
        let inventors = component.get('v.selectedInventors');
        let primaryInventor = component.get('v.primaryInventor');
        let coInventors = component.get('v.coInventors').split(';');

        inventors.filter(elem => elem.Id !== inventorId);
        coInventors = coInventors.filter(elem => elem !== inventorId);
        component.set('v.selectedInventors', inventors);
        component.set('v.coInventors', coInventors.join(';'));
        if (primaryInventor === inventorId) {
            helper.showToast('warning', 'If you want to change primary inventor, search for another one. This value cannot be empty.')
        }

        let appEvent = $A.get("e.c:removeInventorEvent");
        appEvent.setParams({'inventorId' : inventorId});
        appEvent.fire();
    }
});