import { api, LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { getRecord } from 'lightning/uiRecordApi';

import getSpeaker from "@salesforce/apex/EventDetailsController.getSpeaker";
import getLocationDetails from "@salesforce/apex/EventDetailsController.getLocationDetails";
import getAttendees from "@salesforce/apex/EventDetailsController.getAttendees";

import userId from "@salesforce/user/Id"
import profile from "@salesforce/schema/User.Profile.Name";
const COLUMNS = [
    {label: "Name", fieldName: "Name", cellAttributes: {iconName: "standard:user", iconPosition: "left"}},
    {label: "Email", fieldName: "Email__c", type:"email"},
    {label: "Company Name", fieldName: "Company_Name__c"},
    {label: "Location", fieldName: "Location__c", cellAttributes: {iconName: "utility:location", iconPosition: "left"}},
];

export default class EventDetails extends NavigationMixin(LightningElement) {
    @api recordId;

    @track speakerList;
    @track eventRec;
    @track attendeesList;
    @track isAdmin = false;

    errors;
    columnsList = COLUMNS;
    user_id = userId;

    @wire (getRecord, {recordId: "$user_id", fields: [profile]})
    wiredMethod({data, error}){
        if(data){
            window.console.log("userRecord: ", data);
            //let userProfileName = data.
           //this.isAdmin = 
        }
        if(error){
            window.console.log("Error Occured ", JSON.stringify(error));
        }
    }

    handleSpeakerActive(){
        getSpeaker({
            eventId: this.recordId
        })
        .then(result => {
            result.forEach((speaker) => {
                speaker.Name = speaker.Speaker__r.Name;
                speaker.Email__c ="***************@gmail.com";
                speaker.Phone__c = speaker.Speaker__r.Phone__c;
                speaker.Picture__c= speaker.Speaker__r.Picture__c;
                speaker.AboutMe__c = speaker.Speaker__r.About_Me__c;
                speaker.CompanyName = speaker.Speaker__r.Company__c; //check where companyName was usd
            });

            this.speakerList = result;
            window.console.log("result: ", JSON.stringify(this.result));
            this.errors=undefined
        })
        .catch((err) => {
            this.errors= err;
            this.speakerList = undefined;
            wondow.console.log("ERR: ", this.errors);
        });

    }//continue from this part tomorrow

    createSpeaker(){
        const defaultValues = encodeDefaultFieldValues({
        Event__c: this.recordId
    });

    this[NavigationMixin.Navigate]({
        type: "standard__objectPage",
        attributes: {
            objectApiName: "Event_Speaker__c",
            actionName: "new"
        },
        state: {
            defaultFieldValues: defaultValues
        }
    });
    }

    handleLocationDetails(){
        getLocationDetails({
            eventId: this.recordId
        })
        .then(result => {
            if(result.Location__c){
                this.eventRec = result;
            } else {
                this.eventRec = undefined
            }
            this.errors = undefined
        })
        .catch(error => {
            this.errors = error;
            this.eventRec = undefined;
        })

    }

    handleEventAttendee(){
        getAttendees({
            eventId: this.recordId
        })
        .then(result => {
            result.forEach((attend) => {
                attend.Name = attend.Attendee__r.Name;
                attend.Email__c = "***************@gmail.com";
                attend.CompanyName__c = attend.Attendee__r.Company_Name__c;

                if(attend.Attendee__r.Location__c){
                    attend.Location__c= attend.Attendee__r.Location__r.Name;
                } else{
                    attend.Location = "Preferred not to say"
                }
            });
            this.attendeesList = result;
            this.errors = undefined;
        })
        .catch(error => {
            this.errors=error;
            this.attendeesList = undefined;
        });
    }

    createAttendee(){
        const defaultValues = encodeDefaultFieldValues({
            Event__c: this.recordId
        });
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Event_Attendee__c",
                actionName: "new"
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }
}