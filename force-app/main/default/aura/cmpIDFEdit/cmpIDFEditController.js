({
    init: function (component) {
        let recId = component.get("v.recordId");
        if (!recId) {
            var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
            var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
            var sParameterName;
            var i;

            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('='); //to split the key from the value.

                if (sParameterName[0] === 'c__recordId') { //lets say you are looking for param name - firstName
                    sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
                    break;
                }
            }
            recId = sParameterName[1];
            console.log(recId);
        }
        
        var checkAccess = component.get('c.checkIfUserHasEditAccess');
        checkAccess.setParams({
            'recordId': recId
        });
        
        checkAccess.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var result = response.getReturnValue();
                if(result === true){
                    let checkIfBeingEdited = component.get("c.getFormEditTimeWithinDiffUser");
                    checkIfBeingEdited.setParams({
                        'recordId': recId
                    });
            
                    checkIfBeingEdited.setCallback(this, function (response) {
                        let state = response.getState();
                        if (state === "SUCCESS") {
                            let storeResponse = response.getReturnValue();
                            // Find the component whose aura:id is "flowData"
                            if(storeResponse.flag ===true){
                                //Commented on April 11th, 2022 by Andrii Romash - not working as expected
//                                $A.get("e.force:closeQuickAction").fire();
//                                var toastEvent = $A.get("e.force:showToast");
//                                toastEvent.setParams({
//                                    title : 'Warning',
//                                    mode: 'pester',
//                                    type: 'warning',
//                                    duration: '8000',
//                                    message: 'This is a required message',
//                                    messageTemplate: '{1} is modifying the IDF. Please try again after some time or ask {1} to save and exit the IDF.',
//                                    messageTemplateData: [storeResponse.userName, {
//                                        url: storeResponse.url ,
//                                        label: storeResponse.userName,
//                                    }]
//                                });
//
//                                toastEvent.fire();
//
//                                var urlEvent = $A.get("e.force:navigateToURL");
//                                urlEvent.setParams({
//                                    "url": "/lightning/o/SymphonyIPM__Invention_Disclosure_New__c/list"
//                                });
//                                urlEvent.fire();
                                //next code to be deleted once commented fixed.
                                let action = component.get("c.fetchRecord");
                                action.setParams({
                                    'recId': recId
                                });
                                action.setCallback(this, function (response) {
                                    let state = response.getState();
                                    if (state === "SUCCESS") {
                                        let storeResponse = response.getReturnValue();
                                        // Find the component whose aura:id is "flowData"
                                        let flow = component.find("flowData");
                                        let inputletiables = [{
                                            name: "recordId",
                                            type: "String",
                                            value: recId
                                        }];
                                        // In that component, start your flow. Reference the flow's Unique Name.
                                        flow.startFlow("IDF_Submission", inputletiables);

                                    }
                                });

                                $A.enqueueAction(action);
                            }else{
                                let action = component.get("c.fetchRecord");
                                action.setParams({
                                    'recId': recId
                                });
                                action.setCallback(this, function (response) {
                                    let state = response.getState();
                                    if (state === "SUCCESS") {
                                        let storeResponse = response.getReturnValue();
                                        // Find the component whose aura:id is "flowData"
                                        let flow = component.find("flowData");
                                        let inputletiables = [{
                                            name: "recordId",
                                            type: "String",
                                            value: recId
                                        }];
                                        // In that component, start your flow. Reference the flow's Unique Name.
                                        flow.startFlow("IDF_Submission", inputletiables);
            
                                    }
                                });
            
                                $A.enqueueAction(action);
                            }
                        }
                    });
            
                    $A.enqueueAction(checkIfBeingEdited);
                }else{
                    $A.get("e.force:closeQuickAction").fire();
	                var toastEvent = $A.get("e.force:showToast");
	                toastEvent.setParams({
	                    title : 'Warning',
	                    mode: 'pester',
	                    type: 'warning',
	                    duration: '8000',
	                    message: 'You are not allowed to edit the record!',
	                });
	                toastEvent.fire();
                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/lightning/r/SymphonyIPM__Invention_Disclosure_New__c/" + recId +"/view"
                    });
                    urlEvent.fire();
                }
            }
        });
        
        $A.enqueueAction(checkAccess);
    },
});