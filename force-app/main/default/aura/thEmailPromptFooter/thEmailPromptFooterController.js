({
    handleChange : function(component, event, helper) {
        let response = event.getSource().getLocalId();

        let actionSelected;
        let executeAction;
        if (response === 'CANCEL') {
            actionSelected = 'Cancel';
            component.set("v.actionSelected", actionSelected);
            executeAction = 'NEXT';
        } else if (response === 'NEXT') {
            actionSelected = 'Send';
            component.set("v.actionSelected", actionSelected);
            executeAction = 'NEXT';
        }
        let navigate = component.get("v.navigateFlow");
        navigate(executeAction);
    }
});