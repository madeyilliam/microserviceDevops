public class SDO_WorkforceEngagementDataController {

    @AuraEnabled
    public static Integer getRecordCounts(String object_name){
        String query = 'Select count() From ' + String.escapeSingleQuotes(object_name);
        Integer count = Database.countQuery(query);
        return count;
    }
    
    @AuraEnabled
    public static String loadData(){
        StaticResource dataCSV = [Select Body From StaticResource Where Name = 'SDO_WorkforceEngagementData'];
        return dataCSV.Body.toString();
    }
    
    @AuraEnabled
    public static Boolean createData(List<Sobject> data){
        try{
            Database.insertImmediate(data);
            return true;
        } catch(Exception err){
            System.debug(err);
            return false;
        }
    }
    
    @AuraEnabled
    public static Boolean deleteData(String object_name, Integer query_offset){
        try {
            String query = 'Select Id From ';
            query += String.escapeSingleQuotes(object_name) + ' ';
            query += 'Order By Id Desc Limit 10000 ';
            //query += 'Offset ' + query_offset;
            
            List<sObject> records_for_deletion = Database.query(query);
            Database.deleteImmediate(records_for_deletion);
            
            return true;
        } catch(Exception err){
            System.debug(err);
            return false;
        }     
    }
}