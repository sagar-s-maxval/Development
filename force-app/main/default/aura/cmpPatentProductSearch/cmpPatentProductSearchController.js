({
    searchInventorsController: function(component, evt, helper) {
        let txtSearchInventors = component.find('txtSearchInventors').get('v.value');

        if (txtSearchInventors.length > 0) {
            helper.searchInventorsHelper(component, txtSearchInventors);
        } else {
            component.set('v.isShowSearchResult', false);
        }
    },

    getSelectedInventorsController: function(component, event, helper) {
        let product = component.find("lstAvailableInventors").get("v.value");
        let existing = component.get('v.selectedProducts');
        if (existing.indexOf(product) > -1) {
            existing.push(product);
            component.set('v.selectedProducts', existing);
        }
        component.set('v.product', product);
        component.find('txtSearchInventors').set('v.value', '');
        helper.getSelectedProducts(component, event, helper, existing);
        component.find('txtSearchInventors').focus();
        component.set("v.inputdisable", true);
    },

    onblur: function(component, event, helper) {
        component.set("v.isShowSearchResult", false);
    },

    removeSelectedProduct : function(component, event, helper) {
        let deletedLine = event.getParam("item").value;
        let selectedLines = component.get('v.selectedProducts');
        selectedLines = selectedLines.filter(elem => elem != deletedLine);
        component.set('v.selectedProducts', selectedLines);
        helper.getSelectedProducts(component, event, helper, selectedLines);
    },
    reloadPills: function(component, event, helper) {
        helper.getSelectedProducts(component, event, helper, component.get('v.selectedProducts'));
    }
});