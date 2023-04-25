({
    loadEmails : function(component, event, helper) {
        let action = component.get('c.getEmails');
        let params = {
            recordId: component.get('v.recordId')
        };

        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue().sort((a,b)=>a.Date_Sent__c-b.Date_Sent__c);

                component.set('v.emailList', result);
            } else {
                let errors = response.getError();
                console.log(errors);
            }
        });

        $A.enqueueAction(action);
    },

    setColumns: function (component) {
        component.set('v.columns', [
            {
                label: 'Date Sent',
                fieldName: 'Date_Sent__c',
                type: 'date',
                typeAttributes: {
                    day: 'numeric',
                    month: 'numeric',
                    year: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: true
                  },
                sortable : false
            },
            {
                label: 'Subject',
                fieldName: 'Link__c',
                type: 'url',
                wrapText: true,
                typeAttributes: {
                    label: {fieldName : 'EmailSubject__c'}, target: '_self'
                }
            },
            {
                label: 'To',
                fieldName: 'EmailAddresses__c',
                type: 'email'
            },
            {
                label: 'From',
                fieldName: 'From__c',
                type: 'email'
            }
        ]);
    }
});