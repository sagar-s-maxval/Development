import {api, LightningElement, track} from 'lwc';
import apexSearch from '@salesforce/apex/LookupSearchController.search';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';

export default class SelectMultiCountry extends LightningElement {

    @track _jurisdictions = '';

    handleSearch(event) {
        const lookupElement = event.target;
        apexSearch(event.detail)
            .then(results => {
                lookupElement.setSearchResults(results);
            })
            .catch(error => {

            })
    }

    setTitles(event) {
        const lookupElement = event.detail.selectedTitles;
        let counties = '';
        lookupElement.forEach(e => {
            counties += e + '; ';
        })
        this._jurisdictions = counties;
        const attributeChangeEvent = new FlowAttributeChangeEvent('jurisdictionValues', this._jurisdictions);
        this.dispatchEvent(attributeChangeEvent);
    }

    @api
    get jurisdictionValues() {
        return this._jurisdictions;
    }
}