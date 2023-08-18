({
    /*loadValuesController : function(component,event, helper) 
    {
        //Add inventors new -- begin
        
        var initRec = {'sobjectType' : 'WrapperInventorInfo','Name' : '','RoleOfConception':'','IsPrimary':'' };
        component.set("v.records", initRec);
        
        //--end
        // Initialize input select options
        //alert("onload");
        //alert('DisclosureId id --->'+component.get("v.DisclosureId"));
        if(component.get("v.DisclosureId")!=false && component.get("v.DisclosureId")!=null )
        {   
            //alert('DisclosureId id addinv --->'+component.get("v.DisclosureId"));
            var action = component.get('c.populateAdditionalInventors');
            action.setParams({ DisclosureId : component.get("v.DisclosureId") });
            action.setCallback
            (this,$A.getCallback
             ( function (response) 
              {   
                  var state = response.getState();
                  var result = response.getReturnValue();
                  //alert(JSON.stringify(result));
                  //alert(result.length +"len");
                  if(result.length > 0){
                      if (state == "SUCCESS") 
                      {  
                          component.set("v.lstSelectedInventors", result);
                          var selectedInventorId;
                          var arrSelectedInventorIdsValue;
                          var i;
                          for(i=0;i<result.length;i++)
                          {   
                              selectedInventorId=result[i].name;
                              arrSelectedInventorIdsValue = component.get("v.arrSelectedInventorIds");
                              arrSelectedInventorIdsValue.push(selectedInventorId);
                          } 
                          component.set("v.arrSelectedInventorIds", arrSelectedInventorIdsValue);
                          component.set("v.strSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
                      }
                      
                  }
                  else if (state === "ERROR") 
                  {
                      var errors = response.getError();
                      //alert(JSON.stringify(errors));
                      console.error(errors);
                  }
              }
             )
            )
            $A.enqueueAction(action);
        }
    },
    searchInventorsController: function (component, evt, helper) 
    {
        var isEscKey = evt.keyCode === 27;
        if (isEscKey)
        {
            //alert('xdf');
            component.set('v.isShowSearchResult',false);
        }
        else
        {
            var txtSearchInventors = component.find('txtSearchInventors').get('v.value');
            //alert(txtSearchInventors+'txtSearchInventors');
            var arrSelectedInventorIdsValue = component.get("v.arrSelectedInventorIds");
            //alert(arrSelectedInventorIdsValue+'arrSelectedInventorIdsValue');
            helper.searchInventorsHelper(component, txtSearchInventors, arrSelectedInventorIdsValue);
        }
    },
    removeSelectedInventorsController: function (component, event) 
    {
        var selectedInventorId = event.getParam("item").name;
        
        // Remove the pill from view
        var items = component.get('v.lstSelectedInventors');
        var item = event.getParam("index");
        items.splice(item, 1);
        component.set('v.lstSelectedInventors', items); 
        
        var arrSelectedInventorIdsValue = component.get("v.arrSelectedInventorIds");
        var index = arrSelectedInventorIdsValue.indexOf(selectedInventorId);
        if (index > -1) {
            arrSelectedInventorIdsValue.splice(index, 1);
        }
        component.set("v.arrSelectedInventorIds", arrSelectedInventorIdsValue);
        component.set("v.strSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
    },
    getSelectedInventorsController: function(component, event, helper) 
    {
        var selectedInventorId = component.find("lstAvailableInventors").get("v.value");
        //alert(selectedInventorId+'selectedInventorId');
        var arrSelectedInventorIdsValue = component.get("v.arrSelectedInventorIds");
        //alert(component.get("v.arrSelectedInventorIds")+'arrSelectedInventorIdsValue');
        arrSelectedInventorIdsValue.push(selectedInventorId);
        component.set("v.arrSelectedInventorIds", arrSelectedInventorIdsValue);
        component.set("v.strSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
        component.set('v.isShowSearchResult',false);
        helper.getSelectedInventorsHelper(component, component.get("v.arrSelectedInventorIds"));
        component.find('txtSearchInventors').set('v.value','');
        component.find('txtSearchInventors').focus();
        //helper.getSelectedInventorsHelper(component);
        //alert('Values:' + component.get("v.arrSelectedInventorIds"));
    },
    
    //Add inventors new -- begin
    addRow : function(component, event, helper)
    {
        	alert('Add row');
        var ExistingRecords = component.get('v.records');
        //alert('records -- > '+ExistingRecords);
        /*ExistingRecords.push({'sobjectType' : 'WrapperInventorInfo',
                      'Name' : component.find("SearchTxt").get('v.value'),
                      'RoleOfConception' : component.find("InventorRole").get('v.value'),
                      'IsPrimary': component.find("PrimaryInventor").get('v.checked')});
        /*var addRec = {'sobjectType' : 'WrapperInventorInfo',
                      'Name' : '',
                      'RoleOfConception' : '',
                      'IsPrimary':''};* /
        
        alert('Inventor name -->'+component.find("SearchTxt").get('v.value'));
        alert('Role of conmception -->'+component.find("InventorRole").get('v.value'));
        alert('IsPrimary -->'+component.find("PrimaryInventor").get('v.checked'));
        //var ExistingRecords = component.get('v.records');
        alert('ExistingRecords -->'+JSON.stringify(ExistingRecords));
        //alert('addrec -->'+JSON.stringify(addRec));
        //ExistingRecords.push(addRec);
        component.set('v.records',ExistingRecords);
        alert('Record set contains -->'+JSON.stringify(component.get('v.records')));* /
        	var addRec = {'sobjectType' : 'WrapperInventorInfo',
                      'Name' : '',
                      'RoleOfConception' : '',
                      'IsPrimary':''};
        	ExistingRecords.push(addRec);
       		component.set('v.records',ExistingRecords);
        	alert('ExistingRecords -->'+ExistingRecords);
        	alert('Final List -->'+JSON.stringify(component.get('v.records')));
        //component.set('v.SelectedInventor','');
        
    },
    
    removeRow : function(component, event, helper)
    {
        var indexposition = event.target.name;
        var existingrecords = component.get('v.records');
        existingrecords.splice(indexposition,1);
        component.set('v.records',existingrecords);
    },*/
    /*ChangeValue : function(component,event, helper) 
    {
    	var lstrecs = component.set('v.records');
        var index = component.get('v.index');
    	component.set('v.value', lstrecs[index]);
    },*/
    /*searchController : function(component, event,helper)
    {
        
        var isEscKey = event.keyCode === 27;
        var searchText = component.find("SearchTxt").get("v.value");
        //alert('search key -->'+searchText);
        //alert('Search text --->'+searchText);
        if (isEscKey || searchText.length === 0)
        {
            component.set('v.isShowSearchResult',false);
        }
        else if(searchText.length >= 3)
        {
            helper.searchControllerHelper(component,event,searchText);
        }
    },
    
    SelectedInventorsController : function(component, event,helper)
    {
        var selectedInventorIds = component.find("lstAvailableInventors").get('v.value');
        var listSelectedRecords = component.get("v.arrSelectedInventorIds");
        listSelectedRecords.push(selectedInventorIds);
        alert('Selected id -->'+listSelectedRecords);
        component.set("v.arrSelectedInventorIds",listSelectedRecords);
        component.set("v.strSelectedInventorIds",listSelectedRecords.join(','));
        alert('Selected list of ids -->'+component.get("v.strSelectedInventorIds"));
        alert('List of ids -->'+component.get("v.arrSelectedInventorIds"));
        component.set("v.isShowSearchResult",false);
        component.find("SearchTxt").set("v.value",'');
        helper.SelectedInventorsControllerHelper(component,event,selectedInventorIds);
   },*/
    
     loadValuesController : function(component,event,helper) 
    {
        
        var IPLegalLink = 'mailto:patents@uhg.com?cc=garrett.miedema@uhg.com&subject=ISM: Request Update to Inventor List for '+component.get('v.DisplayDocketNo')+': '+component.get('v.DisplayTitle');
        component.set('v.DisplayText',IPLegalLink);
        //alert('Hyperlink -->'+component.get('v.DisplayText'));
        var IDFRecordId = component.get('v.DisclosureId');
        //alert('IDFRecordId Controller -->'+IDFRecordId);
        if(component.get('v.DisclosureId') != null && component.get('v.DisclosureId') != "false") 
        {
            
            helper.LoadRecordsOnEdit(component,component.get('v.DisclosureId'));
            
            //----
            var cmp = $A.get('e.c:SelectedInventorsListEvt');
            cmp.setParams({'InvIdsList' : component.get('v.lstInventors')});
            cmp.fire();
            
        }
        else
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
                    'IsPrimary': false,
                    'EmailId':'',
                	'InventorName':'',
                    
                    'IndexVal':''
                });
                component.set("v.records", RowItemList);
                component.set("v.PriamryInvSelected",false);
                //alert('Primary -- '+component.get('v.PriamryInvSelected'));
                //alert('On Load---  '+JSON.stringify(component.get("v.records")));
            }
        }
        
    },
    
    
    removeDeletedRow : function(component, event, helper)
    {
        var index = event.getParam("indexVar");
        //alert('index'+index);
        var AllRowsList = component.get("v.records");
        //alert('AllRowsList'+AllRowsList.length);
        if(AllRowsList.length > 0)
        {
        	AllRowsList.splice(index,1);
        }
        component.set('v.records',AllRowsList);
        //component.get('v.lstInventors',splice(index,1));
        //Added on 03/06/2020
        var listInventors = component.get('v.lstInventors');
        listInventors.splice(index,1);
        component.set('v.lstInventors',listInventors);
        //-------------------
        //alert('list on delete '+component.get('v.lstInventors'));
    },
    
    addNewRow: function(component, event, helper) 
    {
        //helper.createObjectData(component, event,helper);
        var listOfInvsIds = component.get('v.lstInventors');
        /*var cmp = $A.get('e.c:SelectedInventorsListEvt');
        cmp.setParams({'InvIdsList' : listOfInvsIds});
        cmp.fire();*/
        helper.addNewRow(component, event, helper);
        component.set('v.SuccessMsg',false);
        
    },
    
    RemoveInventorFromList : function(component, event)
    {
        //alert('--------------');
        var RowIndexPassed = event.getParam("RowIndexValue");
        //alert('RowIndexPassed'+RowIndexPassed);
        var listRecords = component.get('v.records');
        //alert('listRecords '+JSON.stringify(listRecords));
        var InvRecord = listRecords[RowIndexPassed];
        //alert('InvRecord'+InvRecord);
        listRecords.splice(RowIndexPassed,1);
        //alert('listRecords -- removing from list'+listRecords);
        InvRecord.Recid = '';
        //alert('Inv Record after removing recid'+InvRecord.Recid);
        listRecords.splice(RowIndexPassed,0,InvRecord);
        //alert('listRecords'+JSON.stringify(listRecords));
        var listinvidstopass = component.get('v.lstInventors');
        //alert('listinvidstopass'+listinvidstopass);
        listinvidstopass.splice(RowIndexPassed,1);
        //alert('After splicing listinvidstopass'+listinvidstopass);
    },
    
    AddSelectedInvToList : function(component, event)
    {
        var listInventorsId = component.get('v.lstInventors');
        //alert('before'+listInventorsId);
        var invId = event.getParam("SelectedinvId");
        /*for(var i=0; i<listInventorsId.length; i++)
        {
            if(listInventorsId[i] == invId)
            {
                component.set('v.DuplicateInventor',true);
            }
        }
        if(component.get('v.DuplicateInventor') == false)
        {*/
        	listInventorsId.push(invId);
        //}
        component.set('v.lstInventors',listInventorsId);
        //alert('list --- '+listInventorsId);
    },
    
    CheckBoxValidation:function(component, event)
    {
        var indexVal = event.getParam("indexVal");
        //alert('Parent index value ---    '+indexVal);
        var checkboxval = event.getParam("PrimaryChkStatus");
        //alert('Parent checkboxval value ---    '+checkboxval);
        
        var lstInventorsRecords = component.get('v.records');
        //alert('lstInventorsRecords ---'+lstInventorsRecords);
        for(var i=0; i < lstInventorsRecords.length; i++)
        {
            //alert(lstInventorsRecords[i].IndexVal);
           	if(lstInventorsRecords[i].IndexVal != indexVal)
            {
                lstInventorsRecords[i].IsPrimary = false;
                //alert('IF NOT Primary'+lstInventorsRecords[i].IsPrimary);
                /*if(lstInventorsRecords[i].IsPrimary == true)
                {
                    //alert('Before Isprimary IF-->'+lstInventorsRecords[i].IsPrimary);
                    lstInventorsRecords[i].IsPrimary = false;
                    //alert('After Isprimary IF-->'+lstInventorsRecords[i].IsPrimary);
                }*/
            }
            else
            {	
                
                if(checkboxval==true)
                lstInventorsRecords[i].IsPrimary = true;
                //alert('ELSE Priamry'+lstInventorsRecords[i].IsPrimary);
            }
        }
        component.set('v.records',lstInventorsRecords);
        
        //alert('Onsetting -->'+JSON.stringify(component.get('v.records')));
	},
    
    handleClick : function(component, event, helper)
    {
        //var ListOfInventorsWithRole = component.get('v.records');
        //alert('handle click -->'+JSON.stringify(ListOfInventorsWithRole));
        var listOfInventorIds = [];
        var listOfConcatenatedInfoInvs = [];
        var validate = helper.validateRequired(component, event,helper);
        //alert('validate -- '+component.get('v.records'));
        var cmp = $A.get('e.c:SelectedInventorsListFooterEvt');
        cmp.setParams({'InventorsList':component.get('v.records')});
        cmp.fire();
        var ListOfInventorsWithRole = component.get('v.records');
        if(validate)
        {
            for(var i=0; i < ListOfInventorsWithRole.length; i++)
            {
                var recordval = ListOfInventorsWithRole[i];
                listOfInventorIds.push(recordval.Recid);
                component.set('v.strSelectedInventorIds',listOfInventorIds.join(','));
                
                listOfConcatenatedInfoInvs.push(recordval.Recid+'<#>'+recordval.RoleOfConception+'<#>'+recordval.IsPrimary);
                component.set('v.strSelectedInventorInfo',listOfConcatenatedInfoInvs.join('<###>'));
                //alert('Handle click-->'+recordval.IsPrimary);
            }
            component.set('v.SuccessMsg',true);
            component.set('v.ErrorMessage','Successfully added inventors to the disclosure!');
            
            //$A.enqueueAction(action);
            
        }
        else 
        {
            //alert('else -- '+ListOfInventorsWithRole + '---SIZE-----'+ListOfInventorsWithRole.length);
            if(ListOfInventorsWithRole.length === 0 )
            {
                helper.createObjectData(component, event,helper);
            }
            //alert('records ----> '+component.get('v.records'));
            if(component.get('v.ValidatePrimaryInventor') == false)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type": 'error',
                    "message": "Please fill the details of Inventors..."
                });
                toastEvent.fire();
            }
        }
        
    },
    
    SetFinalValue:function(component, event, helper)
    {
        //alert('Additional Inventors');
        var selectedids = event.getParam('strSelectedInventorIdsEvt');
        //alert('selectedids >>>>>>>> '+JSON.stringify(selectedids));
        var selectedidswithconcatenatedvalues = event.getParam('strSelectedInventorInfoEvt');
         //alert('selectedidswithconcatenatedvalues >>>>>>> '+JSON.stringify(selectedidswithconcatenatedvalues));
        component.set('v.strSelectedInventorIds',selectedids);
        component.set('v.strSelectedInventorInfo',selectedidswithconcatenatedvalues);
        
    }
    //--end
    
})