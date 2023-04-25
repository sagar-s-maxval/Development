import {LightningElement, api, wire} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {refreshApex} from '@salesforce/apex'
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getEnvelopes from '@salesforce/apex/DocuSignEnvelopeController.getEnvelopes'
import resendEnvelope from '@salesforce/apex/DocuSignEnvelopeController.resendEnvelope'
import {subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled} from 'lightning/empApi';
import LightningConfirm from 'lightning/confirm';

const COLUMNS = [
    {
        type: 'text',
        fieldName: 'Name',
        label: 'Name',
    },
    {
        type: 'text',
        fieldName: 'Status__c',
        label: 'Status'
    },
    {
        type: 'date',
        fieldName: 'SentDate__c',
        label: 'Sent Date'
    },
    {
        type: 'date',
        fieldName: 'CompletedDate__c',
        label: 'Completed Date'
    },
    {
        type: 'email',
        fieldName: 'Email__c',
        label: 'Email'
    }
];

const CHANNEL_DOCUSIGN_RECIPIENT = "/data/DocuSignRecipient__ChangeEvent";
const CHANNEL_DOCUSIGN_ENVELOPE = "/data/DocuSignEnvelope__ChangeEvent";

export default class tfEnvelopeList extends NavigationMixin(LightningElement) {

    columns;

    @api recordId;

    @wire(getEnvelopes, {parentId: '$recordId'})
    response;

    get getColumns() {
        if (!this.columns) {
            this.columns = [...COLUMNS];
            this.columns.push({name: 'action', type: 'action', typeAttributes: {rowActions: this.getRowActions}});
        }
        return this.columns;
    }

    get getTreeData() {
        return this.response.data.map((item) => {
            let newVar = {...item};
            newVar.isEnlevope = true;
            if (item.DocuSignRecipients__r)
                newVar._children = item.DocuSignRecipients__r;
            return newVar
        });
    }

    channelDocuSignRecipient = CHANNEL_DOCUSIGN_RECIPIENT;
    channelDocuSignEnvelope = CHANNEL_DOCUSIGN_ENVELOPE;

    connectedCallback() {
        this.registerErrorListener();
        this.subscribe(this.channelDocuSignRecipient);
        this.subscribe(this.channelDocuSignEnvelope);

    }

    messageCallback(event) {
        console.log(JSON.parse(JSON.stringify(event)));

        let allIds = this.getAllIds(this.response.data);

        let payload = event.data.payload;

        if (this.needRefresh(payload, allIds)) {
            this.showToast();
            refreshApex(this.response);
        }
    }

    needRefresh(payload, ids) {
        return payload.Patent__c === this.recordId  //1
            || payload.Invention_Disclosure__c === this.recordId    //2     1/2 if new DocuSignEnvelope__c inserted
            || ids.includes(payload.EnvelopeId__c)  //3     3 if new DocuSignRecipient__c inserted
            || payload.ChangeEventHeader.recordIds.some(el => ids.includes(el));  //4   if DocuSignEnvelope__c or DocuSignRecipient__c updated
    }

    // goes through each item
    // and return [[item.Id, item.DocuSignRecipients__r[0].Id, item.DocuSignRecipients__r[1].Id,...], [...]]
    // at end it have array of arrays and uses .flat(2) to turn them into single array
    getAllIds(items) {
        return (items.map(
            (item) => [item.Id].concat(
                (item.DocuSignRecipients__r) ? this.getAllIds(item.DocuSignRecipients__r) : []
            )
        )).flat(2)
    }

    showToast() {
        const event = new ShowToastEvent({
            title: 'Data updated',
            message: 'Envelops and recipients was updated',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
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

    async handleRowAction(event) {

        let action = event.detail.action;
        let row = event.detail.row;

        switch (action.name) {
            case 'resend':

                const result = await LightningConfirm.open({
                    message: 'Re-send the email notification to all pending recipients. ' +
                        'Are you sure you want to re-send the envelope?',
                    variant: 'info',
                    label: row.Name,
                });

                if (result) {
                    console.log(row.EnvelopeId__c)
                    resendEnvelope({envelopeId: row.EnvelopeId__c})
                        .then(response => {
                            let data = JSON.parse(response);

                            let title = data.errorCode ? 'Envelope not was successfully re-sent' : 'Envelope was successfully re-sent';
                            let message = data.errorCode ? data.message : null;
                            let variant  = data.errorCode ? 'error' : 'success';
                            const event = new ShowToastEvent({
                                title: title,
                                message: message,
                                variant: variant,
                                mode: 'dismissible'
                            });
                            this.dispatchEvent(event);
                        })
                }
                //Confirm has been closed
                //result is true if OK was clicked
                //and false if cancel was clicked
                break;
            case 'open':
                this[NavigationMixin.GenerateUrl]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        objectApiName: 'DocuSignEnvelope__c',
                        actionName: 'view',
                    },
                }).then(url => {
                    window.open(url, "_blank");
                });
                break;
        }
    }

    getRowActions(row, doneCallback) {
        const actions = [];
        console.log(row);

        if (row.isEnlevope) {
            if (row.Status__c === 'Completed') {
                actions.push({
                    'name': 'open',
                    'label': 'Open Envelope Files',
                    'iconName': 'utility:new_window',
                });
            } else {
                actions.push({
                    'name': 'resend',
                    'label': 'Resend Envelope',
                    'iconName': 'utility:refresh'
                })
            }
        } else {
            actions.push({
                'label': 'No actions available',
                'name': 'Empty',
                'disabled': 'true'
            });
        }
        doneCallback(actions);
    }
}