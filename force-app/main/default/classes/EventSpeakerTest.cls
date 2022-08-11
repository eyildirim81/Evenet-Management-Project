@istest 
public with sharing class EventSpeakerTest {
    @TestSetup
    
    public static void makeData() {

        Event_Organizer__c eo=new Event_Organizer__c(Name='Test Organizer',
                                                    Email__c='test@gmail.com',
                                                    Phone__c='0005354');
        insert eo;
    
            Event__c ev=new Event__c();
            ev.Name__c= 'Wedding ';
            ev.Event_Organizer__c=eo.Id;
            ev.Start_Date_Time__c=Datetime.now().addDays(1);
            ev.End_Date_Time__c=Datetime.now().addDays(65);
            ev.Max_Seats__c=25 ;
            ev.Live__c=true;
        insert ev;
            
            Speaker__c sp=new Speaker__c();
            sp.Name='bahar ';
            sp.Email__c= 'bahar@gmail.com';
            sp.Phone__c='1256325';
        insert sp;

            Event_Speaker__c es=new Event_Speaker__c();
            es.Event__c= ev.id;
            es.Speaker__c=sp.id;
     
            insert es;
    }

    @istest 
    public static void testSuccess(){

        Event_Speaker__c ES=[select id, event__c, speaker__c from Event_Speaker__c limit1];

        test.startTest();
        try {
            Event_Speaker__c a=new Event_Speaker__c();
            a.Event__c=ES.Event__c;
            a.Speaker__c=ES.Speaker__c;
            insert a;
            
        } catch (Exception exc) {
            
        test.stopTest();
        integer systemcount=[select COUNT()from Event_Speaker__c];
        system.assertEquals(1, systemcount);
}
    }
}