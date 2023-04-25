import {api, LightningElement, wire} from 'lwc';
import {getFieldValue, getRecord, updateRecord} from "lightning/uiRecordApi";
import {refreshApex} from "@salesforce/apex";
import createPlatformEvent from '@salesforce/apex/EmailPopupController.createPlatformEvent'
import {ShowToastEvent} from "lightning/platformShowToastEvent";

let FIELDS = [];

export default class ThEmailPopupAfterRecordCreated extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api fieldApiName;
    @api actionDeveloperName;
    record;


    connectedCallback() {
        let fields1 = [this.objectApiName + '.' + this.fieldApiName, this.objectApiName + '.Trademark__c']
        FIELDS = [...fields1];
    }

    @wire(getRecord, {recordId: '$recordId', fields: FIELDS})
    wiredRecord({ error, data }) {
        if (error) {
            console.log(error)
        } else if (data) {
            this.record = data;
            if (getFieldValue(this.record, this.objectApiName + '.' + this.fieldApiName)) {
                createPlatformEvent({
                    actionDeveloperName: this.actionDeveloperName,
                    objectApiName: this.objectApiName,
                    recordId: this.recordId,
                    trademarkId: getFieldValue(this.record, this.objectApiName + '.Trademark__c')
                })
                    .then(() => {
                        console.log('create event')
                    }).finally(() =>{
                        this.updateRecordField();
                })
            }
        }
    }

    updateRecordField() {
        const fields = {};
        fields['Id'] = this.recordId;
        fields[this.fieldApiName] = false;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                return refreshApex(this.record);
            })
            .catch(error => {
                console.log(error);
            });
    }
}