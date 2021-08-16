/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class SDO_Community_LoginController {

    global SDO_Community_LoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Network.forwardToAuthPage(startUrl);
    }
    
    @IsTest(SeeAllData=true) 
    global static void testCommunitiesLoginController () {
        SDO_Community_LoginController controller = new SDO_Community_LoginController ();
        System.assertEquals(controller.forwardToAuthPage(),null);                           
    }    
}