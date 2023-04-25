({
    doInit : function(component, event, helper) {
        let inventors = [];
        let coInventorsIds = component.get('v.coInventors');

        if (coInventorsIds) {
            inventors.push(coInventorsIds);
        }

        helper.makeApexCall(component, event, helper, inventors);
    },

    removeInventor : function(component, event, helper) {
        let inventors = component.get('v.selectedInventors');
        let index = event.target.dataset.index;
        inventors.splice(index, 1);
        component.set('v.coInventors', null);
        component.set('v.selectedInventors', inventors);
    }
});