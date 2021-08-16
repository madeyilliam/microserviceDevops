//This trigger is designed to help eliminate the need for pre-chat forms.
//This trigger can be used in combination with Snippet Settings code to associate new LiveChatTranscript records with the correct Contact and Account records.
//This trigger also creates a new Case for each new LiveChatTranscript session record created and associates it with the correct Contact record.
trigger SDO_Service_EinsteinBotsInit_Chat on LiveChatTranscript (before insert) {
    if(System.isBatch()) return;
    for (LiveChatTranscript lct : Trigger.New){
        if(lct.ChatEndUserId__c != null) {
            List<User> thisUser = [SELECT Id, ContactId FROM User WHERE Id = :lct.ChatEndUserId__c];
            if(thisUser.size() > 0){
                lct.ContactId = thisUser[0].ContactId;
                List<Contact> thisContact = [SELECT Id, AccountId FROM Contact WHERE Id = :lct.ContactId];
                if(thisContact.size() > 0) 
                {
                    lct.AccountId = thisContact[0].AccountId;
                }   
            }

        }
        // Create a case every time as a catch-all - this prevents errors in the bot and matches how Messaging Sessions behave in the SDO.
        if(lct.CaseId == null) {
            Case newCase = new Case();
            newCase.subject = 'New Chat Case';
            newCase.Origin = 'Chat';
            newCase.contactId = lct.ContactId;
            newCase.accountId = lct.AccountId;
            try {
                insert newCase;
                lct.CaseId = newCase.Id;
            } catch(dmlexception e){
                system.debug('Case creation error: ' + e);
            }
        }  
    }
}