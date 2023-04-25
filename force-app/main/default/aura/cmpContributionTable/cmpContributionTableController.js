({
    doInit : function(component, event, helper) {
        component.set('v.IDF', component.get('v.recordId'));
        component.set('v.totalContribution', 0);

        let radioOptions = [
            { label: 'Yes', value: 'Yes'},
            { label: 'No', value: 'No'}
        ];

        component.set('v.optionValues', radioOptions);
        helper.getAllInventors(component, event, helper);
        helper.getCurrentInventor(component, event, helper);
    },

    splitRemuneration : function(component, event, helper) {
        helper.splitContribution(component, event, helper);
    },

    saveContribution : function(component, event, helper) {
        if (((component.get('v.totalContribution')*1) + (component.get('v.contribution')*1)) < 100) {
            helper.showToast('warning', 'Total contribution is less than a hundred.');
        }
        let temp = 100 / (component.get('v.serialNumber') * 1);
        if (component.get('v.split') && Math.round(temp * 100) / 100 === Math.round(component.get('v.contribution') * 100) / 100 && component.get('v.profileName') !== 'Platform Inventor') {
            helper.updateSplitContribution(component, event, helper);
        } else {
            helper.updateContribution(component, event, helper);
        }
    },

    saveSplitContribution : function(component, event, helper) {
        helper.updateSplitContribution(component, event, helper);
    },

    showMessage : function(component, event, helper) {
        if (component.get('v.totalContribution') < 100 && component.get('v.canUserAdd')) {
            helper.showToast('warning', 'Total contribution is less than a hundred.');
        }
    },

    handleOpenFlow : function(component, event, helper) {
        component.set('v.flowIsOpened', true);
    }
});