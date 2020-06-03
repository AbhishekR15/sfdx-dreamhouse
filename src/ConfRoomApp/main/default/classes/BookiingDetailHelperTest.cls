@isTest
public class BookiingDetailHelperTest {

    @testSetup
    public static void prepareData() {
        Conference_Room__c confRoom = new Conference_Room__c(Name='Test Room',Location__c='Wakad Level 3',Capacity__c = 5);
        insert confRoom;
        Booking_Detail__c bookingDetail = new Booking_Detail__c(Start_Time__c = System.now(),Name = 'Test Booking',Duration__c = '1.0',Conference_Room__c = confRoom.Id);
        insert bookingDetail;
        Participant__c meetingParticipant = new Participant__c(Guest__c = UserInfo.getUserId(),Booking_Detail__c = bookingDetail.Id);
        insert meetingParticipant;
    }
    
    @isTest
    public static void testEmailForNewBooking() {
        Booking_Detail__c booking = [Select Id from Booking_Detail__c LIMIT 1];
        BookingDetailHelper.sendCommunicationToParticipants(booking.Id,'new');
    }
}