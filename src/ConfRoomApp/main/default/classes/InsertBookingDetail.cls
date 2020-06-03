public inherited sharing class InsertBookingDetail {
    @AuraEnabled
    public static void saveBookingDetailRecord(Booking_Detail__c obj){
        try{
            insert obj;
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}