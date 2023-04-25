({
    init: function (component) {
        component.set('v.showButton', true);
    },

    openFlow : function(component, event, helper) {
//        let cmpEvent = $A.get("e.c:openContributionDetailsFormEvent");
//        cmpEvent.setParams({"openFlow": true});
//        cmpEvent.fire();
        component.set('v.flowIsOpened', true);
    }
});