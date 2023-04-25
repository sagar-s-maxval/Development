({
    doInit : function(component, event, helper) {
        var action = component.get('c.getDocketRules');
        action.setParams({
            "trackerId" : component.get('v.trackerId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.rules', result);
            } else {
                var error = response.getError();
                console.log('---errorr---', error);
            }
        });

        $A.enqueueAction(action);
    }
})