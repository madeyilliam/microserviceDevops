global class SDO_B2B_strat_WarrantyRenewal {

    @InvocableMethod(Label='B2B Filter Warranty Recommendations' Description='Returns the warranty recommendation only when a warranty product is found for the asset')
    global static List<List<Recommendation>> doIt(List<DataContainer> inputData) {

        List<Recommendation> recommendations = inputData[0].recommendations;
        List<List<Recommendation>> outputs = new List<List<Recommendation>>();

        Id recordId = inputData[0].assetId;

        String warrantySku = 'xxx';

        List<Recommendation> returnedRecommendations = new List<Recommendation>();

        for (Recommendation r:recommendations){

            if(warrantySku != null){
                returnedRecommendations.add(r);
            }

        }

        outputs.add(returnedRecommendations);
        return outputs;

    }

    global class DataContainer {
        @InvocableVariable
        public string assetId;

        @InvocableVariable
        public List<Recommendation> recommendations;
    }

}