({
    
	/*searchInventorsHelper : function(component, txtSearchWord, arrSelectedInventorIds) 
    {
        //alert(txtSearchWord);
        var action = component.get('c.searchInventors');
        action.setParams({ searchWord : txtSearchWord, inventorIds :arrSelectedInventorIds });
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
                        //component.set('v.lstInventors',result);
                        //component.find("lstAvailableInventors").set("v.options", result);
                        if (result.length>0)
                        {
                            component.set('v.isShowSearchResult',true);
                            component.find("lstAvailableInventors").set("v.options", result);
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
    getSelectedInventorsHelper : function(component, arrSelectedInventorIds) 
    {
        var action = component.get('c.getSelectedInventors');
        action.setParams({ inventorIds : arrSelectedInventorIds });
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
                        component.set("v.lstSelectedInventors", result);
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
	},* /
    
    searchControllerHelper : function(component,event,searchText)
    {
        var action = component.get("c.SearchInventors");
        action.setParams({
            'searchKeyWord' : searchText,
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
                component.find('lstAvailableInventors').set("v.options",result);
                //alert('Return value from search -->'+JSON.stringify(result));
            }
            else if(state === 'ERROR')
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        alert(errors[0].message );//Fetching Custom Message.
                    }
                }
            }
        }));
        $A.enqueueAction(action);
    },
    
    SelectedInventorsControllerHelper : function(component,event,selectedInventorIds)
    {
        var action = component.get('c.getInventors');
        //alert('Selected id helper -->'+selectedInventorIds);
        action.setParams({
            'inventorIds' : selectedInventorIds,
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
                    //alert('returned selected record -->'+JSON.stringify(ReturnResponse));
                    component.set('v.SelectedInventor',ReturnResponse.label);
                    //alert('Result -->'+ReturnResponse.label);
                    
                    //component.set("v.arrSelectedInventorIds",'')
                    //alert('Selected inv -->'+component.get('v.SelectedInventor'));
                }
                else if(state === 'ERROR')
                {
                    var errors = response.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            alert(errors[0].message );//Fetching Custom Message.
                        }
                    }
                }
                
            }
        ));
        $A.enqueueAction(action);
    },*/
    
    LoadRecordsOnEdit : function(component, IDFId)
    {
        var action = component.get('c.populateAdditionalInventors');
        action.setParams({"InventionDisclosureId" : IDFId});
        action.setCallback
        (
            this,
            $A.getCallback
            (
            function(response)
            {
                var state = response.getState();
                //alert('result'+JSON.stringify(response.getReturnValue()));
                if(state === "SUCCESS")
                {
                    //alert('Additional inv cmp'+JSON.stringify(response.getReturnValue()));
                    component.set('v.records',response.getReturnValue());
                    var ListOfInventorsWithRole = component.get('v.records');
                    //alert('length--'+ListOfInventorsWithRole.length);
                    var listOfInventorIds = [];
                    var listInventorIds = [];
                    var listOfConcatenatedInfoInvs = [];
                    for(var i=0; i < ListOfInventorsWithRole.length; i++)
                    {
                        
                        var recordval = ListOfInventorsWithRole[i];
                        listOfInventorIds.push(recordval.Recid);
                        //alert('ROC add cmp '+recordval.RoleOfConception);
                        //alert('IsPrimary add cmp '+recordval.IsPrimary);
                        component.set('v.strSelectedInventorIds',listOfInventorIds.join(', '));
                        listOfConcatenatedInfoInvs.push(recordval.Recid+'<#>'+recordval.RoleOfConception+'<#>'+recordval.IsPrimary+'<#>'+recordval.EmailId);
                        component.set('v.strSelectedInventorInfo',listOfConcatenatedInfoInvs.join('<###>'));
                        listInventorIds.push(ListOfInventorsWithRole[i].Recid);
                    }
                    //alert('add cmp strSelectedInventorIds'+component.get('v.strSelectedInventorIds'));
                    //alert('add cmp strSelectedInventorInfo'+component.get('v.strSelectedInventorInfo'));
                    var cmp = $A.get('e.c:OnloadSelectedInventorsEvt');
                    cmp.setParams({'FinalRecordsLst' : component.get('v.records')});
                    cmp.fire();
                    component.set('v.lstInventors',listInventorIds);
                    
                    
                }
                else if(state === 'ERROR')
                {
                    var errors = response.getError();
                    if(errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            //alert(errors[0].message );//Fetching Custom Message.
                        }
                    }
                }
                
            }
            )
        )
        $A.enqueueAction(action);
        
    },
    
    
    createObjectData: function(component, event,helper) 
    {
        var RowItemList = component.get("v.records");
        var lstCount = RowItemList.length;
        if(lstCount==0)
        {
            RowItemList.push({
                'sobjectType' : 'WrapperInventorInfo',
                'Recid':'',
                'Name' : '',
                'RoleOfConception' : '',
                'IsPrimary':false,
                'EmailId':'',
                'InventorName':'',
                'IndexVal':lstCount
            });
            component.set("v.records", RowItemList);
        }
    },
    addNewRow: function(component, event, helper) 
    {
        var RowItemList = component.get("v.records");
        var IndexVal=0; 
        if(RowItemList!=null)
        {
            IndexVal = RowItemList.length;
        }
        //alert(IndexVal);
        RowItemList.push({
                'sobjectType' : 'WrapperInventorInfo',
                'Recid':'',
                'Name' : '',
                'RoleOfConception' : '',
                'IsPrimary':false,
            	'EmailId':'',
            	'InventorName':'',
            
                'IndexVal':IndexVal
            });
        component.set("v.records", RowItemList);
    },
    
    validateRequired: function(component, event) {
        var isValid = true;
        var isPrimary = false;
        var countInventors = 0;
        var allRecordsRows = component.get("v.records");
        var isprimaryinv = component.get('v.PriamryInvSelected');
        //alert('isprimaryinv'+isprimaryinv);
        //alert('Records accessed -->'+JSON.stringify(allRecordsRows));
        var InventorIdsList = component.get('v.lstInventors');
        //alert('Records fetched list size --- >'+allRecordsRows.length);
        var PrimaryAddedInList = false;
        for(var indexVar = 0; indexVar < allRecordsRows.length; indexVar++) 
        {
            if(allRecordsRows[indexVar].IsPrimary != true)
            {
                allRecordsRows[indexVar].IsPrimary = false;
            }
            else if(allRecordsRows[indexVar].IsPrimary == true)
            {
                PrimaryAddedInList = true;
            }
        }
        //alert('allRecordsRows after --->'+JSON.stringify(allRecordsRows));
        for(var indexVar = 0; indexVar < allRecordsRows.length; indexVar++) 
        {
            //alert('Iteration---'+indexVar);
            //alert('allRecordsRows[indexVar].Name'+allRecordsRows[indexVar].Name);
            //alert('allRecordsRows[indexVar].RoleOfConception'+allRecordsRows[indexVar].RoleOfConception);
            //alert('allRecordsRows[indexVar].IsPrimary'+allRecordsRows[indexVar].IsPrimary);
            if(allRecordsRows[indexVar].Name === '' && allRecordsRows[indexVar].RoleOfConception === '')
            {
            	
                InventorIdsList.splice(indexVar,1);
                //alert('splice list'+InventorIdsList);
                
            }
            if(allRecordsRows[indexVar].Name === '') 
            {
                //alert('name'+allRecordsRows[indexVar].Name);
               
                isValid = false;
            }
            else if(allRecordsRows[indexVar].RoleOfConception === '')
            {
               
                isValid = false;
            }
        
            /*if(allRecordsRows[indexVar].Name != '' && allRecordsRows[indexVar].RoleOfConception != '' && isprimaryinv === false && allRecordsRows[indexVar].IsPrimary != true)
            {
               
                isPrimary = true;
            }
            else */if(allRecordsRows[indexVar].IsPrimary == false)
            {
                if(allRecordsRows[indexVar].Name != '' && allRecordsRows[indexVar].RoleOfConception != '' )
                {
                	if(PrimaryAddedInList != true)
                    {
                    	isPrimary = true;
                    }
                }
                else
                {
                    
                    component.set('v.ValidatePrimaryInventor',false);
                    //allRecordsRows.splice(indexVar,1); 
                   
                }
            }
            else
            {
                component.set('v.ValidatePrimaryInventor',false);
                isPrimary = false;
                //break;
                
                
            }
            //alert('break'+countInventors+'----isValid-----'+isValid);
            //alert('size end='+allRecordsRows.length);
        }    
        
        component.set('v.records',allRecordsRows);
        component.set('v.lstInventors',InventorIdsList);
        //lert('list of ids '+InventorIdsList);
        //alert('list--'+component.get('v.records'));
        if(isPrimary == true)
        {
           
           component.set('v.ValidatePrimaryInventor',true);
            component.set('v.SuccessMsg',false);
            //component.set('v.ErrorMessage', 'Please select First Named Inventor!');
            //alert('records helper on isprimary true get----> '+component.get('v.records'));
            component.set('v.records',allRecordsRows);
            //alert('records helper on isprimary true set----> '+component.get('v.records'));
        }
        if(isPrimary == false)
        {
            component.set('v.ValidatePrimaryInventor',false);
            component.set('v.SuccessMsg',false);
            component.set('v.records',allRecordsRows);
            //alert('returned ---> '+isValid);
            return isValid;
        }
        //alert('isValid value --- >'+isValid);
    }
})