public with sharing class MultiSelectLookupController {
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value, List<String> selectedRecId) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        system.debug(fieldName+'-------------'+ObjectName+'---++----------'+value+'====='+selectedRecId);
        if(selectedRecId == null)
            selectedRecId = new List<String>();

        if(String.isNotEmpty(value)) {
            //String query = 'Select Id, username, '+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value.trim() + '%\' and ID NOT IN: selectedRecId';
            String query = 'Select Id, username, '+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value.trim() + '%\' and ID NOT IN: selectedRecId and Id != '+'\''+UserInfo.getUserId()+'\'';

            system.debug(query);
            for(sObject so : Database.Query(query)) {
                String fieldvalue = (String)so.get(fieldName);
				String userName = (String)so.get('username');
                sObjectResultList.add(new SObjectResult(fieldvalue, so.Id,userName));
            }
        }
        return sObjectResultList;
    }
    
    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
		@AuraEnabled
        public String userName;
        
        public SObJectResult(String recNameTemp, Id recIdTemp, String userNameTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
			userName = userNameTemp;
        }
        public SObJectResult() {
          
            
        }
    }
}