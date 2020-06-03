public with sharing class ValidateBookingRecord {
    public ValidateBookingRecord() {

    }

     @AuraEnabled
     public static Boolean validateBookingRec(String confRoom, Datetime startTime, String duration){
         Boolean isOverlapFound = false;
         for(Booking_Detail__c rec :[ SELECT Id, Name, Conference_Room__c, Duration__c, Start_Time__c, 
                                            End_Time__C
                                        FROM Booking_Detail__c 
                                    	WHERE Conference_Room__c = :confRoom and
                                    Status__c = 'Booked']){
            
                if(confRoom == rec.Conference_Room__c  && (
                (startTime == rec.Start_Time__c) ||
                ( startTime > rec.Start_Time__c && startTime < rec.End_Time__c))){
                    isOverlapFound = true;
                    break;
                }
         }
         return isOverlapFound;
     }

    @AuraEnabled      
    public static Conference_Room__c fetchConfRoom( String recordId )  {   
          
        system.debug( 'Id is ' + recordId );  
        List < Conference_Room__c > listConfRooms = [ SELECT Id, Resources__c, Capacity__C FROM Conference_Room__c WHERE Id =: recordId LIMIT 1 ];  
          
        if( listConfRooms.size() > 0 )  
            return listConfRooms[0];  
        else  
            return null;  
          
    }  
}