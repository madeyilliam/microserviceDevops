@isTest(SeeAllData=true)
public class SDO_Community_MyTopicsTest {
	
    public static testmethod  void doStuff(){
    	SDO_Community_MyTopics.getTopicsWithFollowers('audiophiles');
        SDO_Community_MyTopics.hasFollowers('audiophiles');
    }
}