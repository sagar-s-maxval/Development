({
    doInit : function(component, event, helper) {
        let pos = component.get('v.position');
        if (pos == 'left') {
            component.set('v.positionClass', 'position:absolute;top:-6rem;left:-15px;width:20rem;');
            component.set('v.passwordHintClass', 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide');
        } else {
            component.set('v.positionClass', 'position:absolute;top:-6rem;right:-15px;width:20rem');
            component.set('v.passwordHintClass', 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide');
        }
    },

    togglePasswordHint :function(component, event, helper) {
        let pos = component.get('v.position');
        if (pos == 'left') {
            component.set('v.passwordHintClass', component.get('v.passwordHintClass') == 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide' ? "slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-rise-from-ground" : "slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide");
        } else {
            component.set('v.passwordHintClass', component.get('v.passwordHintClass') == 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide' ? "slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground" : "slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide");
        }
    }
});