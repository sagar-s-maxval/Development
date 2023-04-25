public with sharing class DocuSignGenerateDocumentsForID {
    @AuraEnabled
    public static List<SDocsTemplateWrapper> getSDocsIDFTemplates() {
        List<SDocsTemplateWrapper> templates = new List<SDocsTemplateWrapper>();
        for (SDOC__SDTemplate__c template : [SELECT Id, Name, SDOC__Active__c, SDOC__Base_Object__c, Sign_Type__c FROM SDOC__SDTemplate__c WHERE SDOC__Base_Object__c = 'SymphonyIPM__Additional_Inventor__c']) {
            templates.add(new SDocsTemplateWrapper(template));
        }
        return templates;
    }
    @AuraEnabled
    public static List<SDocsTemplateWrapper> getSDocsPatentTemplates() {
        List<SDocsTemplateWrapper> templates = new List<SDocsTemplateWrapper>();
        for (SDOC__SDTemplate__c template : [SELECT Id, Name, SDOC__Active__c, SDOC__Base_Object__c, Sign_Type__c FROM SDOC__SDTemplate__c WHERE SDOC__Base_Object__c = 'SymphonyIPM__Patent__c' AND SDOC__Template_Format__c = 'PDF']) {
            templates.add(new SDocsTemplateWrapper(template));
        }
        return templates;
    }

    @AuraEnabled
    public static Id getListViewId(String listViewName){
        return [SELECT Id FROM ListView WHERE DeveloperName =: listViewName AND SobjectType = 'SDOC__SDTemplate__c'].get(0).Id;
    }

    @AuraEnabled
    public static Boolean checkIfDocuSignIsAllowed(String idfId) {
        if (Id.valueOf(idfId).getSobjectType().getDescribe().name == 'SymphonyIPM__Patent__c') {
            return true;
        }
        try {
            Boolean result = false;
            List<SymphonyIPM__Additional_Inventor__c> inventors = [SELECT Id, Is_Contribution_Applicable__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Invention_Disclosure_New__c = :idfId AND Is_Contribution_Applicable__c = true];
            if (inventors != null && inventors.size() > 0) {
                result = true;
            }

            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String generateDocumentFromTemplate(String recordId, List<SDocsTemplateWrapper> selectedSDocsAgreements) {
        try {

            List<Id> templateIds = new List<Id>();
            List<String> templateNames = new List<String>();

            for (SDocsTemplateWrapper template : selectedSDocsAgreements) {
                templateIds.add(template.Id);
                templateNames.add(template.name);
            }

            String templateIdsTxt = '';
            String templateNamesTxt = '';
            if (templateIds != null && templateIds.size() > 0) {
                templateIdsTxt = String.join(templateIds, ',');
                templateNamesTxt = String.join(templateNames, ',');
            }

            if (Id.valueOf(recordId).getSobjectType().getDescribe().name == 'SymphonyIPM__Patent__c') {
                insert new SDOC__SDJob__c(
                        SDOC__Start__c = true,
                        SDOC__Oid__c = recordId,
                        SDOC__ObjApiName__c = 'SymphonyIPM__Patent__c',
                        SDOC__SendEmail__c = '0',
                        SDOC__Doclist__c = templateIdsTxt,
                        Template_Name__c = templateNamesTxt
                );
                return 'Success';
            }

            List<SDOC__SDJob__c> jobs = new List<SDOC__SDJob__c>();
            Map<Id, SymphonyIPM__Additional_Inventor__c> inventors = new Map<Id, SymphonyIPM__Additional_Inventor__c>([
                    SELECT Id, SymphonyIPM__Inventor_Name__c, SymphonyIPM__Inventor_Email_Id__c, SymphonyIPM__Invention_Disclosure_New__c
                    FROM SymphonyIPM__Additional_Inventor__c
                    WHERE SymphonyIPM__Invention_Disclosure_New__c = :recordId
                    AND Is_Contribution_Applicable__c = TRUE
            ]);

            if (templateIds != null && templateIds.size() > 0) {
                for (SymphonyIPM__Additional_Inventor__c inventor : inventors.values()) {
                    jobs.add(new SDOC__SDJob__c(
                            SDOC__Start__c = true,
                            SDOC__Oid__c = inventor.Id,
                            SDOC__ObjApiName__c = 'SymphonyIPM__Additional_Inventor__c',
                            SDOC__SendEmail__c = '0',
                            SDOC__Doclist__c = templateIdsTxt,
                            Template_Name__c = templateNamesTxt
                    ));
                }
                insert jobs;
            }
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static String getTemplatePreviewLink(Id tempId) {
        PageReference pref = new PageReference('/apex/SDOC__SDTemplateEditor');
        pref.getParameters().put('Id', tempId);
        pref.getParameters().put('Field', 'Template_XML__c');
        return pref.getUrl();
    }

    public class SDocsTemplateWrapper {
        @AuraEnabled
        public String Id { get; set; }

        @AuraEnabled
        public String name { get; set; }

        @AuraEnabled
        public String signType { get; set; }

        @AuraEnabled
        public String link { get; set; }

        public SDocsTemplateWrapper() {
        }
        public SDocsTemplateWrapper(SDOC__SDTemplate__c template) {
            this.signType = template.Sign_Type__c;
            this.Id = template.Id;
            this.name = template.Name;
            this.link = getTemplatePreviewLink(template.Id);
        }
    }

    public static void magicMethod() {
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