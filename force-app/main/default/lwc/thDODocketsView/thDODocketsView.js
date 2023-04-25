import {LightningElement, wire, api} from 'lwc';
import getDODocketingActivities from '@salesforce/apex/TrademarkDocketingActivityController.getDODocketingActivities';
import {refreshApex} from '@salesforce/apex';
import {updateRecord} from 'lightning/uiRecordApi';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import NAME from '@salesforce/schema/SymphonyIPMExt__D_O_Docketing_Activity__c.Name';
import ACTIONS from '@salesforce/schema/SymphonyIPMExt__D_O_Docketing_Activity__c.SymphonyIPMExt__Actions__c';
import DUE_DATE from '@salesforce/schema/SymphonyIPMExt__D_O_Docketing_Activity__c.SymphonyIPMExt__Due_Date__c';
import CLOSED_DATE from '@salesforce/schema/SymphonyIPMExt__D_O_Docketing_Activity__c.SymphonyIPMExt__Closed_Date__c';
import COMPLETED_DATE from '@salesforce/schema/SymphonyIPMExt__D_O_Docketing_Activity__c.SymphonyIPMExt__Completion_Date__c';
import COMMENTS from '@salesforce/schema/SymphonyIPMExt__D_O_Docketing_Activity__c.SymphonyIPMExt__Comments__c';
import TRIGGER from '@salesforce/schema/SymphonyIPMExt__D_O_Docketing_Activity__c.SymphonyIPMExt__Trigger__c';
import CLOSED from '@salesforce/schema/SymphonyIPMExt__D_O_Docketing_Activity__c.SymphonyIPMExt__Is_Closed__c';
import COMPLETED from '@salesforce/schema/SymphonyIPMExt__D_O_Docketing_Activity__c.SymphonyIPMExt__Is_Completed__c';

const COLS = [
    {
        label: 'Name',
        fieldName: NAME.fieldApiName,
        initialWidth: 122
    },
    {
        label: 'Trigger',
        fieldName: TRIGGER.fieldApiName,
        initialWidth: 115
    },
    {
        label: 'Actions',
        fieldName: ACTIONS.fieldApiName,
        initialWidth: 310
    },
    {
        label: 'Due Date',
        fieldName: DUE_DATE.fieldApiName,
        type: 'date-local',
        editable: true,
        initialWidth: 125
    },
    {
        label: 'Closed?',
        fieldName: CLOSED.fieldApiName,
        type: 'boolean',
        editable: true,
        initialWidth: 100
    },
    {
        label: 'Closed Date',
        fieldName: CLOSED_DATE.fieldApiName,
        type: 'date-local',
        editable: true,
        initialWidth: 120
    },
    {
        label: 'Completed?',
        fieldName: COMPLETED.fieldApiName,
        type: 'boolean',
        editable: true,
        initialWidth: 125
    },
    {
        label: 'Completed Date',
        fieldName: COMPLETED_DATE.fieldApiName,
        type: 'date-local',
        editable: true,
        initialWidth: 135
    },
    {
        label: 'Comments',
        fieldName: COMMENTS.fieldApiName,
        type: 'text',
        editable: true,
        initialWidth: 185
    },
];

export default class ThTrademarkDocketsView extends LightningElement {

    @api recordId;
    columns = COLS;
    draftValues = [];

    @wire(getDODocketingActivities, {recordId: '$recordId'})
    docketActivities;

    async handleSave(event) {
        // Convert datatable draft values into record objects
        let draftValues = this.template.querySelector('lightning-datatable').draftValues;
        const records = draftValues.slice().map((draftValue) => {
            const fields = Object.assign({}, draftValue);
            return {fields};
        });

        // Clear all datatable draft values
        this.draftValues = [];

        try {
            // Update all records in parallel thanks to the UI API
            const recordUpdatePromises = records.map((record) =>
                updateRecord(record)
            );
            await Promise.all(recordUpdatePromises);

            // Report success with a toast
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records was updated',
                    variant: 'success'
                })
            );

            // Display fresh data in the datatable
            await refreshApex(this.docketActivities);
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating or reloading Records',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }

    handleCancel() {
        this.draftValues = [];
    }
}