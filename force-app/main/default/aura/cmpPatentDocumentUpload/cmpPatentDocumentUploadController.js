({
    doInit : function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        helper.getPatentDocumentRecord(component);
        helper.checkAccess(component);
        helper.getDocTypeOptions(component);
        helper.getRevByOptions(component);
    },

    handleDocTypeChange : function(component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        component.set("v.newDocument.SymphonyIPM__Document_Type__c", selectedOptionValue);
    },

    handleReviewByChange : function(component, event, helper) {
        console.log('---review by--- ');
        component.set("v.hasError", false);
        component.set("v.errorMessage", '');
        var reviewbyValues = component.get("v.selectedReviewBy");
        var reviewByNames = [];
        reviewbyValues.forEach(ele => {
            reviewByNames.push(ele.name);
        });
        component.set("v.newDocument.Review_By__c", reviewByNames);
    },
    
    handleUploadFinished : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        component.set("v.fileUploaded", uploadedFiles[0].name);
        component.set("v.newDocument.SymphonyIPM__Content_Version_Id__c", uploadedFiles[0].contentVersionId);
    },

    handleSaveRecord : function(component, event, helper) {
        var isFinalVersion = component.get("v.finalVersion");
        var newDocument = component.get('v.newDocument');
        console.log('--handleSaveRecord-- ', newDocument);
        component.set("v.hasError", false);
        if(isFinalVersion){
            component.set("v.newDocument.SymphonyIPM__Version__c", "Final");
        }
        var reviewbyValues = component.get("v.selectedReviewBy");
        if(newDocument.Review_By__c != '' || (reviewbyValues != null && reviewbyValues.length > 0)){
            helper.saveDocumentRecord(component);
        }else{
            component.set("v.errorMessage", 'Select atleast one review by');
            component.set("v.hasError", true);
        }
    },

    handleSaveFinalVersion: function(component, event, helper) {
        helper.saveFinalVersion(component);
    },
    
    handleSaveDraft : function(component, event, helper) {
        helper.saveDocumentDraft(component);
    },
    
    handleDelete : function(component, event, helper) {
        helper.handleDeleteDocument(component);
    }
})