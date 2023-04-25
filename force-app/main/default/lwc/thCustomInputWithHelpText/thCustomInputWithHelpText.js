import {api, LightningElement, track} from 'lwc';
import apexSearch from '@salesforce/apex/LookupSearchController.search';
import {FlowAttributeChangeEvent} from "lightning/flowSupport";

export default class thCustomInputWithHelpText extends LightningElement {

    @api isInputText = false;
    @api isInputRichText = false;
    @api isInputCheckbox = false;
    @api required = false;
    @api helpText;
    @api textInputHelpText;
    @api textInputLabel;
    @api richTextInputLabel;
    @api textInputDefaultValue = '';
    @api richTextInputDefaultValue = '';
    @api checkboxOutputValue = ['worldwide'];
    @api _jurisdictionIds = '';

    jurPresent = false;
    value = ['worldwide'];

    allowedFormats = [
        'font',
        'size',
        'bold',
        'italic',
        'underline',
        'strike',
        'list',
        'indent',
        'align',
        'link',
        'image',
        'clean',
        'table',
        'header',
        'color',
        'background',
        'code',
        'code-block',
        'script',
        'blockquote',
        'direction',
    ];

    connectedCallback() {
        //remove table
        const reg = /\<table.*\>/;
        this.richTextInputDefaultValue = this.richTextInputDefaultValue.replace(reg,"");
        this.richTextInputDefaultValue = this.richTextInputDefaultValue.replace('</table>',"");
    }

    get options() {
        return [
            { label: 'Worldwide Search', value: 'worldwide' },
            { label: 'Add Specific Jurisdictions', value: 'Add Specific Jurisdictions' },
        ];
    }

    handleChange(e) {
        this.checkboxOutputValue = e.detail.value;
        console.log(e.detail.value)
        this.jurPresent = this.checkboxOutputValue.find(element => element === 'Add Specific Jurisdictions') === 'Add Specific Jurisdictions';
        console.log(this.checkboxOutputValue)
        const attributeChangeEvent = new FlowAttributeChangeEvent('checkboxOutputValue', this.checkboxOutputValue);
        this.dispatchEvent(attributeChangeEvent);
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

    handleTextInputChange(event) {
        this.textInputDefaultValue = event.target.value;
        const attributeChangeEvent = new FlowAttributeChangeEvent('textInputDefaultValue', this.textInputDefaultValue);
        this.dispatchEvent(attributeChangeEvent);
    }

    handleRichTextInputChange(event) {
        this.richTextInputDefaultValue = event.target.value;
        const attributeChangeEvent = new FlowAttributeChangeEvent('richTextInputDefaultValue', this.richTextInputDefaultValue);
        this.dispatchEvent(attributeChangeEvent);
    }

    setJurisdictionIds(event) {
        const lookupElement = event.detail.selectedIds;
        let counties = '';

        for (let i = 0; i < lookupElement.length; i++) {
            counties += lookupElement.length - 1 === i ? lookupElement[i] : lookupElement[i] + ',';
        }
        this._jurisdictionIds = counties;
        const attributeChangeEvent = new FlowAttributeChangeEvent('_jurisdictionIds', this._jurisdictionIds);
        this.dispatchEvent(attributeChangeEvent);
    }


}