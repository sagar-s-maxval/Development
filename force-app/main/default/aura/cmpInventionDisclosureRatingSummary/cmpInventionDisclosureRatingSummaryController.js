({
    doInit: function (component, event, helper) {
        helper.makeApexCall(component, event, helper);
        helper.getDocketNumber(component, event, helper);
    }
});