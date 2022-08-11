public with sharing class InvocableSmartyStreetCaller {

    @InvocableMethod(label='Call SmartyStreet' description='Makes callout to SmartyStreet API')
    public static void makeCallout(list<Id> locationids) {
            run (locationids[0]);
    }
    @future(callout=true)
        public static void run(id locId){
            try {
                SmartyStreetCreds__c apiCreds= SmartyStreetCreds__c.getOrgDefaults();
                Location__c loc=[SELECT Street__c, State__c, Postal_Code__c, City__c FROM Location__c WHERE id =:locId WITH SECURITY_ENFORCED];
                string path= '/street-address?'
                            +'auth-id='+apiCreds.Auth_Id__c
                            +'&auth-token='+apiCreds.Auth_Token__c
                            +'&street='+EncodingUtil.urlEncode(loc.Street__c,'UTF-8')
                            +'&city='+EncodingUtil.urlEncode(loc.City__c,'UTF-8')
                            +'&state='+EncodingUtil.urlEncode(loc.State__c,'UTF-8')
                            +'&zipcode='+loc.Postal_Code__c
                            +'&match=enhanced';

                            // "https://us-street.api.smartystreets.com/street-address?auth-id=15b1e5ae-761e-a6b6-e1cd-c698f2673c65&auth-token=wYEaizXp2DsK5SRshD9s&candidates=10&street=4594%20Michael%20Jay%20st&city=Snellville&state=GA&zipcode=30039-7634&match=enhanced"


                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint('callout:SmartyStreet'+ path);
                request.setMethod('GET');
                HttpResponse response = http.send(request);
    
                system.debug('resp:'+ response.getBody());
                Boolean isSuccess=response.getStatusCode() ==200;
                Location__c xx=new Location__c();
                xx.id=locId;
                xx.Verified__c = isSuccess;
                update xx;
                
                
            } catch (Exception exc) {
    
                ErrorLog.insertErrorLog('Call SmartyStreet', exc.getMessage()); 
            }
        }
    }