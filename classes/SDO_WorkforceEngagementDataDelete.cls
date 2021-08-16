public class SDO_WorkforceEngagementDataDelete implements Database.Batchable<sObject> {

    public String query;
    
    public SDO_WorkforceEngagementDataDelete(String object_name){
        query = 'Select Id From ' + String.escapeSingleQuotes(object_name);
    }
    
    public Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext batchableContext, List<sObject> records){
        delete records;
    }
    
    public void finish(Database.BatchableContext batchableContext){
        
    }
}