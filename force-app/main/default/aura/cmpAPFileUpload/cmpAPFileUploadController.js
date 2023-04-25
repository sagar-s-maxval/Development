({
    
    onSaveDraft: function(component, event, helper) {
        
        
        component.set("v.DisclosureStatus","Draft");
        var actionClicked = event.getSource().getLocalId();
        var navigate = component.get('v.navigateFlow');
        navigate(actionClicked);
        
     },
    
     onButtonPressed: function(component, event, helper) {
      
      //alert("Back");
      component.set("v.DisclosureStatus","Back");
      var actionClicked = event.getSource().getLocalId();
      var navigate = component.get('v.navigateFlow');
      navigate(actionClicked);
        
   },
    
    PreviewFile: function(cmp, event, helper) {
       var recid =  event.target.id;
		$A.get('e.lightning:openFiles').fire({
		    recordIds: [recid]
		});
    },
    
     OnSubmitted: function(component, event, helper) {
         
         if (component.get("v.isFileUploaded") !=true) {
             component.set("v.Error",true);
             return false;
         }
              component.set("v.DisclosureStatus","Submitted");
        var actionClicked = event.getSource().getLocalId();
        var navigate = component.get('v.navigateFlow');
        navigate(actionClicked);
        
     },
    
	getAttachedDocumentsController : function(component, event, helper) {
        var canViewAllFiles = component.get('v.canViewAllFiles');
        var canViewCurrentAttachedFiles = component.get('v.canViewCurrentAttachedFiles');
        if (canViewAllFiles==true && canViewCurrentAttachedFiles==false)
        {
        	var linkedEntityId  = component.get('v.linkedEntityId');
           
        	helper.getAttachedDocumentsHelper(component, linkedEntityId);
        }
        else if (canViewAllFiles==false && canViewCurrentAttachedFiles==true)
        {
            var linkedEntityId  = component.get('v.linkedEntityId');
           
        	helper.getCurrentAttachedDocumentsHelper(component, linkedEntityId, component.get("v.lstDocumentId"));
        }
	},
    
    handleUploadFinished: function (component, event, helper)  {
        // This will contain the List of File uploaded data and status
        
        var lstDocumentId = component.get("v.lstDocumentId");
        var uploadedFiles = event.getParam("files");
        if (uploadedFiles!=undefined)
        {
			for(var i=0;i<uploadedFiles.length;i++)            
            {
                lstDocumentId.push(uploadedFiles[i].documentId);
            }
        }
        
        var count = component.get("v.count");
        count = count + lstDocumentId.length;
        component.set("v.count",count);
          var searchCompleteEvent = component.getEvent("isUploadEvent");

            searchCompleteEvent.setParams({
            isUploadTrue: true
            }).fire();
            
            var searchCompleteEvent1 = component.getEvent("uploadedfiles");
            searchCompleteEvent1.setParams({
            ListOfUploadedFiles: lstDocumentId,
            count: count
            }).fire();
          //  alert('text');
        component.set("v.lstDocumentId", lstDocumentId);
        
        lstDocumentId = component.get("v.lstDocumentId");
        component.set("v.contentDocumentIds", lstDocumentId.join(","));
        //alert('Ids:' + component.get("v.contentDocumentIds"));
        
        if(component.get('v.contentDocumentIds').length != 0){
            component.set("v.idAvailable","true");
            component.set("v.isFileUploaded",true);
        }
        
        var linkedEntityId  = component.get('v.linkedEntityId');
        //helper.getCurrentAttachedDocumentsHelper(component, linkedEntityId, lstDocumentId);
        
        var canViewAllFiles = component.get('v.canViewAllFiles');
        var canViewCurrentAttachedFiles = component.get('v.canViewCurrentAttachedFiles');
        if (canViewAllFiles==true && canViewCurrentAttachedFiles==false) {
        	var linkedEntityId  = component.get('v.linkedEntityId');
        	helper.getAttachedDocumentsHelper(component, linkedEntityId);
        }
        else if (canViewAllFiles==false && canViewCurrentAttachedFiles==true) {
            var linkedEntityId  = component.get('v.linkedEntityId');
        	helper.getCurrentAttachedDocumentsHelper(component, linkedEntityId, component.get("v.lstDocumentId"));
        }
        
    },
    deleteAttachmentsController : function(component,event, helper) 
    {
        var contentVersionId = event.getSource().get("v.value");
        var count = component.get("v.count");
        count = count - 1;
        component.set("v.count",count);
        if(component.get("v.count")==0){
        var searchCompleteEvent = component.getEvent("isUploadEvent");

            searchCompleteEvent.setParams({
            isUploadTrue: false
            }).fire();
        }
        helper.deleteDocumentAttachmentsHelper(component, contentVersionId);
    },
    
    onSubmitButtonPressed: function(component, event, helper) {
       // alert('text-->'+cmp.get("v.comments"));
        var lstDocumentIds = component.get('v.lstDocumentId');
        
        console.log(lstDocumentIds.length);
       /* if(lstDocumentIds.length  === 0){
            component.set("v.ErrorMessage",'Please upload the signed agreement to complete.');
            component.set("v.Error",'true');
        }else*/
        {
            var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                    title: 'Success',
                    message: 'The record has been approved Successfully!',
                    duration: '5000',
                    type: 'success',
                    mode: 'pester'
                });
               toastEvent.fire();  
      // Figure out which action was called
        var actionClicked = event.getSource().getLocalId();
      // Fire that action
      component.set("v.Submit",true);
      var navigate = component.get('v.navigateFlow');
        navigate(actionClicked);
        } 
   }
    
    
})