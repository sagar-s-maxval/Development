({
    handleChange : function(component, event, helper) {
        let response = event.getSource().getLocalId();
        console.log(response);

        let actionSelected;
        let executeAction;
        if (response === 'SAVE') {
            actionSelected = 'Draft';
            component.set("v.actionSelected", actionSelected);
            executeAction = 'NEXT';
        } else if (response === 'NEXT') {
            actionSelected = 'Submitted for Review';
            component.set("v.actionSelected", actionSelected);
            executeAction = 'NEXT';
        } else if (response === 'SAVE AS DRAFT') {
            actionSelected = 'Clarifications Requested';
            component.set("v.actionSelected", actionSelected);
            executeAction = 'NEXT';
        } else if (response === 'SUBMIT') {
            actionSelected = 'Resubmitted for Review';
            component.set("v.actionSelected", actionSelected);
            executeAction = 'NEXT';
        }
        let navigate = component.get("v.navigateFlow");
        navigate(executeAction);
    }
});