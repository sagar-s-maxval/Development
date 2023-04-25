({
    searchInventorsHelper: function(component, event, helper, txtSearchWord) {
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
//            component.set('v.isLoading', false);
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
            let inventors = results.map(elem => elem.value);
            component.set('v.selectedInventorsList', inventors);
            component.set('v.selectedInventors', inventors.join(','));
        }
        component.set("v.isShowSearchResult", false);
    }

});