public with sharing class EventDetailsController {
   
  @AuraEnabled
  public static List<Event_Speaker__c> getSpeaker(String eventId){

    return [SELECT id, Name, Speaker__c, Speaker__r.Name,Speaker__r.Phone__c, Speaker__r.Email__c, Speaker__r.Company__c, Speaker__r.Picture__c, Speaker__r.About_Me__c
            FROM Event_Speaker__c
            WHERE Event__c= :eventId
            WITH SECURITY_ENFORCED
    ];
    
  }  
  @AuraEnabled
  public static Event__c getLocationDetails(String eventId){

    return [SELECT id, Name, Location__c, Location__r.Name,Location__r.City__c,Location__r.Country__c,Location__r.Land_Mark__c, Location__r.Postal_Code__c,Location__r.State__c,Location__r.Street__c
            FROM Event__c
            WHERE Id= :eventId
            WITH SECURITY_ENFORCED
    ];
    
  }  
  @AuraEnabled
  public static List<Event_Attendee__c> getAttendees(String eventId){

    return [SELECT id, Name, Attendee__c, Attendee__r.Name,Attendee__r.Email__c,Attendee__r.Company_Name__c,Attendee__r.Location__c,Attendee__r.Location__r.Name
            FROM Event_Attendee__c
            WHERE Event__c= :eventId
            WITH SECURITY_ENFORCED
    ];
    
  }  
  
}