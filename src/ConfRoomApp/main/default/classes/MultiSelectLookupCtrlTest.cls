@isTest
public class MultiSelectLookupCtrlTest {

    @isTest
    public static void searchTest() {
        MultiSelectLookupController.getResults('User','Name','Employee',new List<String>());
    }
}