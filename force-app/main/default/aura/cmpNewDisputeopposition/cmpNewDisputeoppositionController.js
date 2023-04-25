({
    doInit : function(component, event, helper) {
      //  helper.doInitHelper(component, event, helper);
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
        let dipsuteid = component.find("lstAvailableInventors").get("v.value");
        let TradeMarkId = component.get('v.recordId');
       helper.updateConnection(component, helper, dipsuteid, TradeMarkId);
        component.find('txtSearchInventors').set('v.value', '');
        component.find('txtSearchInventors').focus();
        component.set("v.inputdisable", true);
    },

    onblur: function(component, event, helper) {
        component.set("v.isShowSearchResult", false);
    },
});