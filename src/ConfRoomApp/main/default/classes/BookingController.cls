public with sharing class BookingController {
    @AuraEnabled(cacheable=true)
    public static List<Participant__c> getParticipants() {
        DateTime dt = System.now();
        System.debug('dt :: ' + dt);
		return [Select Id,
				Booking_Detail__r.Id,
				Booking_Detail__r.Name,
				Booking_Detail__r.Start_Time__c,
				Booking_Detail__r.End_Time__c,
				Role__c,
				Can_Cancel_Booking__c,
				Booking_Detail__r.Conference_Room__r.Name				
				From Participant__c 
				Where Guest__c =: UserInfo.getUserId()
				AND Booking_Detail__r.Status__c = 'Booked'
                AND Booking_Detail__r.Start_Time__c >=: dt
               	ORDER BY Booking_Detail__r.Start_Time__c ASC];
    }
}