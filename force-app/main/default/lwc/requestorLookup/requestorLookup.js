import { LightningElement, track, wire, api } from 'lwc';

import getRequestorPerson from '@salesforce/apex/RequestorLookupController.findRequestorPerson';
import {FlowAttributeChangeEvent} from "lightning/flowSupport";
import NAME_FIELD from '@salesforce/schema/SymphonyIPM__Inventor__c.Name';
import EMAIL_FIELD from '@salesforce/schema/SymphonyIPM__Inventor__c.SymphonyIPM__Email__c';
import {getFieldValue, getRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

const DELAY = 300;

export default class RequestorLookup extends LightningElement {

    @track desireOtherRequester = false;
    @track search = '';
    @track error;
    @track selectedPerson;
    @track showUsersListFlag = false;

    @api personId
    @api currentPersonId
    @api label
    @api Required
    @api placeholder


    @wire(getRequestorPerson, { searchText: '$search' })
    searchResult;

    @wire(getRecord, { recordId: '$currentPersonId', fields: [NAME_FIELD,EMAIL_FIELD]})
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading contact',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data && !this.desireOtherRequester) {
            this.selectedPerson = getFieldValue(data,NAME_FIELD) + ' (' + getFieldValue(data,EMAIL_FIELD) + ')'
            this.personId = this.currentPersonId;

            this.template
                .querySelector('.selectedOption')
                .classList.remove('slds-hide');
            this.template
                .querySelector('.accounts_list')
                .classList.add('slds-hide');
            this.template
                .querySelector('.slds-combobox__form-element')
                .classList.add('slds-input-has-border_padding');

            this.dispatchEvent(new FlowAttributeChangeEvent('personId',this.personId))
        }
    };

    handleKeyUp(event) {
        if (!this.showUsersListFlag) {

            this.showUsersListFlag = true;
            this.template
                .querySelector('.accounts_list')
                .classList.remove('slds-hide');
        }
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.search = searchKey;
        }, DELAY);
    };

    handleOptionSelect(event) {

        this.desireOtherRequester = true;
        this.selectedPerson = event.currentTarget.dataset.name + ' (' + event.currentTarget.dataset.email+')';
        this.personId = event.currentTarget.dataset.id;

        this.dispatchEvent(new FlowAttributeChangeEvent('personId',this.personId))

        this.template
            .querySelector('.selectedOption')
            .classList.remove('slds-hide');
        this.template
            .querySelector('.accounts_list')
            .classList.add('slds-hide');
        this.template
            .querySelector('.slds-combobox__form-element')
            .classList.add('slds-input-has-border_padding');
    };

    handleRemoveSelectedOption() {
        this.template
            .querySelector('.selectedOption')
            .classList.add('slds-hide');
        this.template
            .querySelector('.slds-combobox__form-element')
            .classList.remove('slds-input-has-border_padding');

        this.showUsersListFlag = false;
    }

}