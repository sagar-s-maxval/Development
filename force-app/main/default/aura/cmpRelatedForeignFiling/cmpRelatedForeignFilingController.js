({
	loadValuesController : function(component) {
    	// Initialize input select options
        var lstInventors = [
            { label: "Morgan Adam J (morganadamj@gmail.com)", value: "a123", selected : true },
            { label: "Morgan Adam J (morganadamj1@gmail.com)", value: "a124" },
            { label: "Morgan Adam J (morganadamj2@gmail.com)", value: "a125" },

        ];
        var lstSelectedInventors = [
            { type: 'avatar',label: 'Morgan Adam J', name:'my1', fallbackIconName: 'standard:user', variant: 'circle', alternativeText:'Morgan Adam J (morganadamj@gmail.com)'},
            { type: 'avatar',label: 'Morgan Adam J', name:'my2', fallbackIconName: 'standard:user', variant: 'circle', alternativeText:'Morgan Adam J (morganadamj1@gmail.com)'}
        ];
        //component.set("v.lstInventors", lstInventors);
        //component.set("v.lstSelectedInventors", lstSelectedInventors);
        //component.find("lstAvailableInventors").set("v.options", lstInventors);
    },
    searchCountriesController: function (component, evt, helper) 
    {
        var isEscKey = evt.keyCode === 27;
        if (isEscKey)
        {
            component.set('v.isShowSearchResult',false);
        }
        else
        {
            var txtSearchCountries = component.find('txtSearchCountries').get('v.value');
            var arrSelectedCountryIdsValue = component.get("v.arrSelectedCountryIds");
            helper.searchCountriesHelper(component, txtSearchCountries, arrSelectedCountryIdsValue);
        }
    },
    removeSelectedCountriesController: function (component, event) 
    {
        var selectedCountryId = event.getParam("item").name;
        
        // Remove the pill from view
        var items = component.get('v.lstSelectedCountries');
        var item = event.getParam("index");
        items.splice(item, 1);
        component.set('v.lstSelectedCountries', items); 

        var arrSelectedCountryIdsValue = component.get("v.arrSelectedCountryIds");
        var index = arrSelectedCountryIdsValue.indexOf(selectedCountryId);
        if (index > -1) {
  			arrSelectedCountryIdsValue.splice(index, 1);
		}
        component.set("v.arrSelectedCountryIds", arrSelectedCountryIdsValue);
        component.set("v.strSelectedCountryIds", arrSelectedCountryIdsValue.join(","));
    },
    getSelectedCountriesController: function(component, event, helper) 
    {
		var selectedCountryId = component.find("lstAvailableCountries").get("v.value");
        var arrSelectedCountryIdsValue = component.get("v.arrSelectedCountryIds");
        arrSelectedCountryIdsValue.push(selectedCountryId);
        component.set("v.arrSelectedCountryIds", arrSelectedCountryIdsValue);
        component.set("v.strSelectedCountryIds", arrSelectedCountryIdsValue.join(","));
        component.set('v.isShowSearchResult',false);
        helper.getSelectedCountriesHelper(component, component.get("v.arrSelectedCountryIds"));
        component.find('txtSearchCountries').set('v.value','');
        component.find('txtSearchCountries').focus();
        //helper.getSelectedInventorsHelper(component);
        //alert('Values:' + component.get("v.arrSelectedInventorIds"));
	}
})