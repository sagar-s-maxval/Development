import {api, LightningElement, wire} from 'lwc';
import getTable from '@salesforce/apex/RelatedListTableViewController.getTable'
import updateRecords from '@salesforce/apex/RelatedListTableViewController.updateRecords'
import {refreshApex} from "@salesforce/apex";
import {
    splitWidthString,
    doSort,
    createIndexMap,
    addNameUrlField,
    replaceDateType,
    makeSortable,
    overrideColumnWidths,
    replaceNameColumn
} from './helper'
import {getSuccessToast, getErrorToast} from 'c/toastHelper'

const DEFAULT_COLUMN_WIDTH = 200;

export default class RelatedListTableEditable extends LightningElement {

    @api sObjectApiName;
    @api parentLookupField;
    @api fieldSet;
    @api nameAsUrl;
    @api recordId;
    @api columnWidthOverride;
    @api tableHeight;

    sortedBy;
    sortDirection;

    error;

    @wire(getTable,
        {
            recordId: '$recordId',
            sObjectApiName: '$sObjectApiName',
            parentLookupField: '$parentLookupField',
            fieldSet: '$fieldSet'
        }
    )
    response;

    renderedCallback() {
        if (this.tableHeight) {
            let div = this.template.querySelector('div[data-my-id="tableDiv"]');

            if (div) {
                div.style.maxHeight = `${this.tableHeight}px`
                div.style.overflow = 'auto';
            }
        }
    }

    get columns() {
        let widths = splitWidthString(this.columnWidthOverride, DEFAULT_COLUMN_WIDTH);
        let indexMap = createIndexMap(this.response.data.columns);

        return this.response.data.columns
            .map(replaceDateType)
            .map(makeSortable)
            .map(column => overrideColumnWidths(column, widths, DEFAULT_COLUMN_WIDTH, indexMap))
            .map(column => replaceNameColumn(column, this.nameAsUrl));
    }

    get data() {
        return [...this.response.data.records]
            .sort((a, b) => doSort(a, b, this.sortedBy, this.sortDirection))
            .map(record => addNameUrlField(record, this.nameAsUrl));
    }

    save() {
        // if user doesn't close edit window and press save
        // we get draftValues from table before table actually save them,
        // so we don't get last modified value
        // to overcome this we add timeout to be sure that table save all edited values
        setTimeout(() => {
            let table = this.template.querySelector('lightning-datatable');

            let draftValues = table.draftValues;

            updateRecords({records: draftValues})
                .then(() => {
                    this.dispatchEvent(getSuccessToast('Success', 'Records has been updated'));
                    refreshApex(this.response);
                })
                .catch(error => {
                    this.dispatchEvent(getErrorToast('Error Updating Records', error.body.message));
                })
        }, 400)


    }

    cancel() {
        let table = this.template.querySelector('lightning-datatable');

        table.draftValues = [];
    }

    sortChange(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
    }

}