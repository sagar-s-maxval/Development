import {api, LightningElement, wire} from 'lwc';
import {getFieldValue, getRecord} from "lightning/uiRecordApi";

import DISPUTE_OPPOSITION_OBJECT from "@salesforce/schema/SymphonyIPMExt__Dispute_Opposition__c";
import TRADEMARK from "@salesforce/schema/D_O_Recommendation__c.Trademark__c";
import TRADEMARK_JURISDICTION from "@salesforce/schema/D_O_Recommendation__c.Trademark__r.SymphonyIPM__Jurisdiction1__c";
import TRADEMARK_APPLICATION from "@salesforce/schema/D_O_Recommendation__c.Trademark__r.SymphonyIPM__Application_No__c";
import TRADEMARK_REGISTRATION from "@salesforce/schema/D_O_Recommendation__c.Trademark__r.SymphonyIPM__Registration_No__c";
import TRADEMARK_REGISTRATION_DATE from "@salesforce/schema/D_O_Recommendation__c.Trademark__r.SymphonyIPM__Registration_Date__c";
import TRADEMARK_FILLING_DATE from "@salesforce/schema/D_O_Recommendation__c.Trademark__r.SymphonyIPM__Filing_Date__c";
import FINAL_RECOMMENDATION from "@salesforce/schema/D_O_Recommendation__c.Final_Recommendation__c";
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

const FIELDS = [TRADEMARK, FINAL_RECOMMENDATION, TRADEMARK_JURISDICTION, TRADEMARK_APPLICATION, TRADEMARK_REGISTRATION, TRADEMARK_REGISTRATION_DATE, TRADEMARK_FILLING_DATE];

export default class ThCreateDisputeOpposition extends NavigationMixin(LightningElement) {

    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    doRecommendation


    createRecordWithDefaultValues() {
        //Object will be having field names and values
        const defaultValues = encodeDefaultFieldValues({
            Trademark__c: getFieldValue(this.doRecommendation.data, TRADEMARK),
            D_O_Recommendation__c: this.recordId,
            SymphonyIPMExt__Jurisdiction__c: getFieldValue(this.doRecommendation.data, TRADEMARK_JURISDICTION),
            SymphonyIPMExt__Status__c: 'Active',
            Application_Number__c: getFieldValue(this.doRecommendation.data, TRADEMARK_APPLICATION),
            Filing_Date__c: getFieldValue(this.doRecommendation.data, TRADEMARK_FILLING_DATE),
            Registration_Date__c: getFieldValue(this.doRecommendation.data, TRADEMARK_REGISTRATION_DATE),
            Registration_Number__c: getFieldValue(this.doRecommendation.data, TRADEMARK_REGISTRATION)

        });

        console.log(this.doRecommendation.data)

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'SymphonyIPMExt__Dispute_Opposition__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }
}