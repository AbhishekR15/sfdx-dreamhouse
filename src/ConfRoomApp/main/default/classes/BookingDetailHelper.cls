public class BookingDetailHelper {
    
    //Send Communication to participants by booking Id
    //params: bookingId : get participants by querying booking ID
    //		  emailType : 'new','update' or 'delete'
    //		  				send a different email based on if a new booking is done,an existing booking is updated
    //		  				or if a booking is cancelled
    @auraEnabled		  	
    public static void sendCommunicationToParticipants(string bookingId,string emailType) {
        Map<string,Set<String>> bookingVsParticipantEmails = getParticipantEmailsByBookingIds(new Set<String>{bookingId});
        //move to a different class
        string emailTemplateDeveloperName = getEmailTemplateNameToSendByType(emailType);
        EmailTemplate emailTemplateForParticipants = getEmailTemplateByDeveloperName(emailTemplateDeveloperName);
        Messaging.SingleEmailMessage[] messages = getEmailMessagesByBookingsVsEmailList(bookingVsParticipantEmails,emailTemplateForParticipants.Id);
        
        try{
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        } catch(Exception ex) {
            throw new EmailSendException(ex.getMessage());
        }
    }
    
    private static Messaging.SingleEmailMessage[] getEmailMessagesByBookingsVsEmailList(Map<string,Set<string>> bookingVsParticipantEmails,string emailTemplateId) {
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        for(string booking : bookingVsParticipantEmails.keySet()) {
            Set<string> emailIds = bookingVsParticipantEmails.get(booking);
            messages.add(getEmailMessageInstance(emailIds,null,null,booking,emailTemplateId));
        }
        return messages;
    }
    //Maybe use enum?
    private static string getEmailTemplateNameToSendByType(string emailType) {
        return emailType.equalsIgnoreCase('new') ? 'Email_to_participant' : emailType.equalsIgnoreCase('edit') ? 'Booking_Edited_Email_to_participant' : 'Booking_Canceled';
    }
    
    private static Messaging.SingleEmailMessage getEmailMessageInstance(set<string> toAddresses,set<string> ccAddresses,set<string> bccAddresses,string whatId,string templateId) {
       Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(templateId, UserInfo.getUserId(), whatId);
        message.toaddresses = new List<String>(toAddresses);
        if(ccAddresses != null) {
            message.ccaddresses = new List<String>(ccAddresses);
        }
        if(bccaddresses != null) {
            message.bccaddresses = new List<String>(bccAddresses);
        }
        message.setSaveAsActivity(false);
        return message;
    }
    
    private static Map<string,Set<String>> getParticipantEmailsByBookingIds(Set<string> bookingIds) {
        List<Participant__c> participantList = [Select Id,Guest__r.Email,Booking_Detail__c FROM Participant__c WHERE Booking_Detail__c IN :bookingIds];
        Map<string,Set<string>> bookingVsParticipantEmails = new Map<string,Set<string>>();
        for(Participant__c attendee : participantList) {
            if(bookingVsParticipantEmails.containsKey(attendee.Booking_Detail__c)) {
                bookingVsParticipantEmails.get(attendee.Booking_Detail__c).add(attendee.Guest__r.Email);
            } else {
                bookingVsParticipantEmails.put(attendee.Booking_Detail__c,new Set<string>{attendee.Guest__r.Email});
            }
        }
        return bookingVsParticipantEmails;
    }
    
    private static EmailTemplate getEmailTemplateByDeveloperName(string developerName) {
        List<EmailTemplate> emailTemplateForParticipants = [Select Id from EmailTemplate Where DeveloperName =:developerName LIMIT 1];
        if(emailTemplateForParticipants == null || emailTemplateForParticipants.size() == 0) {
            throw new EmailSendException('No email template found for Email_to_participant');
        }
        return emailTemplateForParticipants[0];
    }
    
    class EmailSendException extends Exception{}
}