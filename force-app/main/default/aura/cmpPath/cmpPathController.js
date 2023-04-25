({
        init : function(component, event, helper) {
            helper.processSteps(component, event);
        },

        handleStepsChange : function(component, event, helper) {
            helper.processSteps(component, event);
        },

        handleStepClick : function(component, event, helper){
            var changedStep = event.currentTarget.dataset.id;
            component.set('v.currentStep', changedStep);
            helper.processSteps(component, event);
        }
})