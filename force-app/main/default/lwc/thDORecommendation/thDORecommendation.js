import {api, LightningElement, track} from 'lwc';

export default class ThDORecommendation extends LightningElement {
    @track isShowModal = false;

    @api recordId;

    showModalBox() {
        this.isShowModal = true;
    }

    hideModalBox() {
        this.isShowModal = false;
    }

}