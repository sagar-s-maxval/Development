import {api, LightningElement, track} from 'lwc';
import saveFile from '@salesforce/apex/DocuSignFileUploadController.saveFile';

export default class CustomFileUpload extends LightningElement {
    @track filesName;
    @track loader = false;
    fileData;
    @api recordId;

    get acceptedFormats() {
        return ['.pdf', '.jpg', '.jpeg', '.png', '.doc', '.docx', '.mp4'];
    }

    openFileUpload(event) {
        let files = event.detail.files;
        let file = files[0];

        this.fileData = {
            'fileName': files[0].name,
            'contentVersionId': file.contentVersionId,
            'recordId': this.recordId
        };

        let { fileName, contentVersionId, recordId } = this.fileData;

        this.loader = true;

        saveFile({
            fileName, recordId, contentVersionId
        })
            .then(() => {
                this.fileData = null;
                this.loader = false;
                this.filesName = files[0].name;
            })

        this.dispatchEvent(new CustomEvent("fileuploaded"));
    }
}