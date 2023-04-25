({
    doInit : function(component, event, helper) {
        let action = component.get('c.getPatentsById');
        let params = {
            patentId: component.get('v.patentId')
        };
        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let results = response.getReturnValue();
                results.forEach(elem => elem.Link = '/' + elem.Id);
                component.set('v.data', results);
                console.log(JSON.stringify(results));
                component.set('v.columns', [
                    {
                        label: 'Patent',
                        fieldName: 'Link',
                        type: 'url',
                        typeAttributes: {
                            label: {fieldName : 'SymphonyIPM__Docket_No__c'},
                            target: '_self'
                        },
                        cellAttributes: {
                            alignment: 'center'
                        }
                    },
                    {
                        label: 'Expiration Date',
                        fieldName: 'SymphonyIPM__Expiration_Date__c',
                        type: 'date',
                        cellAttributes: {
                            alignment: 'center'
                        }
                    }
                ])
            } else if (state === "ERROR") {
                console.error(response.getError());
            }
        });

        $A.enqueueAction(action);
    }
});