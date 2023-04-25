({
    loadCurrentUser: function(component, event, helper) {
        let action = component.get('c.searchCurrentInventor');
        let params = {
            currentUserEmail : component.get('v.currentUserEmail')
        };

        console.log('EMAIL: ' + component.get('v.currentUserEmail'));
        helper.makeApexCall(component, event, helper, action, params, helper.setPrimaryInventor);
    },

    setPrimaryInventor: function(component, event, helper, results) {
        if (results && results.length > 0) {
            component.set('v.primaryInventorId', results[0].value);
            component.set('v.pillList', results);
        }
    },

    searchInventorsHelper: function(component, helper, txtSearchWord) {
        let action = component.get('c.searchInventors');
        let params ={
            searchWord: txtSearchWord,
            primaryInventorId: component.get('v.primaryInventorId'),
            inventorsToExclude: component.get('v.selectedInventorsList')
        };
        helper.makeApexCall(component, event, helper, action, params, helper.setSearchResults);
    },

    setSearchResults : function(component, event, helper, results) {
        if (results.length > 0) {
            component.set('v.isShowSearchResult', true);
            component.find("lstAvailableInventors").set("v.options", results);
        } else {
            component.set('v.isShowSearchResult', false);
        }
    },

    getSelectedInventor : function(component, event, helper, inventorIds) {
        let action = component.get('c.getInventors');
        let params = {
            inventorsIDs : inventorIds
        };
        helper.makeApexCall(component, event, helper, action, params, helper.setSelectedInventor)
    },

    setSelectedInventor : function(component, event, helper, results) {
        if (results) {
            component.set('v.pillList', results);
            component.set('v.primaryInventorId', results[0].value);
        }
    }

});