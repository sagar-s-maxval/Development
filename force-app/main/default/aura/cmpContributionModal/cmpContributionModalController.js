({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
//        helper.loadData(component, event, helper);
//        helper.setColumns(component);
    },
    goToContributions : function(component, event, helper) {
        component.set('v.showModal2', true);
        component.set('v.showModal1', false);
    },

    closeModal: function(component, event, helper) {
        component.set('v.showModal2', false);
        component.set('v.showModal1', false);
    },
    saveContributions: function(component,event, helper) {
        helper.saveContributions(component, event, helper);
    },
    cancelContributions: function(component,event, helper) {
        let data = component.get('v.data');
        let sum = 0;
        data.forEach(elem => sum += (elem.Contribution__c * 1));
        if (sum !== 100) {
            sum = Math.round((sum + Number.EPSILON) * 100) / 100;
        }
        console.log('SUM ' + sum);
        component.set('v.totalContribution', sum);
    },
    handleCellChange : function(component, event, helper) {
        helper.saveContributions(component, event, helper);
        helper.countTotalContribution(component, event, helper);
    }
});