({
    doInit : function(component, event, helper) {
        let selectedInventorsIds = component.get('v.selectedInventors');
        if (selectedInventorsIds) {
            selectedInventorsIds = selectedInventorsIds.split(',');
            component.set('v.selectedInventorsList', selectedInventorsIds);
            helper.getSelectedInventor(component, event, helper, selectedInventorsIds);
        }
    },

    searchInventorsController: function(component, event, helper) {
        let txtSearchInventors = component.find('txtSearchInventors').get('v.value');

        if (txtSearchInventors.length > 0) {
//            component.set('v.isLoading', true);
            helper.searchInventorsHelper(component, event, helper, txtSearchInventors);
        } else {
            component.set('v.isShowSearchResult', false);
        }
    },

    getSelectedInventorsController: function(component, event, helper) {
        let inventorId = component.find("lstAvailableInventors").get("v.value");
        let inventorList = component.get('v.selectedInventorsList');
        inventorList.push(inventorId);
        helper.getSelectedInventor(component, event, helper, inventorList);
        component.find('txtSearchInventors').set('v.value', '');
        component.find('txtSearchInventors').focus();
        component.set("v.inputdisable", true);
    },

    onblur: function(component, event, helper) {
        component.set("v.isShowSearchResult", false);
    },

    removeSelectedInventor: function(component, event, helper) {
        let selectedInventorId = event.getParam("item").value;
        let existingIds = component.get("v.selectedInventorsList");
        let newIds = existingIds.filter(elem => elem !== selectedInventorId);
        component.set('v.selectedInventorsList', newIds);
        component.set('v.selectedInventors', newIds.join(','));
        helper.getSelectedInventor(component, event, helper, newIds);
    },


    handleRemoveInventor: function(component, event, helper) {
        let selectedInventorId = event.getParam("inventorId");
        let existingIds = component.get("v.selectedInventorsList");
        let newIds = existingIds.filter(elem => elem !== selectedInventorId);
        component.set('v.selectedInventorsList', newIds);
        component.set('v.selectedInventors', newIds.join(','));
        helper.getSelectedInventor(component, event, helper, newIds);
    }
});