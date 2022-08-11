public class EventBatch implements Database.Batchable<SObject>, database.stateful{

    public integer count=0;
    public Database.QueryLocator start(database.BatchableContext bc){
        database.QueryLocator q1 = database.getQueryLocator([select id, End_Date_Time__c, Live__c from Event__c]);
        system.debug(q1);
        return q1;
    }
    public void execute(Database.BatchableContext bc, List<Event__c> scope){
        list<Event__c>deleteEvents=new list<Event__c>();
        
        for (Event__c ev : scope) {
            if(ev.Live__c && ev.End_Date_Time__c<Datetime.now().addMonths(2)){
           deleteEvents.add(ev);
            count++;
        }
        }
        if(!deleteEvents.isEmpty()){
            //how many records updated?
        system.debug('count in execute method ' + count);
            delete deleteEvents;
        }
    }
    public void finish(Database.BatchableContext bc){

        system.debug('done with updating ALL the ACCOUNTS');
        system.debug('count in finish '+ count);
        AsyncApexJob apexJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: BC.getJobId()];
            
        //Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[] {apexJob.CreatedBy.Email};
        system.debug('apexJob.CreatedBy.Email : '+apexJob.CreatedBy.Email);
        mail.setToAddresses(toAddress);
        mail.setSubject('Apex Job status is ' + apexJob.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + apexJob.TotalJobItems + ' batches with '+ apexJob.NumberOfErrors + ' failures.');
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    
        
    }
}