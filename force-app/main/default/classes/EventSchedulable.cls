public with sharing class EventSchedulable implements Schedulable{
    public void execute(SchedulableContext sc){
        Database.executeBatch(new EventBatch());
            }
}