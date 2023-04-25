import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default function (error, lightningElem, consoleLog = false) {
    let errorMsgs = error;

    if (error && typeof (error) == 'object') {
        errorMsgs = getErrorMessages(error).join(', ');
    }

    if (consoleLog) {
        console.log('Error: ' + errorMsgs);
    }

    let evt = new ShowToastEvent({
        title: 'Error',
        message: errorMsgs,
        variant: 'error',
    });

    lightningElem.dispatchEvent(evt);
}

/**
 * Reduces one or more LDS errors into a string[] of error messages.
 * @param {FetchResponse|FetchResponse[]} errors
 * @return {String[]} Error messages
 */
export function reduceErrors(errors) {
    if (!Array.isArray(errors)) {
        errors = [errors];
    }

    return (
        errors
            // Remove null/undefined items
            .filter(error => !!error)
            // Extract an error message
            .map(error => {
                // Simple string error
                if (typeof error === 'string' || error instanceof String) {
                    return error;
                }

                // any error with messages
                let errorMessages = getErrorMessages(error);
                if (errorMessages && errorMessages.length > 0) {
                    return errorMessages;
                }

                // Unknown error shape so try HTTP status text
                return error.statusText;
            })
            // Flatten
            .reduce((prev, curr) => prev.concat(curr), [])
            // Remove empty strings
            .filter(message => !!message)
    );
}

// recursive function to return array of all messages from error of any type
function getErrorMessages(theObject) {
    let result = [];
    for (let key in theObject) {
        if (key === 'message' && typeof theObject[key] === 'string') {
            result.push(theObject[key]);
        }
        if (theObject[key] && theObject[key] instanceof Object) {
            result = result.concat(getErrorMessages(theObject[key]));
        }
    }
    return result;
}

export const getErrors = (errors) => reduceErrors(errors).join('; ');