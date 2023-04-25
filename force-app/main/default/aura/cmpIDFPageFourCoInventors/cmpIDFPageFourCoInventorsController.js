({
    doInit : function(component, event, helper) {
        component.set('v.totalContribution', 0);
        helper.makeApexCall(component, event, helper);

        let radioOptions = [
            { label: 'Yes', value: 'Yes'},
            { label: 'No', value: 'No'}
        ];

        component.set('v.optionValues', radioOptions);
        helper.getAllInventors(component, event, helper);
    },

    splitRemuneration : function(component, event, helper) {
        if (component.get('v.split')) {
            helper.getDefaultRemuneration(component, event, helper);
        } else {
            component.set('v.contribution', 0);
        }
    },
});