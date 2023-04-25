({
    doInit: function(component, event, helper) {
        let options = component.get('v.availableProducts');

        options.forEach(elem => elem.label = elem.Name);

        component.set('v.availableProducts', options);
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
        let product = component.find("lstAvailableInventors").get("v.value");
        component.set('v.product', product);
        component.find('txtSearchInventors').set('v.value', '');
        component.find('txtSearchInventors').focus();
        component.set("v.inputdisable", true);
        component.set('v.isShowSearchResult', false);
    },

    onblur: function(component, event, helper) {
        component.set("v.isShowSearchResult", false);
    }
});