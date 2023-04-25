import {api, LightningElement, track, wire} from 'lwc';
import getFinalDocuments from '@salesforce/apex/RequestRecommendationController.getFinalDocuments'
import setFinalDocuments from '@salesforce/apex/RequestRecommendationController.setFinalDocumentsToRecommendation'
import apexSearch from '@salesforce/apex/RequestRecommendationController.search';
import jurisdictionSearch from '@salesforce/apex/LookupSearchController.search';
import sendEmails from '@salesforce/apex/RequestRecommendationController.sendEmailNotification';
import createRecommendationOpinions
    from '@salesforce/apex/RequestRecommendationController.createRecommendationOpinions';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {createRecord} from "lightning/uiRecordApi";

import {NavigationMixin} from "lightning/navigation";

import RECOMMENDATION_OBJECT from "@salesforce/schema/D_O_Recommendation__c";

const COLUMNS = [
    {
        type: "text",
        label: "File Name",
        fieldName: "File_Name_Big__c",
        initialWidth: 250,
        sortable: 'true'
    },
    {
        label: 'Document Date', fieldName: 'Upload_Date__c', type: 'date', sortable: 'true',
        typeAttributes: {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
        }
    },
    {label: 'Comments', fieldName: 'Comments__c', type: 'text'},
    {label: 'Document Type', fieldName: 'Document_Type__c', type: 'text'},
];


export default class ThRequestRecommendation extends NavigationMixin(LightningElement) {

    @api recordId;

    @track documentIds;
    @track _personIds;
    @track _jurisdiction = '';
    @track sortBy;
    @track sortDirection;
    @track columns;
    @track data;
    @track filteredDataExists = true;
    @track textToFilterBy;
    response;

    jurisdictionIsEmpty;
    personIsEmpty;
    anyError = false;
    isLoading = false;
    recommendationId;
    adverseMarkValue;
    adversePartyValue;
    relatedClassesValue;
    deadlineValue;
    applicationRegistrationValue;
    commentsValue;

    sfdcBaseURL;

    connectedCallback() {
        this.getFinalDocument()
        this.sfdcBaseURL = window.location.origin;
    }

