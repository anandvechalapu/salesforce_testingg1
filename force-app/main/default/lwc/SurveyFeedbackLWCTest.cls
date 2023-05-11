// Test Class
@isTest
private class TestSurveyFeedback {
    static testMethod void testGetQuestions() {
        // Create Test Data
        List<Question__c> lstQuestions = TestDataUtils.createQuestions(3);

        Test.startTest();

        // Mock getQuestions
        Test.setMock(HttpCalloutMock.class, new MockGetQuestions(lstQuestions));

        // Create Component
        ComponentConstructor cc = new ComponentConstructor();
        Component cmp = cc.createComponent();
        cmp.set('v.isLoading', true);

        // Invoke the method
        cmp.getSurveyQuestions();

        System.assertEquals(false, cmp.get('v.isLoading'));
        System.assertEquals(3, cmp.get('v.surveyQuestions').size());

        Test.stopTest();
    }

    static testMethod void testSaveSurvey() {
        // Create Test Data
        List<Question__c> lstQuestions = TestDataUtils.createQuestions(3);
        List<Survey_Response__c> lstSurveyResponses = TestDataUtils.createSurveyResponses(3);

        Test.startTest();

        // Mock saveSurvey
        Test.setMock(HttpCalloutMock.class, new MockSaveSurvey());

        // Create Component
        ComponentConstructor cc = new ComponentConstructor();
        Component cmp = cc.createComponent();
        cmp.set('v.surveyResponses', lstSurveyResponses);

        // Invoke the method
        cmp.handleSubmit();

        System.assertEquals(3, Database.countQuery('SELECT Id FROM Survey_Response__c'));

        Test.stopTest();
    }
}