import {api, LightningElement, wire} from 'lwc';
import getDiaryNotes from '@salesforce/apex/DiaryNotesTableController.getDiaryNotes';

const columns = [
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date'},
    { label: 'Due Date', fieldName: 'SymphonyIPMExt__Due_Date_if_any__c', type: "date-local",
        typeAttributes:{
            weekday: "long",
            year: "numeric",
            month: "short",
            day: "2-digit"
        } },
    { label: 'Legacy Information', fieldName: 'Legacy_Information__c' },
    { label: 'Action', fieldName: 'SymphonyIPMExt__Action__c' },
    { label: 'Assigned To', fieldName: 'assignedTo'},
    { label: 'Notes', fieldName: 'SymphonyIPMExt__Note__c'},
];

export default class DiaryNotesTable extends LightningElement {

    @api objectApi
    @api showPinnedNotes
    @api recordId;
    @wire(getDiaryNotes,{recordId: '$recordId', objectApi: '$objectApi'})
    diaryNotes;

    columns = columns;

    get data(){
        console.log(this.diaryNotes.data)
        if(this.showPinnedNotes){
            return this.diaryNotes.data.filter(note => note.SymphonyIPMExt__Is_Pinned_Note__c).map((note) => {
                let res = {...note};
                res.assignedTo = res.SymphonyIPMExt__Assigned_To_User__c ? res.SymphonyIPMExt__Assigned_To_User__r.Name : undefined;
                return res;
            });
        }
        else {
            return this.diaryNotes.data.map((note) => {
                let res = {...note};
                res.assignedTo = res.SymphonyIPMExt__Assigned_To_User__c ? res.SymphonyIPMExt__Assigned_To_User__r.Name : undefined;
                return res;
            })
        }
    }

    @api
    get label() {
       return this.showPinnedNotes ? 'Pinned Notes' : 'Notes';
   }
}