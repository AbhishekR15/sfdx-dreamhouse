@isTest
public class InsertBookingDetailTest {
    
    @TestSetup
    static void makeData(){
        Conference_Room__c confRoom = new Conference_Room__c(Name='Test Room',Location__c='Wakad Level 3',Capacity__c = 5);
        insert confRoom;
        
    }
    
    @isTest
    public static void testsaveBookingDetailRecord() {
        Conference_Room__c confRoom = [Select id from Conference_Room__c LIMIT 1];
        Booking_Detail__c bookingDetail = new Booking_Detail__c(Start_Time__c = System.now(),Name = 'Test Booking',Duration__c = '1.0',Conference_Room__c = confRoom.Id);
        InsertBookingDetail.saveBookingDetailRecord(bookingDetail);
    }
    
    @isTest
    public static void testFailsaveBookingDetailRecord() {
        Conference_Room__c confRoom = [Select id from Conference_Room__c LIMIT 1];
        Booking_Detail__c bookingDetail = new Booking_Detail__c(Name = 'Test Booking');
        try {
            InsertBookingDetail.saveBookingDetailRecord(bookingDetail);
        } catch(AuraHandledException ex) {
            
        }
        
    }

}