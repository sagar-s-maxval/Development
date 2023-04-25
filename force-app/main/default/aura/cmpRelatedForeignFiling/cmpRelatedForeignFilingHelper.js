({
	searchCountriesHelper : function(component, txtSearchWord, arrSelectedCountryIds) 
    {
        //alert(txtSearchWord);
        var action = component.get('c.searchCountries');
        action.setParams({ searchWord : txtSearchWord, countryIds :arrSelectedCountryIds });
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    //alert(JSON.stringify(response.getReturnValue()));
                    var state = response.getState();
                    var result = response.getReturnValue();
                    //alert(JSON.stringify(result));
                    if (state === "SUCCESS") 
                    {
                        if (result.length>0)
                        {
                            component.set('v.isShowSearchResult',true);
                            component.find("lstAvailableCountries").set("v.options", result);
                        }
                        else
                        {
                        	component.set('v.isShowSearchResult',false);
                        }
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        alert(JSON.stringify(errors));
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
	},
    getSelectedCountriesHelper : function(component, arrSelectedCountryIds) 
    {
        var action = component.get('c.getSelectedCountries');
        action.setParams({ countryIds : arrSelectedCountryIds });
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    //alert(JSON.stringify(response.getReturnValue()));
                    var state = response.getState();
                    var result = response.getReturnValue();
                    if (state === "SUCCESS") 
                    {
                        component.set("v.lstSelectedCountries", result);
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        alert(JSON.stringify(errors));
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
	}
})