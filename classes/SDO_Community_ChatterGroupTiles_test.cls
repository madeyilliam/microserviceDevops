@isTest
public class SDO_Community_ChatterGroupTiles_test {
    
    @isTest
    static void Test_getGroups()
    {
        // Insert a chatter group
        CollaborationGroup cg=New CollaborationGroup(Name='Test CG',CollaborationType='Private',description='featured');
        insert cg;
        
        test.starttest();
        List <CollaborationGroup> retourPonlyNotFiltered=SDO_Community_ChatterGroupTiles.getGroups('',true);
        List <CollaborationGroup> retourAllNotFiltered=SDO_Community_ChatterGroupTiles.getGroups('',false);
        List <CollaborationGroup> retourAllFiltered=SDO_Community_ChatterGroupTiles.getGroups('featured',false);
        List <CollaborationGroup> retourPonlyFiltered=SDO_Community_ChatterGroupTiles.getGroups('featured',true);
        test.stoptest();
        System.AssertEquals(retourPonlyNotFiltered.isEmpty(),true);
        System.AssertEquals(retourAllNotFiltered[0].Name,'Test CG');
        System.AssertEquals(retourAllFiltered[0].Name,'Test CG');
         System.AssertEquals(retourPonlyFiltered.isEmpty(),true);
        
    }

}