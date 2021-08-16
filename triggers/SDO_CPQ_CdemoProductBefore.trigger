trigger SDO_CPQ_CdemoProductBefore on Product2 (before insert) {
    
    if(!Test.isRunningTest() && trigger.new.size()<50){
        SDO_CPQ_Billing_ProductUtility.BeforeTriggerProcessor(trigger.new);
    }
}