    filterBySearchKey(event) {
        this.textToFilterBy = event.target.value;

        let filteredRecords = this.response.filter(function (el) {
            return el.File_Name_Big__c.toLowerCase().includes(event.target.value.toLowerCase());
        });

        let selectedRecords = this.filteredDataExists ? this.template.querySelector("lightning-datatable").getSelectedRows() : [];

        this.data = [...new Map(selectedRecords.concat(filteredRecords).map((m) => [m.Id, m])).values()];

        if (event.target.value.trim().length === 0) {
            this.data = this.response;
            this.filteredDataExists = true;
        } else {
            this.filteredDataExists = this.data.length !== 0;
        }

    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.response));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1 : -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    }

    get getColumns() {
        if (!this.columns) {
            this.columns = [...COLUMNS];
        }
        return this.columns;
    }

    getFinalDocument() {
        getFinalDocuments({recordId: this.recordId})
            .then(resp => {
                this.response = resp.length === 0 ? false : resp;

                this.data = resp.map(item => {
                    let res = {...item};
                    res.fileName = item.File_Name_Big__c;
                    res.Upload_Date__c = item.Upload_Date__c;

                    return res;
                });

                console.log(this.response)
            });
    }

    isInputValid() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        console.log(inputFields)
        inputFields.forEach(inputField => {

            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }

            if (this._jurisdiction.length === 0) {
                this.jurisdictionIsEmpty = true;
                isValid = false;
            }

            console.log(this._personIds.length)
            if (this._personIds.length === 0) {
                this.personIsEmpty = true;
                isValid = false;
            }
        });
        return isValid;
    }

    createRecommendation() {
        this.isLoading = true;
        if (this.isInputValid()) {
            const fields = {
                'Trademark__c': this.recordId,
                'Jurisdiction__c': this._jurisdiction,
                'Adverse_Mark__c': this.adverseMarkValue,
                'Adverse_Party__c': this.adversePartyValue,
                'Related_Classes__c': this.relatedClassesValue,
                'Deadline__c': this.deadlineValue,
                'Application_Registration__c': this.applicationRegistrationValue,
                'Comments__c': this.commentsValue,
                'Status__c': 'Pending'
            };

            const recordInput = {apiName: RECOMMENDATION_OBJECT.objectApiName, fields};

            createRecord(recordInput)
                .then((recommendation) => {
                    this.recommendationId = recommendation.id;

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Success",
                            message: "Request created successfully!",
                            variant: "success"
                        })
                    );
                    // setFinalDocuments({recommendationId: this.recommendationId, documentIds: this.documentIds});
                    // createRecommendationOpinions({personIds: this._personIds, recommendationId: this.recommendationId});
                    // sendEmails({personIds: this._personIds, recordId: this.recommendationId});
                })
                .finally(() => {
                    setFinalDocuments({recommendationId: this.recommendationId, documentIds: this.documentIds});
                    createRecommendationOpinions({personIds: this._personIds, recommendationId: this.recommendationId});
                    // sendEmails({personIds: this._personIds, recordId: this.recommendationId});
                    this.navigateToViewAccountPage();
                    this.isLoading = false;
                });
        }
    }

    navigateToViewAccountPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recommendationId,
                objectApiName: 'D_O_Recommendation__c',
                actionName: 'view'
            },
        });
    }

    setRequestorNames(event) {
        const lookupElementIds = event.detail.selectedIds;
        let personIds = [];
        lookupElementIds.forEach(e => {
            personIds.push(e);
        })
        this._personIds = [...personIds];

        if (this._personIds.length > 0) {
            this.personIsEmpty = false;
        }
    }

    setJurisdictionId(event) {
        const lookupElement = event.detail.selectedIds;

        lookupElement.forEach(e => {
            this._jurisdiction = e;
            if (this._jurisdiction.length > 0) {
                this.jurisdictionIsEmpty = false;
            }
        })
    }

    handleRowAction(event) {
        //this.sortData('File_Name_Big__c','asc');

        let uniqueIds = [];
        let rows = event.detail.selectedRows;
        rows.forEach(e => {
            uniqueIds.push(e.Id);
        })
        this.documentIds = [...uniqueIds];
    }

    handleSearch(event) {
        const lookupElement = event.target;
        apexSearch(event.detail)
            .then(results => {
                lookupElement.setSearchResults(results);
            })
            .catch(error => {

            })
    }

    handleJurisdictionSearch(event) {
        const lookupElement = event.target;
        jurisdictionSearch(event.detail)
            .then(results => {
                lookupElement.setSearchResults(results);
            })
            .catch(error => {

            })
    }

    handleAdverseMarkChange(event) {
        this.adverseMarkValue = event.target.value;
    }

    handleAdversePartyChange(event) {
        this.adversePartyValue = event.detail.value;
    }

    handleRelatedClassesChange(event) {
        this.relatedClassesValue = event.detail.value;
    }

    handleApplicationRegistrationChange(event) {
        this.applicationRegistrationValue = event.detail.value;
    }

    handleCommentsChange(event) {
        this.commentsValue = event.detail.value;
    }

    handleDeadlineChange(event) {
        if (new Date(event.detail.value) < new Date(this.todaysDate)) {
            this.anyError = true;
            event.target.setCustomValidity('The date must be ' + this.todaysDate + ' or later');
        } else {
            event.target.setCustomValidity('');
            this.deadlineValue = event.detail.value;
            this.anyError = false;
        }
        event.target.reportValidity();
    }

    get todaysDate() {
        let today = new Date();
        let dd = String(today.getDate()).padStart(2, '0');
        let mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        let yyyy = today.getFullYear();
        today = mm + '/' + dd + '/' + yyyy;
        return today
    }


}