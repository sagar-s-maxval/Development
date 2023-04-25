({
    doInit: function (component, event, helper) {
        helper.getInventors(component, event, helper);
    },

    handleUploadFinished: function (component, event, helper) {
        let uploadedFiles = event.getParam("files");
        let documentId = uploadedFiles[0].documentId;  
        let fileName = uploadedFiles[0].name;

        helper.getInventors(component, event, helper);
    },

    openFile : function(component,event,helper){
         let rec_id = event.currentTarget.id;
         $A.get('e.lightning:openFiles').fire({
           recordIds: [rec_id]
         });
    },

    deleteFile : function(component, event, helper) {
        let rec_id = event.currentTarget.id;
        helper.deleteFile(component, helper, rec_id);
    }
});