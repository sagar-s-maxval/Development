({
    onLoad: function(component, event)
    {
       // alert('onLoad call');
        //console.log('onLoad call');
        //call apex class method
        
        component.set('v.arrSelectedBasePatentIds','');
        var action = component.get('c.fetchfamilys');
        action.setParams({
            "AssetId": component.get("v.recordId")
        });
        //alert('Reocrd Id-->>' + component.get("v.recordId"));
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListofIFW attribute on component.
                var objData = response.getReturnValue();
                component.set('v.Listoffamily', objData);
                 //alert(JSON.stringify(objData));
            }
            console.log('Data : '+JSON.stringify(response.getReturnValue()));
        });
         /*var action = component.get("c.fetchPatentList");       
       action.setCallback(this, function(response){
            var state = response.getState();
           alert('Response'+state);
            if (state === "SUCCESS") {
                var objPatentData= response.getReturnValue();
                component.set("v.PatentList",objPatentData);
                alert(JSON.stringify(objPatentData));
            }
            alert(component.get("v.PatentList"));
       });*/
        $A.enqueueAction(action);
    },   
    searchBasePatentsHelper : function(component, txtSearchBasePatents, arrSelectedBasePatentIdsValue){
        
         var action = component.get('c.searchPatents');
        action.setParams({ searchWord : txtSearchBasePatents, PatentIds :arrSelectedBasePatentIdsValue});
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
                            component.set('v.isShowSearchBaseResult',true);
                            component.find("lstAvailableBasePatents").set("v.options", result);
                        }
                        else
                        {
                        	component.set('v.isShowSearchBaseResult',false);
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
        );
        $A.enqueueAction(action);
    },
    getSelectedBasePatentsHelper : function(component, arrSelectedBasePatentIds) 
    { 
        //alert('Enter Helper');
        var action = component.get('c.getSelectedPatents');
        action.setParams({ PatentIds : arrSelectedBasePatentIds });
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
                        component.set("v.lstSelectedBasePatents", result);
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
	},
    // For Single Family Sync
    syncfamilydata : function(component, event) {
        var action = component.get('c.familysync');
        action.setParams({ 'patentId' : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var objData = response.getReturnValue();
            alert('Family Sync initiated successfully. It will take few minutes to complete.');    
        });        
        $A.enqueueAction(action);
	},
})