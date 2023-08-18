({
    searchControllerHelper : function(component,event,searchText,listOfSelectedInvIds)
    {
        //alert('searchText'+searchText);
        var action = component.get("c.SearchInventorsNew");
        action.setParams({
            'InventorIds' : listOfSelectedInvIds,
            'searchKeyWord' : searchText
            
        });
        action.setCallback(
            this,
            $A.getCallback
            (
            function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                component.set('v.isShowSearchResult',true);
                var result = response.getReturnValue();
                //alert('Return value from search -->'+JSON.stringify(result));
                
                
                if(result == '' || result == null)
                {
                   // alert('Result null');
                    component.set('v.ErrorVariable',true);
                     component.set('v.isShowSearchResult',false);
                    //component.find('lstAvailableInventors').set("v.options",result);
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": 'error',
                        "message": "Invalid Inventor(s)..."
                    });
                    toastEvent.fire();*/
                    
                }else{
                    component.set('v.ErrorVariable',false);
                    component.set('v.isShowSearchResult',true);
                    
                    component.find('lstAvailableInventors').set("v.options",result);
                }
                //alert('ErrorVariable'+component.get('v.ErrorVariable'));
                
                var cmp = $A.get('e.c:OnSaveCheckValidInventor');
                cmp.setParams({'InvalidInv':component.get('v.ErrorVariable')});
                cmp.fire();
                
            }
            else if(state === 'ERROR')
            {
                /*var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        alert(errors[0].message );//Fetching Custom Message.
                    }
                }*/
            }
        }));
        $A.enqueueAction(action);
    },
    
    SelectedInventorsControllerHelper : function(component,event,selectedInventorIds)
    {
        var action = component.get('c.getInventors');
       // alert('Selected id helper -->'+selectedInventorIds);
        action.setParams({
            'inventorIds' : selectedInventorIds
            
        });
        action.setCallback
        (
            this,
            $A.getCallback
            (
            function(response)
            {
                var state = response.getState();
                if(state === "SUCCESS")
                {
                    
                    var ReturnResponse = response.getReturnValue();
                    console.log('response of inventors'+ReturnResponse);
                   // alert('returned selected record -->'+JSON.stringify(ReturnResponse));
                    component.set('v.SelectedInventor',ReturnResponse.label);
                    //component.set("v.listOfSelectedRecords",'')
                    component.set('v.record.Name',ReturnResponse.label);
                    component.set('v.record.Recid',ReturnResponse.Recid);
                    var index = component.get('v.rowIndex');
                    //alert('index'+index);
                    //component.set('v.record.IsPrimary',component.find("IsPrimaryInventor").get('v.checked'));
                    component.set('v.record.IsPrimary',false);
                    component.set('v.record.IndexVal',index);
                    component.set('v.record.EmailId',ReturnResponse.EmailId);
                    component.set('v.record.InventorName',ReturnResponse.InventorName);
                    
                    //alert('Child Helper index set'+component.get('v.record.Recid')+'from ctrl-->'+ReturnResponse.Recid);
                    //alert('Record id of inv -->'+ReturnResponse.name);
                    //alert('Selected inv -->'+component.get('v.SelectedInventor'));
                    //alert(ReturnResponse.EmailId+'Inventor Name'+JSON.stringify(component.get('v.record.EmailId')));
                    //alert(ReturnResponse.InventorName+'Emailid   ----->'+JSON.stringify(component.get('v.record.InventorName')));
                    //alert('firing event'+component.get('v.record'));
                    var cmp = $A.get('e.c:InventorEvt');
                    cmp.setParams({'InventorRecord':component.get('v.record')});
                    cmp.fire();
                    
                    //-----------------
                    if(ReturnResponse.Recid == '' || ReturnResponse.Recid == null)
                    {
                        //alert('Recid -->'+ReturnResponse.Recid);
                        component.set('v.ErrorVariable',true);
                        
                        //component.set('v.isShowSearchResult',false);
                    }
                    else
                    {
                        component.set('v.ErrorVariable',false);
                      
                        //component.set('v.isShowSearchResult',true);
                        if(ReturnResponse.Recid != '' || ReturnResponse.Recid != null)
                        {
                            
                            var cmp = $A.get('e.c:SelectedInventorEvt');
                            cmp.setParams({'SelectedinvId':ReturnResponse.Recid});
                            cmp.fire();
                        }
                    }
                    //alert('error variable'+component.get('v.ErrorVariable'));
                    var cmp = $A.get('e.c:OnSaveCheckValidInventor');
                    cmp.setParams({'InvalidInv':component.get('v.ErrorVariable')});
                    cmp.fire();
                    //-----------------
                    
                    //alert('Fired');
                }
                else if(state === 'ERROR')
                {
                    /*var errors = response.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            //alert(errors[0].message );//Fetching Custom Message.
                            //alert('Please select one Inventor at a time.');
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                //title : 'Warning',
                                //message: 'Please select one Inventor at a time.',
                                duration:' 3000',
                                key: 'info_alt',
                                type: 'info',
                                mode: 'dismissible'
                            });
                            toastEvent.fire();
                        }
                    }*/
                }
                
            }
        ));
        $A.enqueueAction(action);
    },
    
    handleAutoSuggestion :function(component,event,searchTextAuto,listinvids)
    {
        //alert('helper'+searchTextAuto);
        var invList=[];
        var action = component.get("c.AutoSuggestionReturnValue");
        action.setParams({
            'SelectedInventorName' : searchTextAuto,
            'listInvidsSelected':listinvids
        });
        action.setCallback(
            this,
            $A.getCallback
            (
            function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                var ReturnResponse = response.getReturnValue();
                component.set('v.InValidInventor',false);
                //alert('response for auto success'+ReturnResponse);
                component.set('v.SelectedInventor',ReturnResponse.label);
                //component.set("v.listOfSelectedRecords",'')
                component.set('v.record.Name',ReturnResponse.label);
                component.set('v.record.Recid',ReturnResponse.Recid);
                component.set('v.record.EmailId',ReturnResponse.EmailId);
                component.set('v.record.InventorName',ReturnResponse.InventorName);
                var index = component.get('v.rowIndex');
                //component.set('v.record.IsPrimary',component.find("IsPrimaryInventor").get('v.checked'));
                component.set('v.record.IsPrimary',false);
                component.set('v.record.IndexVal',index);
                //alert('Child Helper index set'+component.get('v.record.Recid')+'from ctrl-->'+ReturnResponse.Recid);
                //alert('Record id of inv -->'+ReturnResponse.name);
                //alert('Selected inv -->'+component.get('v.SelectedInventor'));
                //alert('Inventor selecting'+JSON.stringify(component.get('v.record')));
                //alert('Calling   ----->'+component.get('v.record.IsPrimary'));
                if((ReturnResponse.Recid == '' || ReturnResponse.Recid == null) && !component.get('v.ErrorVariable'))
                {
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": 'error',
                        "message": "Invalid Inventor(s)..."
                    });
                    toastEvent.fire();*/
                    //alert('Recid -->'+ReturnResponse.Recid);
                    component.set('v.ErrorVariable',true);
                }
                else
                {
                    component.set('v.ErrorVariable',false);
                    if(ReturnResponse.Recid != '' || ReturnResponse.Recid != null)
                    {
                        var cmp = $A.get('e.c:SelectedInventorEvt');
                        cmp.setParams({'SelectedinvId':ReturnResponse.Recid});
                        cmp.fire();
                    }
                }
                var cmp = $A.get('e.c:OnSaveCheckValidInventor');
                cmp.setParams({'InvalidInv':component.get('v.ErrorVariable')});
                cmp.fire();
                var cmp = $A.get('e.c:InventorEvt');
                cmp.setParams({'InventorRecord':component.get('v.record')});
                cmp.fire();
            }
            else if(state === 'ERROR')
            {
                //alert('response for auto fail'+ReturnResponse);
                //component.set('v.InValidInventor',true);
                //if(component.get('v.InValidInventor') == true)
                //{
                    //alert(' error if');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": 'error',
                        "message": "Invalid Inventor selected..."
                    });
                    toastEvent.fire();
                //}
                /*var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        alert(errors[0].message );//Fetching Custom Message.
                    }
                }*/
            }
        }));
        $A.enqueueAction(action);
    }
})