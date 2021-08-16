/* 
@File Name : SkewSelectController.cls 
@Description : Controller for skewSelectComponent 
@Author : Yogesh Rao 
@Last Modified By : Yogesh Rao 
@Last Modified On : 28 June 2021 
@Modification Log : 
============================================================================== 
Ver        Date          Author       Modification 
============================================================================== 
1.0     28 June 2021    Yogesh Rao   Initial Version 
*/
public class SkewSelectController {

    /* 
     @description :   This method returns api name of all objects.
     @param :  none 
     @return :  List<String> - Object Api Names
    */
    @AuraEnabled(cacheable=true)   
    public static List<String> getObjectApiNames(){

        List<String> sObjApiList=new List<String>();
        Map<String, Schema.SObjectType> sObjDesc =Schema.getGlobalDescribe();
        List<Schema.DescribeSObjectResult> descSobjResList = Schema.describeSObjects(new List<String>(sObjDesc.keyset()));
        for(Schema.DescribeSObjectResult des:descSobjResList){
                if(des.isQueryable() &&  des.isAccessible() && des.isCreateable() && des.getChildRelationships().size()>0 
                   && des.getName()!='NetworkUserHistoryRecent'){
                    sObjApiList.add(des.getName());
                }
        }
        
        sObjApiList.sort();
        System.debug('~~~Size'+sObjApiList.size());
        return sObjApiList;
    }

    /* 
     @description :   This method creates skew metadata records for list of objects passed.
     @param :  List<String> - List of objects for which skew metadata records need to be created.  
     @return :  void
    */
    @AuraEnabled
    public static void createSkewMetadataRecords(List<String> masterObjLst){
        
        Map<String,Schema.DescribeSObjectResult> mapOfDescObj=new Map<String,Schema.DescribeSObjectResult>();
        List<Skew_Metadata__c> skewMetaList=new List<Skew_Metadata__c>();
        List<String> supportedObjects=new List<String>();
        Boolean isQueryValid=true;
        String query_template='SELECT Id FROM {0} LIMIT 1';
        String errorMessage='';
        
        if(!masterObjLst.isEmpty()){
            
            for(String obj:masterObjLst){
                String query=String.format(query_template, new List<Object>{obj});
                try{
                    Database.getQueryLocator(query);
                    supportedObjects.add(obj);
                }catch(Exception ex){
                    isQueryValid=false;
                    errorMessage+=obj+',';
                }
                
            }
        
            if(!isQueryValid){
                // log errorMessage
                
            }
        
            Map<String, Schema.SObjectType> sObjDesc =Schema.getGlobalDescribe();
            for(Schema.DescribeSObjectResult sobjDes:Schema.describeSObjects(new List<String>(sObjDesc.keyset()))){
                mapOfDescObj.put(sobjDes.getName(),sobjDes);
            }

        for(String masterObj:supportedObjects){
            for(Schema.ChildRelationship childObj:mapOfDescObj.get(masterObj).getChildRelationships()){
                if( ( childObj.getRelationshipName()!=null || 
                     (mapOfDescObj.get(masterObj).getName()=='User' && childObj.getRelationshipName()==null 
                      && String.valueOf(childObj.getField())=='OwnerId'))
                      && mapOfDescObj.get(masterObj).isQueryable() 
                      && mapOfDescObj.get(String.valueOf(childObj.getChildSObject())).isQueryable()
                      && String.valueOf(childObj.getChildSObject())!='NetworkUserHistoryRecent') {
                          
                          Skew_Metadata__c skewRec=new Skew_Metadata__c();
                          skewRec.Master__c=mapOfDescObj.get(masterObj).getName();
                          skewRec.Threshold__c=9500;//Set from List View
                          skewRec.Detail__c=String.valueOf(childObj.getChildSObject());   
                          skewRec.Relationship__c=String.valueOf(childObj.getField());
                          skewRec.Active__c=true;//Set from List View
                          skewRec.External_Id__c=mapOfDescObj.get(masterObj).getName()+'_'+String.valueOf(childObj.getChildSObject())+'_'+String.valueOf(childObj.getField());
                          skewMetaList.add(skewRec);
                      }
            }
        }
            upsert skewMetaList External_Id__c;
        }
    }

    
    /* 
     @description :   This method returns error message if any.
     @param :  List<String> - List Of Objects to enqueue
     @return :  String
    */
    public static String getErrorMessage(List<String> objsToEnqueue){
        
        Map<String,Integer> activeMetaRecords=new Map<String,Integer>();  
        Boolean isValid=true;
        String errorMessage='';
        
		for(AggregateResult ag:[SELECT Master__c,COUNT(Detail__c)  
                                FROM Skew_Metadata__c 
                                WHERE Master__c IN:objsToEnqueue AND Active__c=true 
                                GROUP BY Master__c]){
            activeMetaRecords.put(String.valueOf(ag.get('Master__c')),Integer.valueOf(ag.get('expr0')));
   		}
        
        for(String obj:objsToEnqueue){
            if(!activeMetaRecords.containsKey(obj)){
                errorMessage+=obj +' ,';
				isValid=false;
            }
        }
        
        if(!isValid){
            return 'Metadata Records not present for :'+errorMessage.removeEnd(',');
        }
        
        for(Skew_Batch_Queue__c  sb:[SELECT Id,Master_Object__c,Status__c  
                                     FROM Skew_Batch_Queue__c  
                                     WHERE Master_Object__c  IN:objsToEnqueue AND Status__c='Pending']){
             errorMessage+=sb.Master_Object__c+' ,';
             isValid=false;
           }
                                                     
             if(!isValid){
               return 'Jobs already in queue for objects '+errorMessage.removeEnd(',');
            }
        return errorMessage;
        
        }

    /* 
     @description :   This method inserts records in skew metadata table.
     @param :  Lis<String> - List of objects for which record needs to be created.
     @return :  void
    */
    @AuraEnabled
    public static void queueJobs(List<String> listOfObjs){
        
        List<Skew_Batch_Queue__c> listToEnqueue=new List<Skew_Batch_Queue__c>();
        
        if(listOfObjs.size()>0){
            if(getErrorMessage(listOfObjs).length()>0){
                throw new AuraException(getErrorMessage(listOfObjs));
            }else{
                for(String obj :listOfObjs){
                    listToEnqueue.add(new Skew_Batch_Queue__c(Master_Object__c=obj,Status__c='Pending'));
                }
            }
        }
        if(!listToEnqueue.isEmpty()){
          insert listToEnqueue;
          Database.executeBatch(new SkewBatch(listToEnqueue[0]),Integer.valueOf(Skew_Batch_Size__c.getAll().isEmpty() ? 200: Skew_Batch_Size__c.getAll().values()[0].Batch_Size__c));
        }
    }
}