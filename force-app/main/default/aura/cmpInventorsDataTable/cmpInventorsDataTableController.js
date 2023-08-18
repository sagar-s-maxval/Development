({
    doinit : function(component, event,helper)
    {
        component.set('v.counter',0);
        //alert('record -->'+JSON.stringify(component.get('v.record')));
    },
    
    searchController : function(component, event,helper)
    {
        //alert('search ctrl');
        var cnt = component.get('v.counter');
        //alert(cnt+'cnt');
        var isEscKey = event.keyCode === 27;
        var isTabKey = event.keyCode === 9;
        var searchText = component.find("SearchTxt").get("v.value");
        //alert('Search if -->'+component.get('v.listOfSelectedInventorIds'));
        //alert('Search text --->'+searchText);
        //alert('length---->'+searchText.length);
        //alert('inventor Id '+component.get('v.record'));
        
        if (isEscKey || searchText.length === 0 || isTabKey)
        {
            component.set('v.isShowSearchResult',false);
            //alert('component.get("v.rowIndex")'+component.get("v.rowIndex"));
            //alert('new alert'+JSON.stringify(component.get('v.record')));
            var Inventorrecord = component.get('v.record');
            Inventorrecord.IndexVal=component.get("v.rowIndex");
            component.set('v.record',Inventorrecord);
            var cmp = $A.get('e.c:InventorEvt');
            cmp.setParams({'InventorRecord':component.get('v.record')});
            cmp.fire();
            
            //--------
            //alert('row value'+component.get("v.rowIndex"));
            //alert('Search if -->'+component.get('v.listOfSelectedInventorIds'));
            //alert('length '+component.get('v.listOfSelectedInventorIds').length);
          
            
            if(component.get('v.listOfSelectedInventorIds').length != 0)
            {
                var cmp = $A.get('e.c:RowIndexEvt');
                cmp.setParams({'RowIndexValue':component.get("v.rowIndex")});
                cmp.fire();
            }
             /* component.set('v.ErrorVariable',true);
             var cmp = $A.get('e.c:OnSaveCheckValidInventor');
                cmp.setParams({'InvalidInv':component.get('v.ErrorVariable')});
                cmp.fire();*/
            //---------
        }
        else if(searchText.length >= 3)
        {
            
            component.set('v.ErrorVariable',false);
            cnt = cnt + 1;
            component.set('v.counter',cnt);
            //	alert('row value'+component.get("v.rowIndex")); 
            //alert('counter'+component.get('v.counter'));
            if(component.get('v.counter') == 1 && searchText.length >3)
            {
                //alert('if');
                component.set('v.counter',0);
                component.set('v.isShowSearchResult',false);
                //alert('existing rec ids-->'+component.get('v.listOfSelectedInventorIds'));
                helper.handleAutoSuggestion(component,event,searchText,component.get('v.listOfSelectedInventorIds'));
                
                //alert(' error '+component.get('v.InValidInventor'));
				               
            }else
            //var listOfSelectedInvIds = [];
            //listOfSelectedInvIds.push(component.get('v.listOfSelectedInventorIds'));
            //alert('Already existing records --->'+component.get('v.listOfSelectedInventorIds'));
            helper.searchControllerHelper(component,event,searchText,component.get('v.listOfSelectedInventorIds'));
        }
        //alert('searchText'+searchText);
        
    },
    
    SelectedInventorsController : function(component, event,helper)
    {
        //alert('On change');
        var selectedInventorIds = component.find("lstAvailableInventors").get('v.value');
        if(selectedInventorIds =='' || selectedInventorIds==undefined)
        {
            //alert('null check');
            return false;
        }
        var listSelectedRecords = component.get("v.listOfSelectedRecords");
        listSelectedRecords.push(selectedInventorIds);
        component.set("v.listOfSelectedRecords",listSelectedRecords);
        //alert('records----'+JSON.stringify(listSelectedRecords));
        component.set("v.isShowSearchResult",false);
        component.find("SearchTxt").set("v.value",'');
        //alert('selected id '+selectedInventorIds);
        var cmp = $A.get('e.c:SelectedInventorEvt');
        cmp.setParams({'SelectedinvId':selectedInventorIds});
        cmp.fire();
        helper.SelectedInventorsControllerHelper(component,event,selectedInventorIds);
        
    },
    
    /*AddNewRow : function(component, event, helper){
        component.getEvent("AddRowEvt").fire(); 
        //alert('Fired add row');
    },*/
    
    setInventorIds : function(component, event)
    {
        var listofInvIdsFromEvt = event.getParam("InvIdsList");
        component.set('v.listOfSelectedInventorIds',listofInvIdsFromEvt);
        //alert('List child Inv ids --->>>> '+listofInvIdsFromEvt);
        //alert('set -- >>>> -- '+component.get('v.listOfSelectedInventorIds'));
    },
    
    removeRow : function(component, event, helper){
        //alert('remove row');
        //alert('row index'+component.get("v.rowIndex") );
        var cmpEvent = $A.get('e.c:FooterDeleteRowEvt');
        cmpEvent.setParams({"InventorRowAfterDeletion" : component.get("v.rowIndex") });
        cmpEvent.fire();
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
        
    },
    
    inventorIsPrimary : function(component, event)
    {
        var checkbox = component.find("IsPrimaryInventor");
        var checkboxval = checkbox.get("v.value");
        //alert('checkboxval: ' + checkboxval);
        component.set('v.record.IsPrimary',checkboxval);
        var cmpEvent = component.getEvent("AddRowEvt");
        cmpEvent.setParams({"indexVal" : component.get("v.rowIndex"),"PrimaryChkStatus" : checkboxval });
        cmpEvent.fire();
        var cmp = $A.get('e.c:IsPrimaryEvt');
        cmp.setParams({"IsPri" : checkboxval, 'RowIndexValue':component.get("v.rowIndex")});
        cmp.fire(); 
        //alert('Index val child'+component.get("v.rowIndex"));
    },
    //----------------------- SAVE BUTTON REPLACEMENT -----------------
    SetRoleOfConception : function (component, event)
    {
        var roleofConception = component.find('ROC').get('v.value');
        //alert('roleofConception'+roleofConception);
        var cmp = $A.get('e.c:RoleOfConceptionEvt');
        cmp.setParams({"RoleOfConception" : roleofConception, 'RowInd':component.get("v.rowIndex")});
        cmp.fire();
        //alert('Fired roc');
    }
    //-----------------------------------------------------------------
})