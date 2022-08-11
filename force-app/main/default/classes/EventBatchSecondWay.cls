public class EventBatchSecondWay implements Database.Batchable<SObject>, database.stateful, Schedulable{

    public integer count=0;

    //Schedule funcionality
    public void execute(SchedulableContext sc){
        Database.executeBatch(new EventBatchSecondWay());
            }

    //Batch records query
    //start returns 1000 records
    public Database.QueryLocator start(database.BatchableContext bc){
        database.QueryLocator q1 = database.getQueryLocator([SELECT id 
                                                            from Event__c 
                                                            WHERE End_Date_Time__c<=:Datetime.now().addMonths(-2) 
                                                            And Live__c=false
                                                            ]); 
        system.debug(q1);
        return q1;
    }
    //the real 'what to do'
    //if we did not mention pagination number , SF will delete 200 records in each execution means 1000/200=5 jobs
    public void execute(Database.BatchableContext bc, List<Event__c> events){
        delete events;
        count++;
        }
        
    

    //send email daily job to public group members
    public void finish(Database.BatchableContext bc){

        system.debug('done with updating ALL the ACCOUNTS');
        system.debug('count in finish '+ count);
        
        //find members
        set<Id> userIds= new set<Id>();
        for (Groupmember gm : [Select UserorGroupId from GroupMember where Group.name='Daily Jobs']) {
            userIds.add(gm.UserOrGroupId); 
        }

        set<string> emailAddresses= new set<string>();
        for (user us : [select email from user where IsActive=true and id in: userIds]) {
            emailAddresses.add(us.Email);
            
        }

        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        mail.setSubject('Daily purge event job completed.');
        mail.setSenderDisplayName('Deleting Event Records');
        mail.setPlainTextBody('Daily purge event job is completed. you can check Setup---->Apex Jobs.');
        mail.setHtmlBody('<p>Dear User, scheduled batch is processed</p>');

        mail.setToAddresses( new list<String>(emailAddresses));
        Messaging.sendEmail(new list<Messaging.SingleEmailMessage>{mail});
    }
}