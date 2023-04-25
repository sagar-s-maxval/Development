({
	getPinnedDiaryNotesHelper : function(component) 
    {
        var action = component.get('c.getPinnedDiaryNotes');
        var SearchProjectId = component.get('v.recordId');
        var ObjectAPIName = component.get('v.ObjectAPIName');
        var FilterFieldAPIName = component.get('v.FilterFieldAPIName');
        var ShowPinned = component.get('v.ShowPinned');
        action.setParams({'ObjectAPIName': ObjectAPIName, 'FilterFieldAPIName' : FilterFieldAPIName,  'RecordId' : SearchProjectId, 'IsPinned': ShowPinned });
        action.setCallback
        (
            this, 
            function(response) 
            {
                var state = response.getState();
                if (state === "SUCCESS") 
                {
					var lstNotes = response.getReturnValue();
                    for ( var i = 0; i < lstNotes.length; i++ ) 
                    {
                        
                        if (lstNotes[i].SymphonyIPMExt__Type__c == "Note")  
                        {
                            lstNotes[i].displayIconName ='utility:note';
                            lstNotes[i].colortext='slds-text-color_black';
                        }
                        else
                        {
                            if (lstNotes[i].SymphonyIPMExt__Status__c == "Pending")  
                            {
                                lstNotes[i].displayIconName ='utility:info';
                                lstNotes[i].colortext='slds-text-color_black';
                                lstNotes[i].displayIconTitle = 'Pending';
                            }
                            else if (lstNotes[i].SymphonyIPMExt__Status__c == "Completed" )  
                            {
                                lstNotes[i].displayIconName ='utility:check';
                                lstNotes[i].displayIconTitle = 'Completed';
                            }
                        }
                    }
                    component.set('v.PinnedDiaryNotesList', lstNotes);
                }
                else if (state === "INCOMPLETE") 
                {
            	}
            	else if (state === "ERROR") 
                {
                    alert(JSON.stringify(response.getError()));
            	}
            }
        );
        $A.enqueueAction(action);
    },
    getRowActions: function (component, row, doneCallback) 
    {
        var actions = [];
        
        if (row['SymphonyIPMExt__Type__c'] == 'Action')
        {
            if (row['SymphonyIPMExt__Status__c'] == 'Pending') 
            {
                actions.push
                (
                    {
                        'label': 'Mark as Completed',
                        'iconName': 'utility:check',
                        'name': 'MarkAsCompleted'
                    }
                );
            } 
            else 
            {
                actions.push
                (
                    {
                        'label': 'Mark as Pending',
                        'iconName': 'utility:info',
                        'name': 'MarkAsPending'
                    }
                );
            }
        }
        actions.push
        (
            {
            	'label': 'Unpin this task',
            	'iconName': 'utility:pin',
            	'name': 'Unpin'
        	}
        );
        actions.push
        (
            {
            	'label': 'Edit',
            	'iconName': 'utility:edit_form',
            	'name': 'Edit'
        	}
        );
        // simulate a trip to the server
        setTimeout
        (
            $A.getCallback
            (
                function () 
                {
            		doneCallback(actions);
        		}
            )
            , 200
        );
    },
    ActionOnNoteHelper : function(component, DiaryNoteId, ActionText) 
    {
		var action = component.get('c.UpdateStatus');
        action.setParams({ 'DiaryNoteId' : DiaryNoteId, 'ActionText' : ActionText });
        action.setCallback
        (
            this, 
            function(response) 
            {
                var state = response.getState();
                if (state === "SUCCESS") 
                {
                    $A.get('e.force:refreshView').fire();
                    this.getPinnedDiaryNotesHelper(component);
                }
                else if (state === "INCOMPLETE") 
                {
            	}
            	else if (state === "ERROR") 
                {
            	}
            }
        );
        $A.enqueueAction(action);
    },
    PinUnpinHelper : function(component, DiaryNoteId, IsPinned) 
    {
		var action = component.get('c.PinUnPin');
        action.setParams({ 'DiaryNoteId' : DiaryNoteId, 'IsPinned': IsPinned});
        action.setCallback
        (
            this, 
            function(response) 
            {
                var state = response.getState();
                if (state === "SUCCESS") 
                {
                    $A.get('e.force:refreshView').fire();
                    this.getPinnedDiaryNotesHelper(component);
                }
                else if (state === "INCOMPLETE") 
                {
            	}
            	else if (state === "ERROR") 
                {
                    alert(JSON.stringify(response.getError()));
            	}
            }
        );
        $A.enqueueAction(action);
    },
    
    newDiaryNotes: function (component, event) 
    {
        var createRecordEvent = $A.get("e.force:createRecord");
        alert('Create Record');
    	createRecordEvent.setParams({
        	"entityApiName": "SymphonyIPMExt__Diary_Note__c"
    	});
    	createRecordEvent.fire();
    },
    editDiaryNotes : function(component, RecordId) 
    {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": RecordId
        });
        editRecordEvent.fire();
	},
    SaveRecordHelper : function(component,event,helper)
    { 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success",
            "message": "Record created successfully",
            "type" : "success"
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
        this.getPinnedDiaryNotesHelper(component);
        
    }
})