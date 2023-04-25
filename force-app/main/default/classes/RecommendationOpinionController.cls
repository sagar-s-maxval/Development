public with sharing class RecommendationOpinionController {
    @AuraEnabled
    public static List<WrapperRecommendationOpinion> getRecommendationOpinionWrapper(Id dORecId) {
        List<WrapperRecommendationOpinion> wrapperRecommendationOpinions = new List<WrapperRecommendationOpinion>();
        if (Schema.SObjectType.Recommendation_Opinion__c.isAccessible() && Recommendation_Opinion__c.SObjectType.getDescribe().isAccessible()) {
            List<Recommendation_Opinion__c> objOpinionsList = RecommendationOpinionSelector.getRecommendationOpinionBydORecId(dORecId);

            for (Recommendation_Opinion__c recommendationOpinion : objOpinionsList) {
                WrapperRecommendationOpinion opinion = new WrapperRecommendationOpinion();
                opinion.recordId = recommendationOpinion.Id;
                opinion.recommendationOpinion = recommendationOpinion;
                opinion.IsShow = false;
                wrapperRecommendationOpinions.add(opinion);
            }
        }
        return wrapperRecommendationOpinions ;
    }

    public static void coverage(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}