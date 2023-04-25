import {api, LightningElement, wire} from 'lwc';
import {refreshApex} from "@salesforce/apex";
import {onError, subscribe} from 'lightning/empApi';
import getDocumentLinks from '@salesforce/apex/DocuSignSendEnvelopeController.getDocumentLinks'

const COLUMNS = [
    {
        type: "text",
        label: "File Name",
        fieldName: "DocTitle",
        hideDefaultActions: true,
        initialWidth: 300
    },
    {
        type: "date",
        label: "Created Date",
        fieldName: "CreatedDate",
        hideDefaultActions: true
    }
];

const CHANNEL_CONTENT_DOCUMENT_LINK = "/data/ContentDocumentLinkChangeEvent";

export default class ThFileListPatent extends LightningElement {

    channel = CHANNEL_CONTENT_DOCUMENT_LINK;

    columns = COLUMNS;

    @api recordId;

    selectedDocumentsIds = [];

    @wire(getDocumentLinks, {entityId: '$recordId'})
    response;

    get data() {
        return this.response.data.map(item => {
            let res = {...item};
            res.DocTitle = item.ContentDocument.Title;
            res.CreatedDate = item.ContentDocument.CreatedDate;
            return res;
        });
    }

    rowSelected(event) {
        let rows = event.detail.selectedRows;

        this.selectedDocumentsIds = rows.map(item => item.ContentDocumentId);

        this.dispatchEvent(new CustomEvent('rowselect',
            {
                detail: {
                    eventSource: "thFileListPatent",
                    amountOfFilesSelected: this.selectedDocumentsIds.length,
                }
            }));
    }

    @api getSelectedDocumentsIds() {
        return this.selectedDocumentsIds;
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

        if( payload.LinkedEntityId === this.recordId || //1 if insert
            records.some(el => allIds.includes(el))){   //2 if update/delete
            refreshApex(this.response);
        }
    }

    getAllIds() {
        return this.response.data.map(item => item.ContentDocumentId);
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