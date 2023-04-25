({
    getDefaultRemuneration : function(component, event, helper) {
        let action = component.get('c.countRemunerationAfterSubmit');
        let recordId = component.get('v.recordId');
        let params = {
            inventionDisclosureId : recordId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {

            } else {
                let errors = response.getError();
                console.error(errors);
            }
        });

        $A.enqueueAction(action);
    },
});