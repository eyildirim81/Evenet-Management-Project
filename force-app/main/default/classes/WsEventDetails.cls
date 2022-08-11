@RestResource(urlMapping='/EventDetails/*')
global class WsEventDetails {


    //https://melek-dev-ed.my.salesforce.com/services/apexrest/EventDetails/
    @HttpGet
    global static list<EventWrapper> getEventDetails() {

        list<EventWrapper> events=new list<EventWrapper>();
        for(Event__c ev:[SELECT id,Name, Name__c, Start_Date_Time__c,End_Date_Time__c, Event_Type__c,  Event_Organizer__r.Name 
                        FROM Event__c where Live__c=true 
                        AND Start_Date_Time__c>=: Date.today() 
                        WITH SECURITY_ENFORCED
                        ] )
        {
            events.add(new EventWrapper(ev));
                        }
            return events;
        
}

    global class EventWrapper{
       global string eventId;
        global String stdName;
        global String name;
        global string startDate;
        global Datetime endDate;
        global string eventType;
        global string eventOrganizer;

        global EventWrapper(Event__c event){
            this.eventId=event.id;
            this.stdName=event.Name;
            this.name=event.Name__c;
            this.startDate=event.Start_Date_Time__c.format('yyyy-MM-dd HH:mm');
            this.endDate=event.End_Date_Time__c;
            this.eventType=event.Event_Type__c;
            this.eventOrganizer=event.Event_Organizer__r.Name;


        }

    }
}