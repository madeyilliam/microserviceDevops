trigger SDO_FSL_SA_WOUpdate on ServiceAppointment (after insert) {
    if(!System.isBatch()) return;
    if(trigger.isAfter && trigger.isInsert){
        ServiceAppointment []newServiceAppointment = Trigger.new;
        SDO_FSL_blogic_SA_WorkOrderUpdate.UpdateWOAfterCreate(newServiceAppointment);
        }
     
}