import {LightningElement, api} from 'lwc';

export default class RecordTypeDependentPicklist extends LightningElement {

    // {String} API Name of Object
    @api objectName;
    // {String} API Name of Picklist value (for this specific Object)
    @api fieldName;
    // {String} Id of RecordType the picklist values should be restricted with
    @api recordTypeId;

    // {Boolean} Whether or not the input is required
    @api isRequired;
    // {String} Error message non selected
    @api errorMessage;

    /* Output Attributes */
    // {String} API value of selected picklist value (not the label, but the value)
    @api fieldValue;

    // {Validation} Function Lightning Flows execute on 'next'-button to validate whether component is valid
    @api validate() {
        if (!this.isRequired
            || (this.isRequired && this.fieldValue && this.fieldValue.length > 0)) {
            return {isValid: true};
        } else {
            return {
                isValid: false,
                errorMessage: this.errorMessage
            };
        }
    }

    /**
     * Function to handle the picklist selection and assign to the fieldValue variable
     */
    handleFieldChange(event) {
        this.fieldValue = event.target.value;
    }
}