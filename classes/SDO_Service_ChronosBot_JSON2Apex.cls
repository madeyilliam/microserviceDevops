public with sharing class SDO_Service_ChronosBot_JSON2Apex {

    public List<TimeSlots> timeSlots;

    public class TimeSlots {
        public DateTime endTime;
        public DateTime startTime;
        public String territoryId;
    }
    
    public static SDO_Service_ChronosBot_JSON2Apex parse(String json) {
        return (SDO_Service_ChronosBot_JSON2Apex) System.JSON.deserialize(json, SDO_Service_ChronosBot_JSON2Apex.class);
    }
}