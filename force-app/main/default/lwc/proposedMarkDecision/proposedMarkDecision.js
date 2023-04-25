import {
    api,
    LightningElement
} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';


import updateProposedMark from '@salesforce/apex/ProposedMarkDecisionController.updateProposedMark';

export default class ProposedMarkDecision extends NavigationMixin(LightningElement) {

    @api recordId;
    isLoading = false;
    isPromoted = false;
    data = {
        status: '',
        isCommonLaw: false
    }

    get options() {
        return [
            {label: 'Promote to Mark', value: 'Completed - Promoted to Mark'},
            {label: 'Close this proposed Mark', value: 'Completed - Cancelled'}
        ];
    }

    handleChange = (event) => {
        const name = event.target.name;
        const value = event.target.value;

        this.isPromoted = value === 'Completed - Promoted to Mark';
        console.log(this.isPromoted)
        this.data = {
            ...this.data,
            [name]: value
        }

    }

    handleCheckboxChange = (event) => {
        const value = event.target.checked;

        this.data = {
            ...this.data,
            isCommonLaw: value
        }
    }

    handleSubmit() {
        //alert('loaded');
        if (this._isValid()) {
            this.isLoading = true;
            updateProposedMark({
                recordId: this.recordId,
                data: JSON.stringify(this.data)
            }).then((response) => {
                this._showSuccessToast(response.message);
                console.log(response)
                console.log(response.next)
                switch (response.next) {
                    case 'navigateToMark':
                        this._navigateToRecord(response.mark.id);
                        break;

                    case 'navigateToFlow':
                        this._navigateToPage(this.recordId);
                        break;

                    default:
                }
                if (response.message === 'PMR closed successfully.') {
                    window.location.reload();
                }
                this.isLoading = false;
            }).catch((error) => {
                alert(JSON.stringify(error));
                console.log(error);
                this.isLoading = false;
            })
        }
    }

    _isValid = () => {
        return [
            ...this.template.querySelectorAll('.validate')
        ].filter((el) => {
            return el;
        }).reduce((validSoFar, el) => {
            el.reportValidity()
            return validSoFar && el.checkValidity()
        }, true);
    }

    _showSuccessToast = (message) => {
        const showToast = new ShowToastEvent({
            message: message || '',
            variant: 'success'
        });

        this.dispatchEvent(showToast);
    }

    _navigateToRecord = (recordId) => {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
    }

    _navigateToPage = (url) => {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url
            }
        }, true);
    }

}