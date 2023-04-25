({
    doInit : function(component, event, helper) {
        let selectedInventorsIds = component.get('v.selectedInventors');
        if (selectedInventorsIds) {
            selectedInventorsIds = selectedInventorsIds.split(',');
            component.set('v.selectedInventorsList', selectedInventorsIds);
        } else {
            component.set('v.selectedInventorsList', []);
        }
        if (component.get('v.primaryInventorId')) {
            let inventorIds = [component.get('v.primaryInventorId')];
            helper.getSelectedInventor(component, event, helper, inventorIds);
        } else {
            helper.loadCurrentUser(component, event, helper);
        }
    },

    searchInventorsController: function(component, event, helper) {
        let txtSearchInventors = component.find('txtSearchInventors').get('v.value');

        if (txtSearchInventors.length > 0) {
            helper.searchInventorsHelper(component, helper, txtSearchInventors);
        } else {
            component.set('v.isShowSearchResult', false);
        }
    },

    getSelectedInventorsController: function(component, event, helper) {
        let inventorId = component.find("lstAvailableInventors").get("v.value");
        let inventorList = [inventorId];
        helper.getSelectedInventor(component, event, helper, inventorList);
        component.find('txtSearchInventors').set('v.value', '');
        component.find('txtSearchInventors').focus();
        component.set("v.inputdisable", true);
    },

    onblur: function(component, event, helper) {
        component.set("v.isShowSearchResult", false);
    },

    removeSelectedInventor: function(component, event, helper) {
        helper.showToast('warning', 'If you want to change primary inventor, search for another one. This value cannot be empty.')
    }
});