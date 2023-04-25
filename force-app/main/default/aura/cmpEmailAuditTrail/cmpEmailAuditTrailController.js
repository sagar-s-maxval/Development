({
    doInit : function(component, event, helper) {
        helper.setColumns(component);
        helper.loadEmails(component, event, helper);
    }
});