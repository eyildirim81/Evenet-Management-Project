import searchByKeyword from '@salesforce/apex/EventDetailsService.searchByKeyword';
import upcomingEvents from '@salesforce/apex/EventDetailsService.upcomingEvents';
import { LightningElement, track } from 'lwc';

const COLUMNS = [
    {
        label: "View",
        fieldName: "detailsPage",
        type: "url",
        wrapText: "true",
        typeAttributes: {
            label: {
                fieldName: "Name__c"
            },
            target: "_self"
        }
    },
    {
        label: "Name",
        fieldName: "Name__c",
        wrapText: "true",
        cellAttributes: {
            iconName: "standard:event",
            iconPosition:"Left"
        }    
    },
    {
        label: "Event Organizer",
        fieldName: "organizer",
        wrapText: "true",
        cellAttributes: {
            iconName: "standard:user",
            iconPosition: "left"
        }
    },
    {
        label:"Location",
        fieldName: "Location",
        wrapText: "true",
        type: "text",
        cellAttributes: {
            iconName: "utility:location",
            iconPosition: "left"
        }
    }
]
export default class EventList extends LightningElement {

    columnsList = COLUMNS;
    error;
    startDateTime;

    @track result;
    @track recordsToDisplay;

    connectedCallback (){
        this.upcomingEventsFromApex();
    }
    upcomingEventsFromApex (){
        console.log("upcoming eventsFromApex run.");
        upcomingEvents()
        .then((data) => {
            console.log("data: " + JSON.stringify(data));

            data.forEach((record) => {
                record.detailsPage = "https://"+window.location.host+"/"+record.Id;
                record.organizer = record.Event_Organizer__r.Name;

                if(record.Location__c) {
                    record.Location = record.Location__r.Name;
                }else{
                    record.Location = "This is a Virtual Event";
                }
            });
            this.result = data;
            this.recordsToDisplay = data;
            this.error = undefined;
        })
        .catch((err) => {
            console.log('ERR:' + JSON.stringify(err));
            this.error = JSON.stringify(err);
            this.result = undefined;
        });
    }

    handleSearch(event) {
        let keyword = event.detail.value;
        if(keyword && keyword.length >=2){
            searchByKeyword({
                name : keyword
            })        
        .then((data) => {
            console.log("data:" + JSON.stringify(data));

            data.forEach((record) => {
                record.detailsPage = "https://"+window.location.host + "/" + record.Id;
                record.organizer = record.Event_Organizer__r.name;

                if (record.Location__c){
                    record.Location = record.Location__r.Name;
                }else{
                    record.Location = "This is a Virtual Event";
                }
            });
            this.result = data;
            this.recordsToDisplay = data;
            this.error = undefined;
        })
        .catch((err) =>{
            console.log('ERR:' + JSON.stringify(err));
            this.error = JSON.stringify(err);
            this.result = undefined;
        });
    }

        let filteredEvents = this.result.filter((record, index, arrayobject) => {
            return record.Name__c.toLowerCase().includes(keyword.toLowercase());
        });

        if(keyword && keyword.length >=2){
            this.recordsToDisplay = filteredEvents;
        }else {
            this.recordsToDisplay = this.result;
        }
    }
    handleStartDate(event){
        let valuedatetime = event.target.value;
        console.log("selectedDate:"+valuedatetime);

        let filteredEvents = this.result.filter((record, index, arrayobject) => {
            return record.Start_Date_Time__c >= valuedatetime;
        });
        this.recordsToDisplay = filteredEvents;
    }
    handleLocationSearch (event) {
        let keyword = event.detail.value;

        let filteredEvents = this.result.filter((record, index, arrayobject)=>{
            return record.Location.toLowerCase().includes(keyword.toLowerCase());
        });

        if(keyword && keyword.length >=2) {
            this.recordsToDisplay = filteredEvents;
        } else {
            this.recordsToDisplay = this.result;
        }
    } 
            
}