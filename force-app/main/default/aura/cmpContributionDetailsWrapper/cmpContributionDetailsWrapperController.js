({
    doInit : function(component, event, helper) {
        let action = component.get('c.checkIfUserCanOpenFlow');
        let recordId = component.get('v.recordId');
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let params = {
            idfId : recordId,
            userId : userId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.showContribution', result);
            } else {
                let errors = response.getError();
                console.error(errors);
            }
        });

        $A.enqueueAction(action);
    },
});