({  
    copyInputFieldValue : function(component, event, helper) {
        // get lightning:textarea field value using aura:id
        var textForCopy = component.find('inputF').get("v.value");
        // calling common helper class to copy selected text value
        helper.copyTextHelper(component,event,textForCopy);
    },
})