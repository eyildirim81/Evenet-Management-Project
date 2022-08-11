trigger EventSpeaker on Event_Speaker__c (before insert,before update ) {

    if (trigger.isBefore) {
        if(trigger.isInsert || trigger.isUpdate){
            EventSpeakerHandler.validateSpeaker(trigger.New, trigger.Old, trigger.NewMap, trigger.OldMap);
        }  
    }

}