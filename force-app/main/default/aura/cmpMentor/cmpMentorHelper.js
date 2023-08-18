({
    
    searchInventorsHelper : function  (component, txtSearchWord, arrSelectedInventorIds)  {
        
        var action = component.get('c.searchInventors');
        action.setParams({ searchword : txtSearchWord, inventorIds : arrSelectedInventorIds});
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function(response)
                {
                    var state = response.getState();
                    var result = response.getReturnValue();
                    
                    if(state === "SUCCESS")
                    {
                        if(result.length > 0)
                        {
                            component.set('v.isShowSearchResult',true);
                            component.find("lstAvailableInventors").set("v.options", result);
                        }
                        else
                        {
                            component.set('v.isShowSearchResult',false);
                        }
                        
                    }
                }
            )
        );
        
        $A.enqueueAction(action);
    },
    
    getSelectedInventorsHelper : function(component, arrSelectedInventorIds) 
    {
        
        var action = component.get('c.getSelectedInventors');
        action.setParams({ inventorIds : arrSelectedInventorIds});
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
                    //var auotpopval = component.find('txtSearchInventors').get('v.value');
                    if (state === "SUCCESS") 
                    {
                        var temp=component.get("v.lstSelectedInventors");
                        //alert('temp'+JSON.stringify(temp));
                        //temp.push(result);
                        component.set("v.lstSelectedInventors", result);
                       
                        var arrSelectedInventorIdsValue = [];
                        for(var i = 0 ; i < arrSelectedInventorIds.length; i++ )
                            {
                                
                                arrSelectedInventorIdsValue.push(arrSelectedInventorIds[i]);
                            }
                       component.set("v.strSelectedInventorIds",arrSelectedInventorIdsValue.join(',')); 
                        
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        //alert(JSON.stringify(errors));
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
        
    }
})