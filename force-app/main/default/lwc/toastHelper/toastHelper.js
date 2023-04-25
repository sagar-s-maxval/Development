import {ShowToastEvent} from "lightning/platformShowToastEvent";

export {getSuccessToast, getErrorToast}

function getSuccessToast(title, message) {
    return new ShowToastEvent({
        title,
        message,
        variant: 'success'
    })
}

function getErrorToast(title, message) {
    return new ShowToastEvent({
        title,
        message,
        variant: 'error'
    })
}