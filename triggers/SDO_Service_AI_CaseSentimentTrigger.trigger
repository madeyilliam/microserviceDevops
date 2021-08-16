trigger SDO_Service_AI_CaseSentimentTrigger on Case (after insert) {
    if(System.isBatch()) return;
    SDO_Service_AI_SvcCloudPredictionHelper.caseSubjectSentiment(trigger.new[0].id);
}