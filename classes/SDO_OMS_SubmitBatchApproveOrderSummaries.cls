global class SDO_OMS_SubmitBatchApproveOrderSummaries implements Schedulable{
      global void execute(SchedulableContext sc){
        SDO_OMS_BatchApproveOrderSummaries approveOS = new SDO_OMS_BatchApproveOrderSummaries();
        ID batchprocessid = Database.executeBatch(approveOS, 200);
    }
}