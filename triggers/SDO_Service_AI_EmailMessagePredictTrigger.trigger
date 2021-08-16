trigger SDO_Service_AI_EmailMessagePredictTrigger on EmailMessage (after insert) {
    if(!System.isBatch()) return;
    for(EmailMessage em: Trigger.New){
        if(em.ParentID != null && String.valueOf(em.ParentID).startsWith('500')){
            if(em.Incoming){
                SDO_Service_AI_SvcCloudPredictionHelper.emailMessageSubjectSentiment(em.Id);
            }
        }
    }
}