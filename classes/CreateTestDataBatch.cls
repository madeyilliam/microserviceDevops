public without sharing class CreateTestDataBatch implements Database.Batchable<sObject>,Database.Stateful{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator('SELECT Id,name FROM Account Order BY createddate LIMIT 500');
    }
    
    public void execute(Database.BatchableContext bc,List<Account> scope){
        List<Contact> conList=new List<Contact>();
        for(Account acc:scope){
            for(Integer i=1;i<=10000;i++){
            conList.add(new Contact(LastName=acc.Name+'-con-'+i,accountId=acc.Id));
            }
        }
        insert conList;
    }
    
    public void finish(Database.BatchableContext bc){
        
    }

}