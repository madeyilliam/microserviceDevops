global class SDO_Community_LTForgotPasswordController {

    public SDO_Community_LTForgotPasswordController() {

    }

    @AuraEnabled
    public static String forgotPassowrd(String username, String checkEmailUrl) {
        try {
            Site.forgotPassword(username);
            ApexPages.PageReference checkEmailRef = new PageReference(checkEmailUrl);
            if(!Site.isValidUsername(username)) {
                return Label.Site.invalid_email;
            }
            aura.redirect(checkEmailRef);
            return null;
        }
        catch (Exception ex) {
            return ex.getMessage();
        }
    }

}