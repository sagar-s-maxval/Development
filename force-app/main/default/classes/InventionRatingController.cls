public with sharing class InventionRatingController {

    @AuraEnabled
    public static List<List<HeaderWrapper>> getReviews(Id inventionDisclosureId) {
        List<SymphonyIPM__IDF_Review__c> reviews = [
                SELECT Id, SymphonyIPM__Review_Comments__c,
                        SymphonyIPM__Reviewed_By__c,
                        Business_value_of_the_invention__c,
                        Does_the_invention_achieve_results__c,
                        Does_the_invention_have_applicability__c,
                        Does_the_invention_solve_problem__c,
                        Does_the_invention_represent_technology__c,
                        How_difficult_will_it_be_to_design__c,
                        How_difficult_will_it_be_to_detect_use__c,
                        How_novel_is_the_invention__c,
                        Is_it_likely_competitors_will_practice__c,
                        Likelihood_that_invention_implementable__c,
                        Reviewer__c,
                        CreatedById,
                        User_Link__c,
                        Recommendations__c,
                        SymphonyIPM__Base_Invention_Disclosure__r.Name,
                        SymphonyIPM__Base_Invention_Disclosure__r.SymphonyIPM__Title__c
                FROM SymphonyIPM__IDF_Review__c
                WHERE SymphonyIPM__Base_Invention_Disclosure__c = :inventionDisclosureId
        ];

        List<Map<String, String>> resultList = new List<Map<String, String>>();
        List<List<HeaderWrapper>> newResultList = new List<List<HeaderWrapper>>();
        List<String> fieldsList = new List<String>{
                'SymphonyIPM__Reviewed_By__c', 'How_novel_is_the_invention__c', 'Does_the_invention_solve_problem__c', 'Does_the_invention_achieve_results__c', 'Does_the_invention_represent_technology__c', 'Is_it_likely_competitors_will_practice__c', 'Does_the_invention_have_applicability__c', 'Business_value_of_the_invention__c', 'How_difficult_will_it_be_to_design__c', 'How_difficult_will_it_be_to_detect_use__c', 'Likelihood_that_invention_implementable__c', 'Recommendations__c', 'SymphonyIPM__Review_Comments__c', 'User_Link__c'
        };
        List<String> headers = new List<String>{'Reviewer','Originality','Problem Resolution','Favorable Results','Competitive Advantage',
                'Competitors Usage','Applicability','Business Value','Invention Design Complexity','Invention Complexity','Commercial Use','Recommendations','Comments'};
        List<String> helptexts = new List<String>{
                '',
                'How novel is the invention in comparison to the known prior art?',
                'Does the invention solve a long-standing problem in its technical field?',
                'Does the invention achieve unexpected favorable results?',
                'Does the invention represent a technology differentiator that gives us a competitive advantage in the market?',
                'Is it likely that one or more of our competitors will practice the invention?',
                'Does the invention have significant applicability outside of our core business?',
                'Based on the foregoing, what is the business value of the invention to us?',
                'How difficult will it be for others to design around the invention if it is patented?',
                'How difficult will it be to detect use of the invention by others without extensive reverse-engineering?',
                'What is the likelihood that invention can be implemented as a product, in view of technical challenges?',
                '','',''
        };
        for (Integer i = 0; i < 13; i++) {
            Map<String, String> formedRow = new Map<String, String>();
            List<HeaderWrapper> newFormedRow = new List<HeaderWrapper>();
            formedRow.put('header', headers[i]);
            HeaderWrapper hw = new HeaderWrapper();
            hw.label=headers[i];
            hw.helptext = helptexts.get(i);
            newFormedRow.add(hw);
            //first row to be {link: 'link', value: 'value'}
            for (Integer j = 0; j < reviews.size(); j++) {
                HeaderWrapper localHW = new HeaderWrapper();
                localHW.label = (String)reviews.get(j).get(fieldsList.get(i));
                if (i == 0) {
                    localHW.link = (String)reviews.get(j).get('User_Link__c');
                }
                newFormedRow.add(localHW);

            }
            resultList.add(formedRow);
            newResultList.add(newFormedRow);
        }

        return newResultList;
    }

    @AuraEnabled
    public static List<ComboBoxOptionWrapper> getRecommendationOptions() {
        List<ComboBoxOptionWrapper> options = new List<ComboBoxOptionWrapper>();
        Schema.DescribeFieldResult fieldResult = SymphonyIPM__IDF_Review__c.Recommendations__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new ComboBoxOptionWrapper(f.getLabel(), f.getValue()));
        }
        return options;
    }
     @AuraEnabled
    public static Boolean checkuseraccess(String idfid) {
        boolean hasaccess=false;
        list<SymphonyIPM__Inventor__c> person=[select id,SymphonyIPM__User__r.profile.name from SymphonyIPM__Inventor__c where SymphonyIPM__User__c=:userinfo.getUserId() limit 1];
        if(person.size()>0){
        if(person[0].SymphonyIPM__User__r.profile.name!='In-house Counsel'){
          hasaccess=true;    
        }else{
        for(Invention_Disclosure_Role__c   invrole: [select id,Person__c,Role__c from Invention_Disclosure_Role__c   where  Invention_Disclosure__c =:idfid]){
           if(invrole.Person__c==person[0].id)
            hasaccess=true;   
        }}}
       return hasaccess; 
    }
    @AuraEnabled
    public static Boolean getStatusAllowance(String status) {
        return ![SELECT Id FROM Ratings_Allowed_Statuses__mdt WHERE Label = :status].isEmpty();
    }

    @AuraEnabled
    public static SymphonyIPM__IDF_Review__c getReview(Id inventionDisclosureId, Id userId) {
        try {
            return [
                    SELECT Id, SymphonyIPM__Review_Comments__c,
                            SymphonyIPM__Reviewed_By__c,
                            Business_value_of_the_invention__c,
                            Does_the_invention_achieve_results__c,
                            Does_the_invention_have_applicability__c,
                            Does_the_invention_solve_problem__c,
                            Does_the_invention_represent_technology__c,
                            How_difficult_will_it_be_to_design__c,
                            How_difficult_will_it_be_to_detect_use__c,
                            How_novel_is_the_invention__c,
                            Is_it_likely_competitors_will_practice__c,
                            Likelihood_that_invention_implementable__c,
                            Recommendations__c
                    FROM SymphonyIPM__IDF_Review__c
                    WHERE SymphonyIPM__Base_Invention_Disclosure__c = :inventionDisclosureId AND CreatedById = :userId
                    LIMIT 1
            ];
        } catch (Exception e) {
            return null;
        }

    }

    @AuraEnabled
    public static SymphonyIPM__Invention_Disclosure_New__c getDocketNumber(Id recordId) {
        return [
                SELECT Id, Name
                FROM SymphonyIPM__Invention_Disclosure_New__c
                WHERE Id = :recordId
        ];
    }

    public class HeaderWrapper {
        @AuraEnabled
        public String label;

        @AuraEnabled
        public String link;

        @AuraEnabled
        public String helptext;
    }

}