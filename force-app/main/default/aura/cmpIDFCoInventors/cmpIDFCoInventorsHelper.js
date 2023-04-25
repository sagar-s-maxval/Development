({
    makeApexCall : function(component, event, helper, id) {
        console.log('In apex call');
        let action = component.get('c.getSelectedInventors');
        let ids = id.split(',');
        let params = {
            inventorsIDs : ids
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(JSON.stringify(response));
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.selectedInventors', result);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    }
});