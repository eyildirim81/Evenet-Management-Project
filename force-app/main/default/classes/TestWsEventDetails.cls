@isTest 
public with sharing class TestWsEventDetails {
    @istest 
    static void tester() {

        Event_Organizer__c eo=new Event_Organizer__c(Name='Test Organizer',
        Email__c='test@gmail.com',
        Phone__c='0005354');
        insert eo;

        Event__c ev=new Event__c();
        ev.Name__c= 'Test Event';
        ev.Event_Organizer__c=eo.Id;
        ev.Start_Date_Time__c=Datetime.now().addDays(14);
        ev.End_Date_Time__c=Datetime.now().addDays(45);
        ev.Max_Seats__c=25 ;
        ev.Live__c=true;
        insert ev;

        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/services/apexrest/EventDetails/';
        RestContext.request.httpMethod = 'GET';



        test.startTest();
        list<WsEventDetails.EventWrapper> events= WsEventDetails.getEventDetails();
        test.stopTest();

        system.assertEquals(1, events.size());

        WsEventDetails.EventWrapper result=events[0];
        system.assertEquals('Test Event', result.name);

    }
}