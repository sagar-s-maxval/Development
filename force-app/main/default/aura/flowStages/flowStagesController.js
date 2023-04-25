({
    init: function (component, event, helper) {
        let stageMap = {};
        let steps = component.get('v.stages');
        steps.forEach((elem, i) => stageMap[elem] = i);
        let currentStep = component.get('v.currentStage');
        let results = [];
        steps.forEach(element => {
            let obj = {
                'aura:id': "step_" + element,
                'label': element,
                'value': element,
                'style': 'slds-path__item '
            }

            if (stageMap[element] === stageMap[currentStep]) {
                obj.style += 'slds-is-current slds-is-active ';
            } else if (stageMap[element] < stageMap[currentStep] || stageMap[element] <= component.get('v.savedNumber')) {
                obj.style += 'slds-is-complete';
            } else {
                obj.style += 'slds-is-incomplete';
            }
            results.push(obj);
        });
        component.set('v.body', results);
    },
 handleStepClick: function (component, event, helper) {
       console.log('No action');
 }
})