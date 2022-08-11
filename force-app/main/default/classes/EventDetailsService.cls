public with sharing class EventDetailsService {
    @AuraEnabled
    public static List<Event__c> upcomingEvents(){
        try {
            return [SELECT Id, Name, Name__c, Event_Detail__c, Location__c, Location__r.Name,
            Event_Organizer__c, Start_Date_Time__c, Event_Organizer__r.Name
            FROM Event__c
            WHERE Start_Date_Time__c >= TODAY
            AND Live__c = true
            WITH SECURITY_ENFORCED];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Event__c> searchByKeyword(String name){
        try {
            string nameLike = '%' + name + '%';
            return [SELECT Id, Name, Name__c, Event_Detail__c, Location__c, Location__r.Name,
            Event_Organizer__c, Start_Date_Time__c, Event_Organizer__r.Name
            FROM Event__c
            WHERE Start_Date_Time__c >= TODAY
            AND Live__c = true
            AND Name__c LIKE : nameLike
            WITH SECURITY_ENFORCED];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}