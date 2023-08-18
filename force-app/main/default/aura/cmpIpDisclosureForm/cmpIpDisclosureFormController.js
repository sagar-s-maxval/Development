({
    init : function(component, event, helper) {
       /* alert(component.get("v.pageReference"));
        alert(component.get("v.pageReference").state.id);
        var a=JSON.stringify(component.get("v.pageReference"));
        alert(a);
        component.set('v.recordId', component.get("v.pageReference").state.id);
		console.log(component.get('v.recordId'));
          alert(component.get('v.recordId'));*/
        
        //alert('comp2'+component.get("v.HomePage"));
        var idfid=component.get("v.recordId");
        //alert(component.get("v.recordId"));
        if(idfid===undefined){
            
            var flow = component.find("flowData");
            var inputVariables = [{
                name : "HomePage",
                type : "Boolean",
                value : component.get("v.HomePage")
            }];
            
            flow.startFlow("Invention_Disclosure_Submission_New_2020",inputVariables);  
        }
        else if(idfid.length===18 || idfid.length===15)
        {
            
            var flow = component.find("flowData");
            var inputVariables = [
                {
                    name : "IDF",
                    type : "String",
                    value : component.get("v.recordId")
                    
                } 
            ];
            //alert(component.get("v.recordId") +"wdasfd");
            flow.startFlow("Invention_Disclosure_Editable_Form",inputVariables);   
        } 
        
    },
    
    handleStatusChange : function (component, event) {
        if(event.getParam("status") === "FINISHED") {
            $A.get("e.force:closeQuickAction").fire();  
            var outputVariables = event.getParam("outputVariables");
            var outputVar;
            for(var i = 0; i < outputVariables.length; i++) {
                
                outputVar = outputVariables[i];
                if(outputVar.name === "IDF") {
                    var urlEvent = $A.get("e.force:navigateToSObject");
                    urlEvent.setParams({
                        "recordId": outputVar.value,
                        "isredirect": "true"
                    });
                    urlEvent.fire();
                   /* window.open('https://orgurl/one/one.app?#/sObject/'+outputVar.value+'/view')*/
                }
            }
            
        }/*else if (event.getParam('status') === "ERROR") {
            //alert('Event');
            component.set("v.hasError", true);
        }*/
        
        
    }
})