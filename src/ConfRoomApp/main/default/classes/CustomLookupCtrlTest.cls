@isTest
public class CustomLookupCtrlTest {

    @isTest
    public static void testFindRecords() {
        CustomLookupController.findRecords('Employee','User','FirstName');
    }
}