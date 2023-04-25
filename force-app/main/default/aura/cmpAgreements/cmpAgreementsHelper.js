({
    fetchData : function(component) {
        var action = component.get('c.getSDocsIDFTemplates');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.data', result);
            }else{
                var error = response.getError();
                console.log('error-- ', error);
            }
        });

        $A.enqueueAction(action);
    },
    
    setOptions : function(component, event, helper, results) {
        component.set('v.options', results);
    },

    setInventors : function(component, event, helper, results) {
        console.log('INVS: ' + JSON.stringify(results));
        component.set('v.inventors', results);
    },

    afterGeneration: function(component, event, helper, results) {
        if (results) {
            helper.showToast('success', 'Documents were successfully generated. It may take a few moments for them to appear in the Files section.');
        } else {
            helper.showToast('error', 'Generating has failed.');
        }
    }
});