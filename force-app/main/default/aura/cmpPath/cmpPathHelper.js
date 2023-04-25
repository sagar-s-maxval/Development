({
    processSteps : function(component, event) {
        var steps = component.get('v.steps');
        var currentStep = component.get('v.currentStep');
        var results = [];
        steps.forEach(element => {
            var obj = {
                'id' : element.id,
                'label' : element.label,
                'stage' : 'slds-path__item '
            }
            if(currentStep == element.id){
                obj.stage += 'slds-is-current slds-is-active ';
            }

            if(element.stage == 'incomplete'){
                obj.stage += 'slds-is-incomplete';
            }else if(element.stage == 'complete'){
                obj.stage += 'slds-is-complete';
            }else if(element.stage == 'error'){
                obj.stage += 'slds-is-incomplete';
            }
            results.push(obj);
        });
        console.log('--results--- ', results);
        component.set('v.stepsProcessed', results);
    }
})