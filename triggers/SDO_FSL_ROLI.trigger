trigger SDO_FSL_ROLI on ReturnOrderLineItem (after insert) {
    if(System.isBatch()) return;
    if(trigger.isAfter && trigger.isInsert){
        ReturnOrderLineItem[] newReturnOrderLineItem = Trigger.new;
            SDO_FSL_blogic_ROLI_CreateTransfer.InsertAfter(newReturnOrderLineItem);
        }
     
    
}