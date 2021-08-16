/**
 * An apex page controller that exposes the site forgot password functionality
 */
public class SDO_Community_ForgotPasswordController {
    public String username {get; set;}   
       
    public SDO_Community_ForgotPasswordController() {}
    
    public PageReference forgotPassword() {
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.SDO_Community_forgotPassword;
        pr.setRedirect(true);
        
        if (success) {              
            return pr;
        }
        return null;
    }
    
     public static testMethod void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        SDO_Community_ForgotPasswordController controller = new SDO_Community_ForgotPasswordController();
        controller.username = 'test@salesforce.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
    }
}