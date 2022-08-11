@isTest
public with sharing class EventBatchSecondWayTest {
    @isTest
    private static void testMethod1() {
        //START STEP 1: PREPARE DATA 

        
        Event_Organizer__c eo=new Event_Organizer__c();
        eo.Name='Soft Innovas';
        eo.Email__c='soft@gmmail.com';
        eo.Phone__c='1234567';

        insert eo;

        list<Event__c> listEv = new list<Event__c>();
        for (Integer i = 1; i < 200; i++){

        Event__c ev = new Event__c(); 
        ev.Name__c='Test Event';
        ev.Max_Seats__c=50;   
        ev.Event_Organizer__c = eo.id;
        ev.Start_Date_Time__c=Datetime.newInstance(2020, 10, 22);
        ev.End_Date_Time__c=Datetime.newInstance(2020, 11, 23);
        ev.Live__c=false;
        listEv.add(ev);
        }
        
        system.debug('size of list ' + listEv.size());

        if(!listEv.isEmpty()){
            insert listEv;
        }
        //END STEP 1
        //step 2
        test.startTest();
        EventBatchSecondWay ab = new EventBatchSecondWay();
        ab.execute(null);

        // database.executeBatch(ab, 501);
        test.stopTest();

        //ASSERT
        // list<Event__c> events = [select id, End_Date_Time__c, Live__c from Event__c];
            // system.assertEquals(0,events.size());
        
            integer eventcount=[select COUNT() from Event__c];
            system.assertEquals(0, eventcount);
           integer x= limits.getEmailInvocations();
            system.assertEquals(0, x);
    }
}