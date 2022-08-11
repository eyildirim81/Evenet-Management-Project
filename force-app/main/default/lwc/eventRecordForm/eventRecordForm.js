import { LightningElement} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import EVENT_OBJECT from '@salesforce/schema/Event__c';
import NAME_FIELD from '@salesforce/schema/Event__c.Name__c';
import MAXSEAT_FIELD from '@salesforce/schema/Event__c.Max_Seats__c';
import ORGANIZER_FIELD from '@salesforce/schema/Event__c.Event_Organizer__c';
import STARTDATE_FIELD from '@salesforce/schema/Event__c.Start_Date_Time__c';
import ENDDATE_FIELD from '@salesforce/schema/Event__c.End_Date_Time__c';
import DETAIL_FIELD from '@salesforce/schema/Event__c.Event_Detail__c';
import LOCATION_FIELD from '@salesforce/schema/Event__c.Location__c';


import {NavigationMixin} from 'lightning/navigation';                 


export default class LightningRecordAccountForm extends NavigationMixin(LightningElement) {
    
    RecordId;
    objectName=EVENT_OBJECT;
    fields={name:NAME_FIELD,
            organizerName: ORGANIZER_FIELD,
            MaxSeat: MAXSEAT_FIELD,  
            StartDate:STARTDATE_FIELD,
            EndDate: ENDDATE_FIELD,
            Detail: DETAIL_FIELD,
            Location:LOCATION_FIELD }

    successHandler(event){

        const successEvent = new ShowToastEvent({
            title: 'Success!',
            message: 'Record has been created successfully! See it', 
            variant:"success"

    });
    this.dispatchEvent(successEvent);
    
    this.RecordId = event.detail.id;
        console.log("successHandler recordId ", this.RecordId);

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
                attributes: {
                recordId: this.RecordId, // record id 
                actionName: 'view'
            }
        });

}
    errorHandler(){

    const errorEvent = new ShowToastEvent({
        title: 'Failed!',
        message: 'An error occurred while creating the contact record!', 
        variant:"error"

});
    this.dispatchEvent(errorEvent);

}

}