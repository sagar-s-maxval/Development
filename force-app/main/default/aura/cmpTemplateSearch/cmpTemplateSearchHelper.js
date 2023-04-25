({
    searchInventorsHelper: function(component, txtSearchWord) {
        let templates = component.get('v.availableProducts');

        let searched = templates.filter(elem => elem.Name.toLowerCase().includes(txtSearchWord.toLowerCase()));
        if (searched.length > 0) {
            component.set('v.isShowSearchResult', true);
            component.find("lstAvailableInventors").set("v.options", searched);
        }
    }
});