({
    doInit : function(component, event, helper) {
        let action = component.get('c.getEmailBody');
        let recordId = component.get('v.recordId');
        let params = {
            emailAuditId : recordId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.mailBody', result.Body__c);
                component.set('v.to', result.EmailAddresses__c);
                component.set('v.from', result.From__c);
            } else {
                let errors = response.getError();
                console.error(errors);
            }
        });

        $A.enqueueAction(action);
    },
});