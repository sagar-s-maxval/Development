({
	getAttachedDocumentsHelper : function(component, linkedEntityId) {
		var action = component.get('c.getAttachedDocuments');
        action.setParams({ 'LinkedEntityId' : linkedEntityId });
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    if (state === "SUCCESS") 
                    {
                        var result = response.getReturnValue();
                        component.set('v.objAttachments', result);
                        var lstAttachments = component.get('v.objAttachments');
                        
                        component.set("v.isFileUploaded",false);
                        if (result !=null){
                          for (var i = 0; i < result.length; i++) {
                            	component.set("v.isFileUploaded",true);
                        	}  
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
    
    getCurrentAttachedDocumentsHelper : function(component, linkedEntityId, lstDocumentId)  {
		var action = component.get('c.getCurrentAttachedDocuments');
        action.setParams({ 'LinkedEntityId' : linkedEntityId , 'lstDocumentId' : lstDocumentId });
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    if (state === "SUCCESS") 
                    {
                        var result = response.getReturnValue();
                        component.set('v.objAttachments', result);
                       
                        component.set("v.isFileUploaded",false);
                        if (result !=null){
                          for (var i = 0; i < result.length; i++) {
                            	component.set("v.isFileUploaded",true);
                        	}  
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
    
    deleteDocumentAttachmentsHelper : function(component, contentVersionId) {
		var action = component.get('c.deleteAttachment');
        action.setParams({'contentVersionId' : contentVersionId});
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        
                        var linkedEntityId  = component.get('v.linkedEntityId');
                        var canViewAllFiles = component.get('v.canViewAllFiles');
                        var canViewCurrentAttachedFiles = component.get('v.canViewCurrentAttachedFiles');
                        
                        if (canViewAllFiles==true && canViewCurrentAttachedFiles==false) {
                            var linkedEntityId  = component.get('v.linkedEntityId');
                            this.getAttachedDocumentsHelper(component, linkedEntityId);
                            
                        } else if (canViewAllFiles==false && canViewCurrentAttachedFiles==true) {
                            var linkedEntityId  = component.get('v.linkedEntityId');
                            this.getCurrentAttachedDocumentsHelper(component, linkedEntityId, component.get("v.lstDocumentId"));
                        }
                        
                        var documentId = response.getReturnValue();
                        var lstDocumentId = component.get("v.lstDocumentId");
                        var index = lstDocumentId.indexOf(documentId);
                        if (index > -1) {
                            lstDocumentId.splice(index, 1);
                        }
                        component.set("v.lstDocumentId",lstDocumentId);
                        var count = component.get("v.count");
                        var searchCompleteEvent1 = component.getEvent("uploadedfiles");
                        searchCompleteEvent1.setParams({
                        ListOfUploadedFiles: lstDocumentId,
                        count: count
                        }).fire();
                        
        				component.set("v.contentDocumentIds", lstDocumentId.join(","));
        				//alert('Ids:' + component.get("v.contentDocumentIds"));
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        //alert(JSON.stringify(response.getError()));
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
	}
})