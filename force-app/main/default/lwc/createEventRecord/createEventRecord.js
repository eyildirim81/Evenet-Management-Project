import { LightningElement } from 'lwc';

import EVENT_OBJECT from '@salesforce/schema/Event__c';
import { createRecord } from 'lightning/uiRecordApi';

import {NavigationMixin} from 'lightning/navigation'; 

export default class CreateEventRecord extends NavigationMixin(LightningElement)  {

    formdata={};

    changeHandler(event){

        const {name, value} =event.target;
        this.formdata[name] =value;
        console.log(this.formdata);
    }

    createEvent(){
        const recordInput={

            apiName:EVENT_OBJECT.objectApiName,
            fields: this.formdata
        }
        createRecord(recordInput)
            .then(result=>{

                console.log(result);
                this.template.querySelector('form.contact').reset();
            })
            .catch (error => {
                console.log(error)

            })

            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                    attributes: {
                        recordId: this.recordId,
                        objectApiName: 'Event__c',
                        actionName: 'view'
                },
            });

        }
        
    }