public with sharing class SDocTriggerHandler {
    public static void handle(TriggerOperation operationType, List<SDOC__SDoc__c> newRecords) {

        switch on operationType {
            when BEFORE_INSERT {
                selectSignType(newRecords);
            }
        }
    }

    private static void selectSignType(List<SDOC__SDoc__c> sDocs) {

        // this is bad but sDocs.size() should be small
        for (SDOC__SDoc__c sDoc : sDocs) {
            if(sDoc.SDOC__SDTemplate__c == null){
                continue;
            }
            SDOC__SDTemplate__c sdTemplate = SDocTemplateSelector.getTemplateById(sDoc.SDOC__SDTemplate__c);

            if (!(sDoc.SDOC__ObjectType__c == 'SymphonyIPM__Patent__c' || sDoc.SDOC__ObjectType__c == 'SymphonyIPM__Additional_Inventor__c')) {
                continue;
            }

            String signType = sdTemplate?.Sign_Type__c;

            System.debug('signType ' + signType);

            relateSDocToPatentOrInvDisc(sDoc);

            System.debug('sDoc ' + sDoc);

            switch on signType {
                when 'Function Only' {

                    Set<Id> ids = typeFunctionOnly(sDoc);
                    sDoc.RelatedIds__c = setToStr(ids);

                    break;
                }
                when 'All Inventors' {

                    Set<Id> ids = typeAllInventors(sDoc);
                    sDoc.RelatedIds__c = setToStr(ids);

                    break;
                }
                when 'All Inventors and Function' {

                    Set<Id> ids = typeFunctionOnly(sDoc);
                    ids.addAll(typeAllInventors(sDoc));
                    sDoc.RelatedIds__c = setToStr(ids);

                    break;
                }
                when else {
                    break;
                }
            }
        }
    }

    private static Set<Id> typeFunctionOnly(SDOC__SDoc__c sDoc) {
        Set<Id> ids = new Set<Id>();

        if (sDoc.SDOC__ObjectType__c == 'SymphonyIPM__Additional_Inventor__c') {

            SymphonyIPM__Additional_Inventor__c addInv = AdditionalInventorSelector.getAdditionalInventorsById(sDoc.SDOC__ObjectID18__c);

            List<SymphonyIPM__Hierarchy_Role__c> roles = HierarchyRoleSelector.getRolesByHierarchyId(addInv.SymphonyIPM__Invention_Disclosure_New__r.SymphonyIPM__Hierarchy__c);

            ids.add(addInv.SymphonyIPM__Inventor__c);

            for (SymphonyIPM__Hierarchy_Role__c role : roles) {
                ids.add(role.Person__c);
            }

        } else {
            SymphonyIPM__Patent__c patent = PatentSelector.getPatentById(sDoc.SDOC__ObjectID18__c);

            List<SymphonyIPM__Hierarchy_Role__c> roles = HierarchyRoleSelector.getRolesByHierarchyId(patent.SymphonyIPM__Hierarchy__c);

            for (SymphonyIPM__Hierarchy_Role__c role : roles) {
                ids.add(role.Person__c);
            }

        }

        return ids;
    }

    private static Set<Id> typeAllInventors(SDOC__SDoc__c sDoc) {
        Set<Id> ids = new Set<Id>();

        if (sDoc.SDOC__ObjectType__c == 'SymphonyIPM__Additional_Inventor__c') {

            SymphonyIPM__Additional_Inventor__c addInv = AdditionalInventorSelector.getAdditionalInventorsById(sDoc.SDOC__ObjectID18__c);

            List<SymphonyIPM__Additional_Inventor__c> allAddInvs = AdditionalInventorSelector.getAdditionalInventorsByInvDiscId(
                    addInv.SymphonyIPM__Invention_Disclosure_New__c
            );


            for (SymphonyIPM__Additional_Inventor__c inv : allAddInvs) {
                ids.add(inv.SymphonyIPM__Inventor__c);
            }
        } else {
            for (SymphonyIPM__Asset_Inventor_v1__c inv : AssetInventorSelector.getAssetInventorsByPatentId(sDoc.SDOC__ObjectID18__c)) {
                ids.add(inv.SymphonyIPM__Inventor__c);
            }
        }

        return ids;
    }

    private static String setToStr(Set<Id> ids) {
        return String.join(new List<Id>(ids), ',').removeEnd(',');
    }

    private static void relateSDocToPatentOrInvDisc(SDOC__SDoc__c sDoc) {
        if (sDoc.SDOC__ObjectType__c == 'SymphonyIPM__Additional_Inventor__c') {
            SymphonyIPM__Additional_Inventor__c addInv = AdditionalInventorSelector.getAdditionalInventorsById(sDoc.SDOC__ObjectID18__c);
            sDoc.Related_Patent_Or_ID__c = addInv.SymphonyIPM__Invention_Disclosure_New__c;
        } else {
            sDoc.Related_Patent_Or_ID__c = sDoc.SDOC__ObjectID18__c;
        }
    }
}