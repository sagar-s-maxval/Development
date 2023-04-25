import {api, LightningElement, track} from 'lwc';
import getPersons from '@salesforce/apex/DocuSignSendEnvelopeController.getPersons'

const COLUMNS = [
    {
        type: "url",
        label: "Name",
        fieldName: "link",
        hideDefaultActions: true,
        typeAttributes: {
            label: {fieldName: 'Name'},
            target: "_blank"
        }
    },
    {
        type: "text",
        label: "Email",
        fieldName: "SymphonyIPM__Email__c",
        hideDefaultActions: true
    },
    {
        type: "text",
        label: "Employment Status",
        fieldName: "SymphonyIPM__Employment_status__c",
        hideDefaultActions: true
    }
];

export default class ThPersonsList extends LightningElement {

    columns = COLUMNS;

    @track persons = [];
    showMainTable = false;

    selectedRows;
    selectedPersonsIds;

    @api setPersons(personsIds) {

        if (!personsIds) {
            this.persons = [];
            this.showMainTable = false;
            return;
        }

        getPersons({persons: personsIds})
            .then(response => {
                this.persons = response.map(item => {
                    let person = {...item};

                    person.link = '/' + person.Id;

                    return person;
                });

                // Pre-select all rows automatically
                this.selectedRows = personsIds;
                this.selectedPersonsIds = personsIds;

                this.showMainTable = this.persons.length > 0;

                this.dispatchEvent(new CustomEvent('select',
                    {
                        detail: {
                            eventSource: "thPersonsList",
                            amountOfPersonsSelected: this.persons.length
                        }
                    }));
            })


    }

    rowSelected(event) {
        let rows = event.detail.selectedRows;

        // 1. Save Selected
        this.selectedPersonsIds = rows.map(item => item.Id);

        // 2. fire amount to parent
        this.dispatchEvent(new CustomEvent('rowselect',
            {
                detail: {
                    eventSource: "thPersonsList",
                    amountOfSelected: this.selectedPersonsIds.length
                }
            }));
    }

    @api getSelectedSignersSrt() {
        return this.selectedPersonsIds;
    }
}