import { api, LightningElement, track } from 'lwc';

export default class Searcher extends LightningElement {

   @track keyword;

   @api isRequired='false';
   @api cmpLabel='Search Event';
   @api showLabel= 'true';

   renderedCallback(){
    if(this.isRequired==="true"){
        let picklistInfo=this.template.querySelector('lightning-input');
        picklistInfo.required = true;

        this.isRequired="false";
    }
   }

   handleChange(event){
    var keyword =event.target.value;

    if(keyword && keyword.length>=2){
        let searchEvent= new CustomEvent ('search',
        {detail : { value : keyword }});

        this.dispatchEvent(searchEvent);

    }
   }
}