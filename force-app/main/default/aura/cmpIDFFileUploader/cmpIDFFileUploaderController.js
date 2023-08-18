({
    getAttachedDocumentsController : function(component, event, helper)
    {
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
    handleUploadFinished: function (component, event, helper)
    {
        // var a=true;
        
        
        //  alert('Upload Finished.');
        
        // This will contain the List of File uploaded data and status
        var lstDocumentId = component.get("v.lstDocumentId");
        var uploadedFiles = event.getParam("files");
        var fcount=component.get('v.filescount');
        fcount=fcount+1;
        component.set('v.filescount',fcount);
        // alert(component.get('v.filescount'));
        // alert(a);
        /* var cmpEvent = $A.get("e.c:isUploadEvent");
               Get the value from Component and set in Event
              cmpEvent.setParams( { "isUploadTrue" : a } );
              cmpEvent.fire(); */
        if (uploadedFiles!=undefined)
        {
            for(var i=0;i<uploadedFiles.length;i++)            
            {
                lstDocumentId.push(uploadedFiles[i].documentId);
            }
        }
        
        component.set("v.lstDocumentId", lstDocumentId);
        
        lstDocumentId = component.get("v.lstDocumentId");
        component.set("v.contentDocumentIds", lstDocumentId.join(","));
        //alert('Ids:' + component.get("v.contentDocumentIds"));
        
        if(component.get('v.contentDocumentIds').length != 0){
            component.set("v.idAvailable","true");
        }
        
        var linkedEntityId  = component.get('v.linkedEntityId');
        //helper.getCurrentAttachedDocumentsHelper(component, linkedEntityId, lstDocumentId);
        
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
        var cmpEvent = component.getEvent("cmpEvent");
        
        cmpEvent.setParams( { "isUploadTrue" : true } );
        cmpEvent.fire();
    },
    deleteAttachmentsController : function(component,event, helper)
    {
        var contentVersionId = event.getSource().get("v.value");
        helper.deleteDocumentAttachmentsHelper(component, contentVersionId);
        var fcount=component.get('v.filescount');
        fcount=fcount-1;
        component.set('v.filescount',fcount);
        //  alert(component.get('v.filescount'));
        if(fcount<=0){
            var cmpEvent = component.getEvent("cmpEvent");      
            cmpEvent.setParams( { "isUploadTrue" : false } );
            cmpEvent.fire();
        }
        
        
    }
})