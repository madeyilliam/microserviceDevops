trigger SDO_CPQ_CdemoProductAfter on Product2 (after insert, after update) {
    if(System.isBatch()) return;
    if(trigger.isAfter && trigger.new.size()<50){
        SDO_CPQ_Billing_ProductUtility.AfterTriggerProcessor(Trigger.new, Trigger.isInsert);
    }
}