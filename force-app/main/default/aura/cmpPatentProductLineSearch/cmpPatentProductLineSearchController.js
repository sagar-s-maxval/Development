({
    doInit: function(component, event, helper) {

    },

    searchInventorsController: function(component, evt, helper) {
        let txtSearchInventors = component.find('txtSearchInventors').get('v.value');

        if (txtSearchInventors.length > 0) {
            helper.searchInventorsHelper(component, txtSearchInventors);
        } else {
            component.set('v.isShowSearchResult', false);
        }
    },

    getSelectedInventorsController: function(component, event, helper) {
        let productLine = component.find("lstAvailableInventors").get("v.value");
        component.set('v.productLine', productLine);
        let selectedLines = component.get('v.selectedLines');
        if (selectedLines.indexOf(productLine) > -1) {
            selectedLines.push(productLine);
            component.set('v.selectedLines', selectedLines);
        }
        helper.getSelectedLines(component, event, helper, selectedLines);
        component.find('txtSearchInventors').set('v.value', '');
        component.find('txtSearchInventors').focus();
        component.set("v.inputdisable", true);
        component.set("v.isShowSearchResult", false);
    },

    removeSelectedLine : function(component, event, helper) {
        let deletedLine = event.getParam("item").value;
        let selectedLines = component.get('v.selectedLines');
        selectedLines = selectedLines.filter(elem => elem != deletedLine);
        component.set('v.selectedLines', selectedLines);
        helper.getSelectedLines(component, event, helper, selectedLines);
    },

    onblur: function(component, event, helper) {
        component.set("v.isShowSearchResult", false);
    },

    reloadPills: function(component, event, helper) {
        helper.getSelectedLines(component, event, helper, component.get('v.selectedLines'));
    }
});