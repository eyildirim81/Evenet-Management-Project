public with sharing class ErrorLog {
    public static void insertErrorLog( string processName, string details) {

        Error_Log__c el=new Error_Log__c();
        el.Log_Date_Time__c=Datetime.now();
        el.Process_Name__c=processName;
        el.Log_Details__c=details;

        insert el;

    }
}