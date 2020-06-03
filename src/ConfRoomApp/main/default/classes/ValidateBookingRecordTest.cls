@isTest
public class ValidateBookingRecordTest {
    @TestSetup static void initData(){
        Conference_Room__c confRec = new Conference_Room__c(Name = 'Test Conference Room', Active__c = true, Capacity__c = 2,
                                                             	Location__c ='Baner');
        insert confRec;
        
        Booking_Detail__c bookingRec = new Booking_Detail__c(Name = 'Test Booking Detail', Duration__c = '1.0', Conference_Room__c = confRec.Id,
                                                            Start_Time__c = System.now(), Status__c = 'Booked');
        insert bookingRec;
    }
    
    @isTest static void test_Constructor(){
        test.startTest();
        ValidateBookingRecord rec = new ValidateBookingRecord();
        test.stopTest();
    }
    
    @isTest static void test_validateBookingRecr(){
        Conference_Room__c conRec = [Select Id, Name From Conference_Room__c Limit 1];
        Booking_Detail__c bookingRec = [Select Id, Name, Start_Time__c, Duration__c From Booking_Detail__c Limit 1];
        test.startTest();
        ValidateBookingRecord.validateBookingRec(String.valueOf(conRec.Id), bookingRec.Start_Time__c, bookingRec.Duration__c);
        test.stopTest();
    }
    
    @isTest static void test_fetchConfRoom(){
        Conference_Room__c conRec = [Select Id, Name From Conference_Room__c Limit 1];
        test.startTest();
        ValidateBookingRecord.fetchConfRoom(String.valueOf(conRec.Id));
        test.stopTest();
    }
}