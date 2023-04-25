({    
    getPinnedDiaryNotesController : function(component, event, helper) 
    {
        var actions = helper.getRowActions.bind(this, component);
        component.set('v.PinnedDiaryNotesColumn', [
            {label: '', fieldName: '', type: 'text', initialWidth: 20, cellAttributes:{ class: {fieldName:'SymphonyIPMExt__Status__c'}, iconName: {fieldName: 'displayIconName'}, iconAlternativeText: {fieldName : 'displayIconTitle'}}},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date', initialWidth: 120, cellAttributes:{class:{fieldName:'colortext'}}},
            {label: 'Due Date', fieldName: 'SymphonyIPMExt__Due_Date_if_any__c', type: "date-local",
                typeAttributes:{
                    weekday: "long",
                    year: "numeric",
                    month: "short",
                    day: "2-digit"
                } , initialWidth: 120, cellAttributes:{class:{fieldName:'colortext'}}},
            {label: 'Legacy Information', fieldName: 'Legacy_Information__c', type: 'text', initialWidth: 140, cellAttributes:{class:{fieldName:'colortext'}}},
            {label: 'Action', fieldName: 'SymphonyIPMExt__Action__c', type: 'text', initialWidth: 140, cellAttributes:{class:{fieldName:'colortext'}}},
            {label: 'Assigned to', fieldName: 'SymphonyIPMExt__Assigned_To_User_Text__c', type: 'text', initialWidth: 140, cellAttributes:{class:{fieldName:'colortext'}}},
            {label: 'Notes', fieldName: 'SymphonyIPMExt__Note__c', type: 'text', cellAttributes:{class:{fieldName:'colortext'}}},
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        var SearchProjectId = component.get('v.recordId');
        component.set('v.SearchProjectId', SearchProjectId);
        component.set('v.SelectedTypeisAction',false);       
        component.set('v.SelectedTypeisNote',true);  
        component.set('v.StripNoteHtmlValue','');  
        helper.getPinnedDiaryNotesHelper(component, SearchProjectId);
    },
    handleRowAction: function (component, event, helper) 
    {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var DiaryNoteId = row.Id;
        switch (action.name) 
        {
            case 'MarkAsCompleted':
                helper.ActionOnNoteHelper(component, DiaryNoteId, 'Completed');
                break;
            case 'MarkAsPending':
                helper.ActionOnNoteHelper(component, DiaryNoteId,'Pending');
                break;
            case 'Unpin':
                helper.PinUnpinHelper(component, DiaryNoteId, false);
                break;
            case 'Edit':
                helper.editDiaryNotes(component, DiaryNoteId);
                break;
        }
    },
    getSelectedRows: function (component, event) 
    {
        var SelectedDiaryIds = [];
        var selectedRows = event.getParam('selectedRows');
        for (var i = 0; i < selectedRows.length; i++)
        {
            SelectedDiaryIds.push(selectedRows[i].Id);
        }
        component.set('v.selectedRows',SelectedDiaryIds );
    },
    completeNoteController : function(component,event, helper) 
    {
        var DiaryNoteId = event.getSource().get("v.value");
        var DiaryNoteIds = [];
        DiaryNoteIds.push(DiaryNoteId);
        helper.ActionOnNoteHelper(component, DiaryNoteIds, 'Completed');
    },
    pendingNoteController : function(component,event, helper) 
    {
        var DiaryNoteId = event.getSource().get("v.value");
        var DiaryNoteIds = [];
        DiaryNoteIds.push(DiaryNoteId);
        helper.ActionOnNoteHelper(component, DiaryNoteIds,'Pending');
    },
    unpinController : function(component,event, helper) 
    {
        var DiaryNoteId = event.getSource().get("v.value");
        var DiaryNoteIds = [];
        DiaryNoteIds.push(DiaryNoteId);
        helper.UnpinHelper(component, DiaryNoteIds, false);
    },
    completeSelectedNoteController : function(component,event, helper) 
    {
        var DiaryNoteIds = component.get('v.selectedRows');
        if (DiaryNoteIds == '')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "No notes selected",
                "type" : "warning"
            });
            toastEvent.fire();
        }
        else
        {
            helper.ActionOnNoteHelper(component, DiaryNoteIds, 'Completed');
        }
    },
    pendingSelectedNoteController : function(component,event, helper) 
    {
        var DiaryNoteIds = component.get('v.selectedRows');
        if (DiaryNoteIds == '')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "No notes selected",
                "type" : "warning"
            });
            toastEvent.fire();
        }
        else
        {
            helper.ActionOnNoteHelper(component, DiaryNoteIds,'Pending');
        }
    },
    unpinSelectedController : function(component,event, helper) 
    {
        var DiaryNoteIds = component.get('v.selectedRows');
        if (DiaryNoteIds == '')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "No notes selected",
                "type" : "warning"
            });
            toastEvent.fire();
        }
        else
        {
            helper.PinUnpinHelper(component, DiaryNoteIds, false);
        }
    },
    pinSelectedController : function(component,event, helper) 
    {
        var DiaryNoteIds = component.get('v.selectedRows');
        if (DiaryNoteIds == '')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "No notes selected",
                "type" : "warning"
            });
            toastEvent.fire();
        }
        else
        {
            helper.PinUnpinHelper(component, DiaryNoteIds, true);
        }
    },
    newPinnedDiaryNotesController : function(component,event, helper) 
    {
        helper.newDiaryNotes(component, event);
    },
    newPinnedController : function(component,event, helper)
    {
        var recordId = component.get('v.recordId');
        component.set('v.ShowNewNote',true);               
    },
    closemodal : function(component,event, helper)
    {
        component.set('v.ShowNewNote',false);
    },
    SaveRecord : function(component,event,helper)
    {      
        var RecordId = component.get('v.recordId');
        //var content = component.find("Note").get("v.value");
        var content = component.get('v.StripNoteHtmlValue');
        var NoteContent = content.replace(/(<([^>]+)>)/ig, "");
        var filterFieldAPIName = component.get('v.FilterFieldAPIName');
        var selectedType = component.get('v.SelectedType');
        event.preventDefault();
        var fields = event.getParam("fields");
        if(filterFieldAPIName != '' || filterFieldAPIName != null)
        {
            fields[filterFieldAPIName] = RecordId;
        }
        if(selectedType == 'Action')
        {
        	fields["SymphonyIPMExt__Status__c"] = 'Pending'; 
        }
        else if(selectedType == 'Note')
        {
        	fields["SymphonyIPMExt__Status__c"] = '';   
        }
        fields["SymphonyIPMExt__Note__c"] = NoteContent;
        var duedate = component.get('v.DueDate');
        var currentDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        console.log('currentDate is '+currentDate);
        if(duedate!='' && duedate!=null)
        {
            if(duedate<=currentDate)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Due date cannot be a past/current date",
                    "type" : "error"
                });
                toastEvent.fire();
            }
            else
            {
                component.find("myRecordForm").submit(fields);
                component.set('v.ShowNewNote',false);
                helper.SaveRecordHelper(component,event,helper); 
            }
        }
        else
        {
            component.find("myRecordForm").submit(fields);
            component.set('v.ShowNewNote',false);
            helper.SaveRecordHelper(component,event,helper);
        }
    },
    handleSuccess : function(component, event, helper) 
    {
    	alert('Success');
    },
    handleload: function (component, event, helper) 
    {
        var valueSelected =  event.getParam("value");
        if(valueSelected === 'Action')
        {        
            component.set('v.SelectedTypeisAction',true);       
            component.set('v.SelectedTypeisNote',false);  
            component.set('v.SelectedType','Action');       
        }
        else
        {
            component.set('v.SelectedTypeisNote',true);   
            component.set('v.SelectedTypeisAction',false);       
            component.set('v.SelectedType','Note');       
        }
    }
})