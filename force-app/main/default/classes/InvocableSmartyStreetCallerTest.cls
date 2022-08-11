@isTest 
 private class InvocableSmartyStreetCallerTest {

    @istest 
    static void testNegative() {
        Location__c lc=new Location__c(Name='Test Address Name',
                                        City__c='TestCity',
                                        Postal_Code__c='TestPostalCode',
                                        State__c='teststate',
                                        Street__c='TestStreet',
                                        Country__c='USA'
                                        );

     test.startTest();
     insert lc;
     test.stopTest();

     integer logCount=[Select count() from Error_Log__c where Process_Name__c='Call SmartyStreet'];
     System.assertEquals(1, logCount);

    }

    @istest 
    static void testPositive() {
        Location__c lc=new Location__c(Name='Test Address Name',
                                        City__c='TestCity',
                                        Postal_Code__c='TestPostalCode',
                                        State__c='teststate',
                                        Street__c='TestStreet',
                                        Country__c='USA'
                                        );

     //set mock callout class
     Test.setMock(HttpCalloutMock.class, new  MockSmartyStreetAPI ());                                   

     test.startTest();
     insert lc;
     test.stopTest();

     
     Location__c lc1=[SELECT verified__c from Location__c where id =:lc.Id];
     system.assertEquals(true, lc1.Verified__c);

    }

    private class MockSmartyStreetAPI implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
    
        // Create a fake response
       HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}



}