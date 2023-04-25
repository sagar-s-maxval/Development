({
    doInit: function (component, event, helper) {
        component.set('v.options', [
            {
                'label': '1',
                'value': '1'
            },
            {
                'label': '2',
                'value': '2'
            },
            {
                'label': '3',
                'value': '3'
            },
            {
                'label': '4',
                'value': '4'
            },
            {
                'label': '5',
                'value': '5'
            },
        ]);

        helper.makeApexCall(component, event, helper);
        helper.getRecommendationOptions(component, event, helper);
    }
});