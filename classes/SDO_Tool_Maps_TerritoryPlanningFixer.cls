public class SDO_Tool_Maps_TerritoryPlanningFixer {
    /* This will update the maps__Config__c field with the new ID from this org. This fixes Territory Planning */
    public static void fixJson(){
        List<maps__TPArea__c > objectList = [Select Id, SDO_Tool_User__c ,maps__Config__c FROM maps__TPArea__c WHERE SDO_Tool_User__c != ''];
            for(maps__TPArea__c obj : objectList )
            {
                String s1 = obj.maps__Config__c;
                String s2 =  '005' + s1.substringAfter('005');
                String s3 =  s2.substringBefore('"assignmentFields"');
                s3 = s3.replaceAll('",','');  
                s3 = s3.replaceAll(' ',''); 
                System.debug('OUTPUT IS:' + s3 +'here' );
                String newId = obj.SDO_Tool_User__c;
                String newval = s1.replaceAll(s3, newId);
                obj.maps__Config__c = newval;
            } 
        if(objectList.size() > 0){
            update objectList;
        }   
    }
}