({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
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
        let item = event.currentTarget;
        let patentId = item.dataset.value;
        let selected = item.dataset.selected;

        let recordId = component.get('v.recordId');
        console.log('SELECTED: ' + selected);
        if (selected === true || selected === 'true') {
            helper.removePatent(component,helper, patentId, recordId);
        } else {
            helper.updateConnection(component, helper, patentId, recordId);
        }
        let options = component.get("v.options");
        options.forEach(function(element) {
            if (element.value == patentId) {
                element.selected = selected == "true" ? false : true;
            }
        });
        component.set('v.options', options);
    },

    onblur: function(component, event, helper) {
        component.set("v.isShowSearchResult", false);
    },
});