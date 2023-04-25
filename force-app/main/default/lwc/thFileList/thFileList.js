import {api, LightningElement, wire} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {refreshApex} from "@salesforce/apex";
import {onError, subscribe} from 'lightning/empApi';
import getSDocs from '@salesforce/apex/DocuSignSendEnvelopeController.getSDocs'
import deleteDocument from '@salesforce/apex/DocuSignSendEnvelopeController.deleteDocument'
// import checkReviewers from '@salesforce/apex/DocuSignSendEnvelopeController.checkReviewers'
import getContentDocumentIdForFilePreview
    from '@salesforce/apex/DocuSignSendEnvelopeController.getContentDocumentIdForFilePreview'
// import getPersonsStr from '@salesforce/apex/DocuSignSendEnvelopeController.getPersonsStr'
// import {deleteRecord} from "lightning/uiRecordApi";

const COLUMNS = [
    {
        type: "text",
        label: "File Name",
        fieldName: "SDOC__Attachment_Name__c",
        initialWidth: 250
    },
    {
        type: "date",
        label: "Created Date",
        fieldName: "createdDate"
    }
];


const CHANNEL_S_DOC = "/data/SDOC__SDoc__ChangeEvent";

export default class ThFileList extends NavigationMixin(LightningElement) {

    channel = CHANNEL_S_DOC;

    columns = COLUMNS;

    @api recordId;

    selectedDocumentsIds = [];

    @wire(getSDocs, {recordId: '$recordId'})
    response;

    get data() {
        return this.response.data.map(item => {
            let res = {...item};
            res.fileName = item.Name;
            res.createdDate = item.CreatedDate;

            return res;
        });
    }

    async rowSelected(event) {
        let rows = event.detail.selectedRows;
        this.selectedDocumentsIds = rows.map(item => item.SDOC__File_ID__c);
        // let response = await checkReviewers({invDiscOrPatentId: this.recordId, idsStr: rows[0].RelatedIds__c});
        // let relatedPersonsIds = this.selectedDocumentsIds.length ? rows[0].RelatedIds__c : '';
        function onlyUnique(value, index, self) {
            return self.indexOf(value) === index;
        }

        const relatedPersonsIds = rows
            .filter(e => e.RelatedIds__c)
            .map(e => e.RelatedIds__c.split(','))
            .flat()
            .filter(onlyUnique);

        console.log('relatedPersonsIds: ', relatedPersonsIds);

        this.dispatchEvent(new CustomEvent('rowselect',
            {
                detail: {
                    eventSource: "thFileList",
                    amountOfFilesSelected: this.selectedDocumentsIds.length,
                    relatedPersonsIds
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

        if (payload.Related_Patent_Or_ID__c === this.recordId || //1 if insert
            payload.SDOC__ObjectID18__c === this.recordId || //1 if insert
            records.some(el => allIds.includes(el))) {   //2 if update/delete
            refreshApex(this.response);
        }
    }

    getAllIds() {
        return this.response.data.map(item => item.Id);
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

    handleRowAction(event) {
        let actionName = event.detail.action.name;
        console.log(actionName)

        switch (actionName) {
            case 'view':

                console.log(JSON.stringify(event.detail.action));
                console.log(event.detail.action.fileId)

                getContentDocumentIdForFilePreview({sDocId: event.detail.action.fileId})
                    .then(response => {
                        this[NavigationMixin.Navigate]({
                            type: 'standard__namedPage',
                            attributes: {
                                pageName: 'filePreview'
                            },
                            state: {
                                selectedRecordId: response
                            }
                        })
                    })

                break;
            case 'edit':

                this[NavigationMixin.GenerateUrl]({
                    type: "standard__webPage",
                    attributes: {
                        url: event.detail.action.redirectLink
                    }
                }).then(url => {
                    window.open(url, "_blank");
                });

                break;
            case 'delete':
                this.dispatchEvent(new CustomEvent('preloader', { detail: { isPreloader: true}}));
                console.log(event.detail.action.fileId)
                deleteDocument({contentVersionId: event.detail.action.fileId})
                    .finally(() => {
                        this.dispatchEvent(new CustomEvent('preloader', { detail: { isPreloader: false}}));
                        this.dispatchEvent(new CustomEvent('refresh'));
                    });
                break;
        }
    }

    // this two functions have different scope
    inited;

    constructor() {
        super();

        this.columns.forEach(col => {
            if (col.name === 'actions') {
                this.inited = true;
            }
        })

        // to prevent adding 2 columns with actions
        if (this.inited) return;

        this.columns.push(
            {name: 'actions', type: 'action', typeAttributes: {rowActions: this.getRowActions}}
        );
    }

    getRowActions(row, doneCallback) {
        const sDocId = row.Id;
        const fileId = row.SDOC__File_ID__c;
        console.log(fileId);
        const disabled = !(row.SDOC__Document_Format__c === 'PDF' && row.SDOC__Allow_Edit__c);
        const redirectLink = window.location.origin + '/apex/SDOC__SDRedirect?redirectPage=SDOC__SDEdit&sdid=' + row.Id;

        doneCallback([{
            'label': 'View file',
            'iconName': 'utility:preview',
            'name': 'view',
            fileId
        }, {
            'label': 'Edit file',
            'iconName': 'utility:edit',
            'name': 'edit',
            redirectLink,
            disabled
        }, {
            'label': 'Delete file',
            'iconName': 'utility:delete',
            'name': 'delete',
            fileId
        }]);
    }
}