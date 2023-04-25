({
    doInit: function (component, event, helper) {
        helper.getPicklists(component, event, helper);
        helper.getReview(component, event, helper);
        helper.getProducts(component, event, helper);
        helper.getProductLines(component, event, helper);
    },

    lineChanged: function(component, event, helper) {
        let lines = component.get('v.productLinesSelected');
        lines.push(component.get('v.q9'));
        component.set('v.q9', null);
        component.set('v.productLinesSelected', lines);
        helper.handleProductLineChange(component, event, helper);
    },

    productChanged: function(component, event, helper) {
        let lines = component.get('v.productsSelected');
        lines.push(component.get('v.q8'));
        component.set('v.productsSelected', lines);
    },

    reloadProducts: function(component, event, helper) {
        component.set('v.q9', null);
        helper.getProducts(component, event, helper);
        helper.handleProductLineChange(component, event, helper);
    },

    handleProductChange: function(component, event, helper) {
        component.set('v.q8', null);
        let productsSelected = component.get('v.productsSelected');
        let productValues = component.get('v.products');

        let filteredValues = productValues.filter(elem => !productsSelected.includes(elem.value));
        component.set('v.products', filteredValues);
    }

});