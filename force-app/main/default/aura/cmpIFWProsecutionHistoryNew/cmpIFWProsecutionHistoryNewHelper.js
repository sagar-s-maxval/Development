({
    onLoad: function(component, event)
    {
        console.log('onLoad call');
        //call apex class method
        var action = component.get('c.fetchIFWProsecutionHistory1');
        action.setParams({
            "AssetId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListofIFW attribute on component.
                //
                var objData = response.getReturnValue();
                
                for(var i=0; i<objData.length; i++)
                {
                    
                    if(objData[i].hasOwnProperty('SymphonyIPM__OCR_File_Name__c'))
                    {
                        objData[i].SymphonyIPM__OCR_File_Name__c = 'https://symphonyipm-dev-ed.lightning.force.com/lightning/r/ContentDocument/' + objData[i].SymphonyIPM__OCR_File_Name__c + ''+'/view';
                        component.set("v.showOCR",true);
                        //component.set("v.showPDF",false);
                    }
                    else
                    {
                        objData[i].SymphonyIPM__OCR_File_Name__c ='-';
                        component.set("v.showOCR",false);
                        component.set("v.showPDF",true);
                        
                    }
                    if(objData[i].hasOwnProperty('SymphonyIPM__PDFFileName__c'))
                    {                   
                        objData[i].SymphonyIPM__PDFFileName__c = '/apex/SymphonyIPM__ifwpdf?PDFFileName=' + objData[i].SymphonyIPM__PDFFileName__c + '&'+objData[i].sId+'';
                        component.set("v.showPDF",true);
                        //component.set("v.showOCR",false);
                    }
                    else
                    {
                        objData[i].SymphonyIPM__PDFFileName__c='-';
                        component.set("v.showPDF",false);
                        component.set("v.showOCR",true);
                    }              
                }
                component.set('v.ListofIFW', objData);
                //alert(JSON.stringify(objData));
            }
        });
        $A.enqueueAction(action);
    },
    syncifwdata : function(component, event) {
        var action = component.get('c.IFWsync');
        action.setParams({ 'patentId' : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var objData = response.getReturnValue();
            alert('IFW Sync initiated successfully. It will take few minutes to complete.');    
        });
        
        $A.enqueueAction(action);
    },
    lastSyncedDate : function(component, event) {
        var action = component.get('c.fetchIFWLastSyncedDate');
        action.setParams({
            "AssetId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert('State of call'+state);
            if (state === "SUCCESS") {
                var objData = response.getReturnValue();
                //alert('return response'+JSON.stringify(response.getReturnValue()));
                component.set('v.lastSyncedDate', objData);
            }
            
        });
        
        $A.enqueueAction(action);
    },
    // For PAIR Application Mapping
    syncPAIRapplication : function(component, event) {
        var action = component.get('c.PairApplicationsync');
        action.setParams({ 'patId' : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var objData = response.getReturnValue();
            alert('Application Mapping initiated successfully. It will take few minutes to complete.');    
        });
        
        $A.enqueueAction(action);
    },
    syncPAIRAnalyticData : function(component, event) {
        var action = component.get('c.PairAnalyticsync');
        action.setParams({ 'patentId' : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var objData = response.getReturnValue();
        });
        
        $A.enqueueAction(action);
    },
    syncBibiloPAIRapplication : function(component, event) {
        var action = component.get('c.PairApplicationBibilosync');
        action.setParams({ 'patId' : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var objData = response.getReturnValue();
            //alert('Application Mapping initiated successfully. It will take few minutes to complete2.');    
        });
        
        $A.enqueueAction(action);
    },
})