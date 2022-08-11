public with sharing class EventSpeakerHandler {
    public static void validateSpeaker(list<Event_Speaker__c> triggerNew,
                                       list<Event_Speaker__c> triggerOld,
                                       map<id, Event_Speaker__c> triggerNewMap,
                                       map<id, Event_Speaker__c> triggerOldMap){
        

            set<id> speakerIds=new set<id>();
            set<id>eventIds=new set<id> ();
            map<string,Event_Speaker__c> eventSpeakerMap=new map<string,Event_Speaker__c>();
   
            for (Event_Speaker__c es : triggerNew) {
                speakerIds.add(es.Speaker__c);
                eventIds.add(es.Event__c);
   
                string myKey=string.valueOf(es.Speaker__c)+string.valueOf(es.Event__c);
                eventSpeakerMap.put(myKey,es);
                
            }
   
            list<Event_Speaker__c> listEs=[select id, speaker__c, event__c from Event_Speaker__c where Speaker__c in:speakerIds AND event__c in:eventIds];
   
            for(Event_Speaker__c es:listEs){
                string systemKey=string.valueOf(es.Speaker__c)+string.valueOf(es.Event__c);
                Event_Speaker__c toBeFailed=eventSpeakerMap.get(systemKey);
   
            
            if(toBeFailed!=Null){
                toBeFailed.addError('This is duplicate record '+ es.id);
            }
   
        } 
        
    }
}