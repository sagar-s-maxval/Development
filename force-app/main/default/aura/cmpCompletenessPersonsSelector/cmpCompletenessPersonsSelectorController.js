({
    loadValuesController: function(component, event, helper) {
        component.set("v.placeholder", "Search for persons");
        helper.getSelectedInventorsHelper(component, event, helper);
    },
    searchInventorsController: function(component, evt, helper) {
        let txtSearchInventors = component.find('txtSearchInventors').get('v.value');
        let arrSelectedInventorIdsValue = component.get("v.arrSelectedInvIds");
        arrSelectedInventorIdsValue.push(component.get('v.primaryInventor'));

        if (txtSearchInventors.length > 0) {
            helper.searchInventorsHelper(component, txtSearchInventors, arrSelectedInventorIdsValue);
        } else {
            component.set('v.isShowSearchResult', false);
        }
    },
    removeSelectedInventorsController: function(component, event, helper) {
        let selectedInventorId = event.getParam("item").value;
        let items = component.get('v.lstSelectedInventors');
        console.log('SELECTED PILLS: ' + JSON.stringify(items));
        console.log('TO DELETE: ' + selectedInventorId);
        component.set('v.lstSelectedInventors', items.filter(item => item.value !== selectedInventorId));

        let arrSelectedInventorIdsValue = component.get("v.arrSelectedInvIds").filter(item => item !== selectedInventorId);
        component.set("v.arrSelectedInvIds", arrSelectedInventorIdsValue);

        let newIds = arrSelectedInventorIdsValue.join(',');
        component.set("v.strSelectedInvIds", newIds);

//        component.set("v.arrSelectedInvIds", arrSelectedInventorIdsValue.join(","));
        component.set("v.inputdisable", true);
//        helper.deleteInventor(component, event, helper, selectedInventorId);
    },
    
    getSelectedInventorsController: function(component, event, helper) {
        let selectedInventorId = component.find("lstAvailableInventors").get("v.value");
        let arrSelectedInventorIdsValue = component.get("v.arrSelectedInvIds");
        arrSelectedInventorIdsValue.push(selectedInventorId);
        component.set("v.arrSelectedInvIds", arrSelectedInventorIdsValue);
        component.set("v.strSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
        component.set('v.isShowSearchResult', false);
        console.log('ID ARRAY: ' + JSON.stringify(arrSelectedInventorIdsValue));
        helper.getSelectedInventorsHelper(component, event, helper);
        component.find('txtSearchInventors').set('v.value', '');
        component.find('txtSearchInventors').focus();
        component.set("v.inputdisable", true);
    },

    onblur: function(component, event, helper) {
        component.set("v.isShowSearchResult", false);
    }
})