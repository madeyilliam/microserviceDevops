trigger SDO_FSL_AR_SAUpdate on AssignedResource (after insert, after update) {     
    if(System.isBatch()) return;
    if(trigger.isAfter && trigger.isUpdate){

        AssignedResource []newAssignedResource = Trigger.new;
           SDO_FSL_blogic_SA_AssignedResourceUpdate.UpdateAfterSchedule(newAssignedResource);
        }
}