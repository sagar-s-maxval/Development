({
    loadfamilyList: function(component, event, helper) {
        helper.onLoad(component, event);
        
    },
    /*loadCasetype : function (component, event, helper) {
        //alert('Helper');
         helper.getCasetype(component);	
	},*/
    familyRefereshwin: function(component, event, helper) {        
        helper.onLoad(component, event);
    },
    familydatasync: function(component, event, helper) {
       helper.syncfamilydata(component, event);
    },
    closefamilyExpand: function(component, event, helper) {        
        component.set("v.isExpand",false);
    },
    familyExpand: function(component, event, helper) {        
        component.set("v.isExpand",true);
    },
    // to create new family record
    openfmlyModel: function(component, event, helper) {
        component.set("v.isCreateOpen", true);
    },	
    /*openModel: function(component, event, helper) {
        //alert('OpenModel');
        component.set("v.isCreateOpenModel",true);
        event.preventDefault();
        //alert('CreateModel'+component.get("v.isCreateOpenModel"));
    },*/
     showToolTip : function(component, event, helper) {
        component.set("v.tooltip" , true);
    },
     HideToolTip : function(component, event, helper){
        component.set("v.tooltip" , false);
    },
    closefmlyModel: function(component, event, helper) {
        component.set("v.isCreateOpen", false);
        component.set('v.lstSelectedBasePatents',null);
        
    },
    closeModel: function(component, event, helper) {
        component.set("v.isCreateOpen", false);
    },
    searchBasePatentController: function(component, event, helper) {
        
        var isEscKey = event.keyCode === 27;
        if (isEscKey)
        {
            component.set('v.isShowSearchBaseResult',false);
        }
        else
        { 
            //alert("Search");
            var txtSearchBasePatents = component.find('txtSearchBasePatents').get('v.value');
            var arrSelectedBasePatentIdsValue = component.get("v.arrSelectedBasePatentIds");
            if(txtSearchBasePatents.length>2)
            { 
                helper.searchBasePatentsHelper(component, txtSearchBasePatents, arrSelectedBasePatentIdsValue);
            }
             else
            {
                component.set('v.isShowSearchBaseResult',false);
                
            }   
            
        }
    },
     getSelectedBasePatentController: function(component, event, helper) 
    {
        //alert('Enter Get controller');
		var selectedBasePatentId = component.find("lstAvailableBasePatents").get("v.value");
        //alert('Selected IDs'+selectedBasePatentId);
        var arrSelectedBasePatentIdsValue = component.get("v.arrSelectedBasePatentIds");
        
        arrSelectedBasePatentIdsValue.push(selectedBasePatentId);
        component.set("v.arrSelectedBasePatentIds", arrSelectedBasePatentIdsValue);
        //alert('Array'+component.get("v.arrSelectedBasePatentIds"));
        component.set("v.strSelectedBasePatentIds", arrSelectedBasePatentIdsValue.join(","));
        //alert('Array string'+component.get("v.strSelectedBasePatentIds"));
        component.set('v.isShowSearchBaseResult',false);
        //------------
        component.set('v.test',component.get("v.arrSelectedBasePatentIds"));
        //-----------
        helper.getSelectedBasePatentsHelper(component, component.get("v.arrSelectedBasePatentIds"));
        component.find('txtSearchBasePatents').set('v.value','');
        component.find('txtSearchBasePatents').focus();
        
	},
     removeSelectedBasePatentsController: function (component, event) 
    {
        var selectedPatentId = event.getParam("item").name;
        
        // Remove the pill from view
        var items = component.get('v.lstSelectedBasePatents');
        //alert('Items'+items);
        var item = event.getParam("index");
        items.splice(item, 1);
        component.set('v.lstSelectedBasePatents', items); 

        var arrSelectedBasePatentIdsValue = component.get("v.arrSelectedBasePatentIds");
        var index = arrSelectedBasePatentIdsValue.indexOf(selectedPatentId);
        if (index > -1) {
  			arrSelectedBasePatentIdsValue.splice(index, 1);
		}
        component.set("v.arrSelectedBasePatentIds", arrSelectedBasePatentIdsValue);
        component.set("v.strSelectedBasePatentIds", arrSelectedBasePatentIdsValue.join(","));

    },
    //to create a family record
    createfmlyrec: function(component, event, helper) {     
     var action = component.get("c.creatfmlyRecord");
     var selectedbasePatentrec = component.get("v.test");
      //var selectedParentPatentrec = component.get("v.test1"); 
     //var selectedCaseType=  component.find("CaseType").get("v.value");
    //alert('Case Type:'+selectedCaseType);
        action.setParams({"fmlyobject":component.get("v.fmlyobject"), "AssetId": component.get("v.recordId"),"selectedbaseRec": selectedbasePatentrec});
        //alert('Reocrd Id-->>' + component.get("v.recordId"));
            action.setCallback(this,function(result){
            component.set("v.isCreateOpen", false);
            var fmly = result.getReturnValue();
            //alert('fmly'+fmly); 
       // component.set('v.lstSelectedParentPatents',null);
        component.set('v.lstSelectedBasePatents',null);
         //component.set('v.fmlyobject.Filing_Date__c',null);     
        });
         $A.enqueueAction(action);
    },	  
})