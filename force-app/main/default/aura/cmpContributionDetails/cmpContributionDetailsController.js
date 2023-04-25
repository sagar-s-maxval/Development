({
    doInit : function(component, event, helper) {
        helper.populateColumns(component);
        helper.makeApexCall(component, event, helper);
    }
});