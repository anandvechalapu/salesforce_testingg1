trigger SurveyQuestionTrigger on Survey_Question__c (before insert, before update) {
  List<Id> surveyIds = new List<Id>();
  for (Survey_Question__c sq : Trigger.new) {
    surveyIds.add(sq.Survey__c);
  } 
  Map<Id, Integer> surveyQuestionCounts = new Map<Id, Integer>();
  for (AggregateResult ar : [SELECT Survey__c, COUNT(Id) cnt FROM Survey_Question__c WHERE Survey__c IN :surveyIds GROUP BY Survey__c]) {
    surveyQuestionCounts.put((Id)ar.get('Survey__c'), (Integer)ar.get('cnt'));
  }
  for (Survey_Question__c sq : Trigger.new) {
    if (surveyQuestionCounts.get(sq.Survey__c) >= 20) {
      sq.addError('Survey can only have up to 20 questions.');
    }
  } 
}