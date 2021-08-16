/* 
    @File Name : SkewBatch.cls 
    @Description :  
    @Author : Yogesh Rao 
    @Last Modified By : Yogesh Rao 
    @Last Modified On : 25 June 2021 
    @Modification Log : 
    ============================================================================== 
    Ver        Date          Author       Modification 
    ============================================================================== 
    1.0     25 June 2021    Yogesh Rao   Initial Version 
    */

	public class SkewBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    public List<Skew_Metadata__c> skewMetadataList;
    public List<Skew_Metadata__c> pendingSkewMetadataList;
    public Skew_Batch_Queue__c currentObj;
    public Integer totalSoql;
    
    /* 
    @description :   Constructor for instantiation of SkewBatch object for chained jobs.
    @param :  String - Api name of object
    @param :  List<Skew_Metadata__c> - List of pending records from previous chained job.
    @return :  NA
    */
    public SkewBatch(Skew_Batch_Queue__c currentObj,List<Skew_Metadata__c> pending) {
        
        this.pendingSkewMetadataList=new List<Skew_Metadata__c>();
        this.skewMetadataList=new List<Skew_Metadata__c>();
        this.currentObj=currentObj;
        this.skewMetadataList=pending;
        this.totalSoql=200;
        
        if(!skewMetadataList.isEmpty() && (skewMetadataList.size() >totalSoql)){
            splitMetadataList();
        }
        
    }
    
    /* 
    @description :  Constructor for instantiation of SkewBatch object.
    @param :  String - Api name of object
    @return :  NA
    */
    public SkewBatch(Skew_Batch_Queue__c currentObj) {
        
        this.pendingSkewMetadataList=new List<Skew_Metadata__c>();
        this.skewMetadataList=new List<Skew_Metadata__c>();
        this.currentObj=currentObj;
        this.totalSoql=200;
        
        if(skewMetadataList.isEmpty()){
            skewMetadataList=getSkewMetadataList();
        }
        
        if(!skewMetadataList.isEmpty() && (skewMetadataList.size() >totalSoql)){
            splitMetadataList();
        }
    }
    
    /* 
    @description :   This method splits Skew_Metadata__c list based on soql limit.
    @param :  none
    @return :  void
    @example : If soql limit is 2 then for ['Account','Contact','Case','Opportunity']
    *skewMetadataList=['Account','Contact'] and pendingSkewMetadataList=['Case','Opportunity']
    */
    
    public void splitMetadataList(){
        
        for(Integer i=totalSoql;i<skewMetadataList.size();i++){
            pendingSkewMetadataList.add(skewMetadataList.get(i));
        }
        
        for(Skew_Metadata__c sm:pendingSkewMetadataList){
            if(skewMetadataList.contains(sm)) skewMetadataList.remove(skewMetadataList.indexOf(sm));
        }
        
    }
    
    
    public Database.QueryLocator  start(Database.BatchableContext bc) {
        String query='SELECT Id FROM ' + currentObj.Master_Object__c;
        return Database.getQueryLocator(query);
    }

        
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        String query_template='SELECT count(Id),{1} FROM {0} WHERE {1} IN:recIds GROUP BY {1} HAVING count(Id) > {2}';
        List<Skew_Result__c> skewResultList=new List<Skew_Result__c>();
        Set<Id> recIds=new Set<Id>();
        
        for(sObject sobj:scope){
            recIds.add(sobj.Id);
        }
        
        for(Skew_Metadata__c sm:skewMetadataList){
           
            String query=String.format(query_template, new List<Object>{sm.Detail__c,
                                                                        sm.Relationship__c,
                 														sm.Threshold__c});
            System.debug('Query>>'+query);
            
            try {
                List<AggregateResult> result=Database.query(query);
                for(AggregateResult agr:result){
                    skewResultList.add(new Skew_Result__c(
                        Record__c=String.valueOf(agr.get(sm.Relationship__c)),
                        Detail__c=sm.Detail__c,
                        Master_Object__c=sm.Master__c ,
                        Relationship__c=sm.Relationship__c,
                        Count__c=Integer.valueOf(agr.get('expr0')),
                        External_Id__c=String.valueOf(agr.get(sm.Relationship__c))+'_'+sm.Detail__c+'_'+sm.Relationship__c));
                }
            }catch(Exception ex){
                System.debug('handle exception'+ex);
            }
        }
        upsert skewResultList External_Id__c;
        
    }    
    
    public void finish(Database.BatchableContext bc){
        
       AsyncApexJob batchResult = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems
      								FROM AsyncApexJob 
                                    WHERE Id = :bc.getJobId()]; 
        
       Skew_Batch_Queue__c skewBatchRec=[SELECT Status__c,Number_Of_Errors__c,Total_Job_Items__c,Job_Items_Processed__c
                                         FROM Skew_Batch_Queue__c
                                         WHERE Id=:currentObj.Id]; 
        
        if(!pendingSkewMetadataList.isEmpty()){
            
            skewBatchRec.Status__c='In Progress';
			skewBatchRec.Number_Of_Errors__c= skewBatchRec.Number_Of_Errors__c >=0 ? skewBatchRec.Number_Of_Errors__c + batchResult.NumberOfErrors : batchResult.NumberOfErrors;
            skewBatchRec.Total_Job_Items__c=skewBatchRec.Total_Job_Items__c >=0 ? skewBatchRec.Total_Job_Items__c+batchResult.TotalJobItems : batchResult.TotalJobItems;
            skewBatchRec.Job_Items_Processed__c=skewBatchRec.Job_Items_Processed__c >=0 ? skewBatchRec.Job_Items_Processed__c+batchResult.JobItemsProcessed : batchResult.JobItemsProcessed;
            update skewBatchRec; 
            Database.executeBatch(new SkewBatch(currentObj,pendingSkewMetadataList),Integer.valueOf(Skew_Batch_Size__c.getAll().isEmpty() ? 200: Skew_Batch_Size__c.getAll().values()[0].Batch_Size__c));
            
        }else{
            
            skewBatchRec.Number_Of_Errors__c= skewBatchRec.Number_Of_Errors__c >=0 ? skewBatchRec.Number_Of_Errors__c + batchResult.NumberOfErrors : batchResult.NumberOfErrors;
            skewBatchRec.Total_Job_Items__c=skewBatchRec.Total_Job_Items__c >=0 ? skewBatchRec.Total_Job_Items__c+batchResult.TotalJobItems : batchResult.TotalJobItems;
            skewBatchRec.Job_Items_Processed__c=skewBatchRec.Job_Items_Processed__c >=0 ? skewBatchRec.Job_Items_Processed__c+batchResult.JobItemsProcessed : batchResult.JobItemsProcessed;
            skewBatchRec.Status__c='Completed';
            update skewBatchRec;
            
            List<Skew_Batch_Queue__c> nextObj=[SELECT Id,Master_Object__c FROM Skew_Batch_Queue__c WHERE Status__c='Pending' LIMIT 1];
            if(nextObj !=null && nextObj.size()>0) Database.executeBatch(new SkewBatch(nextObj[0]),Integer.valueOf(Skew_Batch_Size__c.getAll().isEmpty() ? 200: Skew_Batch_Size__c.getAll().values()[0].Batch_Size__c));
            
        }
    }    
    
    /* 
    @description :   This method returns List of active Skew_Metadata__c records.
    @param :  none
    @return :  List<Skew_Metadata__c> - List of active skew metadata records
    */
    public  List<Skew_Metadata__c> getSkewMetadataList(){
        return [SELECT Master__c,Threshold__c,Active__c,Detail__c,Relationship__c 
                FROM Skew_Metadata__c 
                WHERE Master__c =:currentObj.Master_Object__c AND Active__c=true];
    }
}