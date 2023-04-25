import {LightningElement, api, wire} from 'lwc';
import {refreshApex} from "@salesforce/apex";
import {NavigationMixin} from "lightning/navigation";
import {subscribe, unsubscribe, onError} from 'lightning/empApi';
import getReviewers from '@salesforce/apex/DocuSignSendEnvelopeController.getReviewers'
import deleteReviewer from '@salesforce/apex/DocuSignSendEnvelopeController.deleteReviewer'
import { updateRecord } from 'lightning/uiRecordApi';
import TYPE_FIELD from '@salesforce/schema/DocuSignReviewer__c.Recipient_Type__c';
import ID_FIELD from '@salesforce/schema/DocuSignReviewer__c.Id';

const ACTIONS = [
    {
        label: 'Delete',
        name: 'delete',
        iconName: 'utility:delete'
    },
    {
        label: 'Change Type',
        name: 'change',
        iconName: 'utility:change_record_type'
    }
];

const CHANNEL_DOCU_SIGN_REVIEWER = "/data/DocuSignReviewer__ChangeEvent";

const COLUMNS = [
    {
        type: "url",
        label: "Name",
        fieldName: "Person",
        hideDefaultActions: true,
        typeAttributes: {
            label: {fieldName: 'linkLabel'},
            target: "_blank"
        }
    },
    {
        type: "text",
        label: "Email",
        fieldName: "EmailId",
        hideDefaultActions: true
    },
    {
        type: "text",
        label: "Type",
        fieldName: "Recipient_Type__c",
        hideDefaultActions: true
    },
    {
        type: "action",
        typeAttributes: {rowActions: ACTIONS, menuAlignment: 'right'}
    }
];

export default class ThReviewerList extends NavigationMixin(LightningElement) {

    columns = COLUMNS;

    selectedReviewersIds = [];
    selectedSignersIds = [];
    selectedCCsIds = [];

    channel = CHANNEL_DOCU_SIGN_REVIEWER;

    @api recordId;

    @wire(getReviewers, {patentOrInvDiscId: '$recordId'})
    reviewers;

    get data() {
        return this.reviewers.data
            .filter(e => e.Person__c) // skip deleted persons
            .map(item => {

                let res = {...item};

                res.Person = '/' + res.Person__c;
                res.linkLabel = res.Person__r.Name;
                res.EmailId = res.Person__r.SymphonyIPM__Email__c;
                res.EmploymentStatus = res.Person__r.SymphonyIPM__Employment_status__c;

                return res;
            })
    }

    handleRowAction(event) {
        let actionName = event.detail.action.name;

        switch (actionName) {
            case 'delete':
                this.dispatchEvent(new CustomEvent('preloader', { detail: { isPreloader: true}}));
                deleteReviewer({reviewerId: event.detail.row.Id})
                    .then(() => {
                        this.dispatchEvent(new CustomEvent('preloader', { detail: { isPreloader: false}}));
                        refreshApex(this.reviewers);
                    })
                break;
            case 'change':

                // Create the recordInput object
                const fields = {};
                fields[ID_FIELD.fieldApiName] =  event.detail.row.Id;
                fields[TYPE_FIELD.fieldApiName] = event.detail.row.Recipient_Type__c === 'Signer' ? 'Carbon Copy' : 'Signer';

                const recordInput = { fields };

                this.dispatchEvent(new CustomEvent('preloader', { detail: { isPreloader: true}}));
                updateRecord(recordInput)
                    .then(() => {
                        this.dispatchEvent(new CustomEvent('preloader', { detail: { isPreloader: false}}));
                        refreshApex(this.reviewers);
                    });

                break;
        }
    }

    rowSelected(event) {
        let rows = event.detail.selectedRows;

        this.selectedReviewersIds = rows.map(item => item.Person__c);
        this.selectedSignersIds = rows.filter(e => e.Recipient_Type__c === 'Signer').map(e => e.Person__c);
        this.selectedCCsIds = rows.filter(e => e.Recipient_Type__c === 'Carbon Copy').map(e => e.Person__c);

        this.dispatchEvent(new CustomEvent('rowselect',
            {
                detail: {
                    eventSource: "thReviewerList",
                    amountOfSelected: this.selectedReviewersIds.length
                }
            }));
    }

    @api getSelectedReviewersIds() {
        return this.selectedSignersIds;
    }

    @api getCCsPersonsSrt() {
        return this.selectedCCsIds;
    }

    connectedCallback() {
        this.registerErrorListener();
        this.subscribe(this.channel);
    }

    messageCallback(event) {
        console.log(JSON.parse(JSON.stringify(event)));

        let payload = event.data.payload;

        let records = payload.ChangeEventHeader.recordIds;
        let allIds = this.getAllIds();

        if (payload.Patent__c === this.recordId || //1 if insert
            payload.Invention_Disclosure__c === this.recordId ||
            records.some(el => allIds.includes(el))) {   //2 if update/delete
            refreshApex(this.reviewers);
        }
    }

    getAllIds() {
        return this.reviewers.data.map(item => item.Id);
    }

    subscribe(channel) {
        subscribe(channel, -1, (re) => {
            this.messageCallback(re);
        });
        console.log('Subscription to ' + channel);
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }
}