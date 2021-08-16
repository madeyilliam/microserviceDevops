@isTest
private with sharing class SDO_Service_ChronosBot_GetEventDetTst
{
    static testMethod void validateEventTime() 
    {
        List<Event> e1=new List<Event>();
        DateTime d1=System.now();
        Event ev=new Event();
        ev.StartDateTime=d1;
        ev.EndDateTime=d1+1;
        e1.add(ev);
        List<SDO_Service_ChronosBot_GetEventDetails.ChatResponses> chatResponses = SDO_Service_ChronosBot_GetEventDetails.getTSlots(e1);
        System.assertEquals(d1,chatResponses[0].startTime);
    }
}