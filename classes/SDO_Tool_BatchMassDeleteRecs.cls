Global class SDO_Tool_BatchMassDeleteRecs Implements Database.batchable<sobject>{
     global final string query;
     global SDO_Tool_BatchMassDeleteRecs(string q){
          query=q;
     }
     global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
     }
     global  void execute(Database.BatchableContext BC,List<SObject> scope){
         delete scope;
         Database.emptyRecycleBin(scope);
    }
    global void finish(Database.BatchableContext BC){
    }
 }