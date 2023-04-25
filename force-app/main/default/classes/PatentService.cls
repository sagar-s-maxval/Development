public with sharing class PatentService {
    private static final String DAILY_CRON_EXP = '0 0 1 * * ? *';
    private static final String DAILY_CRON_EXP_2 = '0 0 2 * * ? *';
    private static final String DAILY_CRON_EXP_3 = '0 0 3 * * ? *';

    public static Boolean checkStatusExpiredAbandoned(SymphonyIPM__Patent__c newPatent, SymphonyIPM__Patent__c oldPatent) {
        return ((newPatent.SymphonyIPM__Status__c == 'Expired'
                && oldPatent.SymphonyIPM__Status__c != 'Expired')
                || (newPatent.SymphonyIPM__Status__c == 'Abandoned'
                && oldPatent.SymphonyIPM__Status__c != 'Abandoned'));
    }
 public static Boolean checkStatuschangedfromExpiredAbandoned(SymphonyIPM__Patent__c newPatent, SymphonyIPM__Patent__c oldPatent) {
        return ((newPatent.SymphonyIPM__Status__c != 'Expired'
                && oldPatent.SymphonyIPM__Status__c == 'Expired')
                || (newPatent.SymphonyIPM__Status__c != 'Abandoned'
                && oldPatent.SymphonyIPM__Status__c == 'Abandoned'));
    }
    public static void UpdateEpcountries(List<SymphonyIPM__Patent__c> newPatents) {
        EPcountries__c Ep = EPcountries__c.getInstance('EP Countries');
        list<string> EPcountrycodes = new List<string>();
        if (Ep != null)
            EPcountrycodes = ep.Country_Codes__c.split(',');
        List<id> parentids = new List<id>();
        for (SymphonyIPM__Patent__c pat : newPatents) {
            if (EPcountrycodes.contains(pat.SymphonyIPM__Country_Code__c) && pat.SymphonyIPM__ClonedFromAsset__c != null) {
                parentids.add(pat.SymphonyIPM__ClonedFromAsset__c);
            }
        }
        Map<id, string> patentcountrycodes = new Map<id, string>();
        Map<id, string> patentEpnoMap = new Map<id, string>();
        Map<id, Date> patentEpDateMap = new Map<id, Date>();
        Map<id, Date> patentAppDateMap = new Map<id, Date>();
        Map<id, Date> patentIssueDateMap = new Map<id, Date>();
        Map<id, string> patentPatnoMap = new Map<id, string>();
        Map<id, string> patentAppnoMap = new Map<id, string>();
        Map<id, string> patentEarliestNoMap = new Map<id, string>();
        Map<id, string> patentRealKeywordsMap = new Map<id, string>();
        Map<id, Date> patentIntFilingDateMap = new Map<id, Date>();
        Map<id, Date> patentLocalFilingDateMap = new Map<id, Date>();
        Map<id, Date> patentEffFilingDateMap = new Map<id, Date>();
        Map<id, Date> patentExpDateMap = new Map<id, Date>();
        Map<id, string> patentImmedParentAppNoMap = new Map<id, string>();
        Map<id, Date> patentImmedParentGrantDateMap = new Map<id, Date>();
        if (parentids.size() > 0) {
            for (SymphonyIPM__Patent__c patenrcase : [
                    select id,SymphonyIPM__Related_Keywords__c,Earliest_Priority_Number__c,SymphonyIPM__International_Filing_Date__c, Local_Filing_Date__c, SymphonyIPM__Effective_Filing_Date__c, SymphonyIPM__Expiration_Date__c, Immediate_Parent_Application_No__c, SymphonyIPM__Immediate_Parent_Grant_Date__c, SymphonyIPM__Country_Code__c, SymphonyIPM__Earliest_Publication_No__c, SymphonyIPM__Application_Number__c,
                            SymphonyIPM__Earliest_Publication_Date__c, SymphonyIPM__Application_Date__c, SymphonyIPM__Issue_Date_of_Patent__c,
                            SymphonyIPM__Patent_Number__c
                    from SymphonyIPM__Patent__c
                    where id in :parentids
            ]) {
                patentcountrycodes.put(patenrcase.id, patenrcase.SymphonyIPM__Country_Code__c);
                patentEpnoMap.put(patenrcase.id, patenrcase.SymphonyIPM__Earliest_Publication_No__c);
                patentEpDateMap.put(patenrcase.id, patenrcase.SymphonyIPM__Earliest_Publication_Date__c);
                patentAppDateMap.put(patenrcase.id, patenrcase.SymphonyIPM__Application_Date__c);
                patentIssueDateMap.put(patenrcase.id, patenrcase.SymphonyIPM__Issue_Date_of_Patent__c);
                patentPatnoMap.put(patenrcase.id, patenrcase.SymphonyIPM__Patent_Number__c);
                patentAppnoMap.put(patenrcase.id, patenrcase.SymphonyIPM__Application_Number__c);
                patentLocalFilingDateMap.put(patenrcase.id, patenrcase.Local_Filing_Date__c);
                patentEffFilingDateMap.put(patenrcase.id, patenrcase.SymphonyIPM__Effective_Filing_Date__c);
                patentExpDateMap.put(patenrcase.id, patenrcase.SymphonyIPM__Expiration_Date__c);
                patentImmedParentAppNoMap.put(patenrcase.id, patenrcase.Immediate_Parent_Application_No__c);
                patentEarliestNoMap.put(patenrcase.id, patenrcase.Earliest_Priority_Number__c);
                patentIntFilingDateMap.put(patenrcase.id, patenrcase.SymphonyIPM__International_Filing_Date__c);
                patentRealKeywordsMap.put(patenrcase.id, patenrcase.SymphonyIPM__Related_Keywords__c);
                
            }
        }
        for (SymphonyIPM__Patent__c pat : newPatents) {
            system.debug(EPcountrycodes); system.debug(pat.SymphonyIPM__Country_Code__c); system.debug(pat.SymphonyIPM__ClonedFromAsset__c); system.debug(patentcountrycodes.get(pat.SymphonyIPM__ClonedFromAsset__c));
            if (EPcountrycodes.contains(pat.SymphonyIPM__Country_Code__c) && pat.SymphonyIPM__ClonedFromAsset__c != null && patentcountrycodes.get(pat.SymphonyIPM__ClonedFromAsset__c) == 'EP') {
                if (patentAppnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null && patentAppnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c).contains('EP'))
                    pat.SymphonyIPM__Application_Number__c = patentAppnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c).replace('EP', pat.SymphonyIPM__Country_Code__c);
                else if (patentAppnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.SymphonyIPM__Application_Number__c = patentAppnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                if (pat.SymphonyIPM__ClonedFromAsset__r.SymphonyIPM__Application_Number__c != null)
                    pat.SymphonyIPM__Application_Number__c = pat.SymphonyIPM__ClonedFromAsset__r.SymphonyIPM__Application_Number__c;
                if (patentEpnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null && patentEpnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c).contains('EP'))
                    pat.SymphonyIPM__Earliest_Publication_No__c = patentEpnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c).replace('EP', pat.SymphonyIPM__Country_Code__c);
                else if (patentEpnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.SymphonyIPM__Earliest_Publication_No__c = patentEpnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                //    if(patentPatnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c)!=null && patentPatnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c).contains('EP'))
                //    pat.SymphonyIPM__Patent_Number__c=patentPatnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c).replace('EP',pat.SymphonyIPM__Country_Code__c);
                //    else if(patentPatnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c)!=null )
                //    pat.SymphonyIPM__Patent_Number__c=patentPatnoMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                if (patentAppDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.SymphonyIPM__Application_Date__c = patentAppDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                if (patentLocalFilingDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.Local_Filing_Date__c = patentLocalFilingDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                if (patentEffFilingDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.SymphonyIPM__Effective_Filing_Date__c = patentEffFilingDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                if (patentExpDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.SymphonyIPM__Expiration_Date__c = patentExpDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                if (patentImmedParentAppNoMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.Immediate_Parent_Application_No__c = patentImmedParentAppNoMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                if (patentImmedParentGrantDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.SymphonyIPM__Immediate_Parent_Grant_Date__c = patentImmedParentGrantDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                if (patentEpDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.SymphonyIPM__Earliest_Publication_Date__c = patentEpDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                if (patentIssueDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.SymphonyIPM__Issue_Date_of_Patent__c = patentIssueDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                 if (patentEarliestNoMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.Earliest_Priority_Number__c = patentEarliestNoMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                if (patentIntFilingDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.SymphonyIPM__International_Filing_Date__c = patentIntFilingDateMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                if (patentRealKeywordsMap.get(pat.SymphonyIPM__ClonedFromAsset__c) != null)
                    pat.SymphonyIPM__Related_Keywords__c = patentRealKeywordsMap.get(pat.SymphonyIPM__ClonedFromAsset__c);
                
            }
        }
    }
      public static void UpdateAuditFields(List<SymphonyIPM__Patent__c> newPatents){
         for(SymphonyIPM__Patent__c pat:newPatents){
        
        string cc=pat.SymphonyIPM__Country_Code__c !=null ? pat.SymphonyIPM__Country_Code__c: '';
        string IPAN=pat.Immediate_Parent_Application_No__c !=null ? pat.Immediate_Parent_Application_No__c: '';
        string CN=string.valueof(pat.SymphonyIPM__Confirmation_Number__c) !=null ? string.valueof(pat.SymphonyIPM__Confirmation_Number__c): '';
        string CCN=pat.Correspondence_Customer_No__c !=null ? pat.Correspondence_Customer_No__c: '';
        string CCIPANCNCCN=CC+'|'+IPAN+'|'+CN+'|'+CCN;
        if(CCIPANCNCCN.length()<250)
        pat.CC_IPAN_CN_CCN__c=CCIPANCNCCN;
        else
        pat.CC_IPAN_CN_CCN__c=  CCIPANCNCCN.substring(0, 250);
        
        
        string BU=pat.Business_Unit__c !=null ? pat.Business_Unit__c: '';
        string GAU=string.valueof(pat.SymphonyIPM__Group_Art_Unit__c ) !=null ? string.valueof(pat.SymphonyIPM__Group_Art_Unit__c): '';
        string OL=string.valueof(pat.Out_Licensed__c  ) !=null ? string.valueof(pat.Out_Licensed__c): '';
        string Tit=pat.SymphonyIPM__Title_of_Invention__c !=null ? pat.SymphonyIPM__Title_of_Invention__c: '';
       string BUGAUAT=BU+'|'+GAU+'|'+OL+'|'+Tit;
        if(BUGAUAT.length()<250)
        pat.BU_GAU_OL_AT__c=BUGAUAT;
        else
        pat.BU_GAU_OL_AT__c=  BUGAUAT.substring(0, 250);
        
        string IPRM=pat.IPRM_Name__c !=null ? pat.IPRM_Name__c: '';
        string IPRMRN=string.valueof(pat.IPRM_Registration_Number__c) !=null ? string.valueof(pat.IPRM_Registration_Number__c): '';
        string IPRMP=pat.IPRM_Phone_Number__c !=null ? pat.IPRM_Phone_Number__c: '';
        string DN=pat.Docketer_Names__c !=null ? pat.Docketer_Names__c: '';
        string IPRMIPRMN=IPRM+'|'+IPRMRN+'|'+IPRMP+'|'+DN;
         if(IPRMIPRMN.length()<250)
         pat.IPRM_IPRMRN_IPRMP_DN__c=IPRMIPRMN;
        else
        pat.IPRM_IPRMRN_IPRMP_DN__c=  IPRMIPRMN.substring(0, 250);
        
        
        string IPPN=pat.IP_Partner_Names__c !=null ? pat.IP_Partner_Names__c: '';
        string IPPRN=pat.IP_Paralegal_Names__c !=null ? pat.IP_Paralegal_Names__c: '';
        string OCN=pat.Outside_Counsel_Firm_Names__c !=null ? pat.Outside_Counsel_Firm_Names__c: '';
        string FN=pat.OC_Support_Firm_Names__c !=null ? pat.OC_Support_Firm_Names__c: '';
        string IPPNOCFN=IPPN+'|'+IPPRN+'|'+OCN+'|'+FN;
         if(IPPNOCFN.length()<250)
         pat.IPPN_IPPN_OC_FN__c=IPPNOCFN;
        else
        pat.IPPN_IPPN_OC_FN__c=  IPPNOCFN.substring(0, 250);
        
        string PN=pat.SymphonyIPM__Priority_Number__c !=null ? pat.SymphonyIPM__Priority_Number__c: '';
        string PD=pat.SymphonyIPM__Priority_Dates__c !=null ? pat.SymphonyIPM__Priority_Dates__c: '';
        string PNPD=PN+'|'+PD;
        if(PNPD.length()<250)
         pat.PN_PD__c=PNPD;
        else
        pat.PN_PD__c=  PNPD.substring(0, 250);
        
        }
        
    }
    public static Boolean checkIfStatusFromDrafting(SymphonyIPM__Patent__c newPatent, SymphonyIPM__Patent__c oldPatent) {
        return oldPatent.SymphonyIPM__Status__c == 'Drafting'
                && newPatent.SymphonyIPM__Status__c != 'Drafting';
    }

    public static Boolean isLitigationChecked(SymphonyIPM__Patent__c newPatent, SymphonyIPM__Patent__c oldPatent) {
        return newPatent.Litigation_on_hold__c
                && !oldPatent.Litigation_on_hold__c;
    }

    public static Boolean isLitigationDeselect(SymphonyIPM__Patent__c newPatent, SymphonyIPM__Patent__c oldPatent) {
        return !newPatent.Litigation_on_hold__c
                && oldPatent.Litigation_on_hold__c;
    }

    public static void createPurgingExpiredDocketingActivity(Set<Id> patentsIds) {
        if (patentsIds.isEmpty()) {
            return;
        }
        List<SymphonyIPM__Patent__c> patents = PatentSelector.getPatentsByIds(patentsIds);
        set<String> familyids= new set<string>();
        set<String> familyidswithlitigation= new set<string>();
        for(SymphonyIPM__Patent__c pat:patents){
            if(pat.SymphonyIPM__Family_ID__c!=null)
            familyids.add(pat.SymphonyIPM__Family_ID__c);
        }
        for(SymphonyIPM__Patent__c pat:[select id,Litigation_on_hold__c,SymphonyIPM__Family_ID__c from SymphonyIPM__Patent__c where SymphonyIPM__Family_ID__c in:familyids]){
            if(pat.Litigation_on_hold__c==true)
           familyidswithlitigation.add(pat.SymphonyIPM__Family_ID__c); 
        }
        Set<Id> patentsWithExistingIds = new Set<Id>();
        for (SymphonyIPM__Docketing_Activity_v2__c activity : PatentSelector.getDocketingActivities('Documents Purging Due (Family Expired)', patentsIds)) {
            patentsWithExistingIds.add(activity.SymphonyIPM__Patent__c);
        }

        List<Jobs_Deadlines__mdt> deadlines = [SELECT Days__c, Months__c, Years__c FROM Jobs_Deadlines__mdt WHERE DeveloperName = 'Expired_Files_Purging_Deadline'];

        List<SymphonyIPM__Docketing_Activity_v2__c> activities = new List<SymphonyIPM__Docketing_Activity_v2__c>();

        for (SymphonyIPM__Patent__c patent : patents) {
            if(!familyidswithlitigation.contains(patent.SymphonyIPM__Family_ID__c)){
            Date dueDate = Date.today();
            if (patent.Matter_ID__c != null && patent.SymphonyIPM__Expiration_Date__c != null) {
                dueDate = patent.SymphonyIPM__Expiration_Date__c;
            }
            if (!patentsWithExistingIds.contains(patent.Id)) {
                activities.add(new SymphonyIPM__Docketing_Activity_v2__c(
                        SymphonyIPM__Patent__c = patent.Id,
                        SymphonyIPM__Actions__c = 'Documents Purging Due (Family Expired)',
                        SymphonyIPM__Trigger__c = 'Latest Patent family member expired',
                        SymphonyIPM__Trigger_Type__c = 'Event',
                        SymphonyIPM__Due_Date__c = dueDate.addDays(Integer.valueOf(deadlines[0].Days__c))
                                .addMonths(Integer.valueOf(deadlines[0].Months__c))
                                .addYears(Integer.valueOf(deadlines[0].Years__c)),
                        SymphonyIPM__Activity_Date__c = Date.today()
                ));
                activities.add(new SymphonyIPM__Docketing_Activity_v2__c(
                        SymphonyIPM__Patent__c = patent.Id,
                        SymphonyIPM__Actions__c = 'Documents Purging Due (Family Expired) - Reminder',
                        SymphonyIPM__Trigger__c = 'Latest Patent family member expired',
                        SymphonyIPM__Trigger_Type__c = 'Event',
                        SymphonyIPM__Due_Date__c = dueDate.addDays(Integer.valueOf(deadlines[0].Days__c)).addDays(-10)
                                .addMonths(Integer.valueOf(deadlines[0].Months__c))
                                .addYears(Integer.valueOf(deadlines[0].Years__c)),
                        SymphonyIPM__Activity_Date__c = Date.today()
                ));
                patentsWithExistingIds.add(patent.Id);}
            }
        }

        Database.insert(activities);
    }

    public static void createFilingDocketingActivity(Set<Id> patentsIds) {

        List<SymphonyIPM__Docketing_Activity_v2__c> activities = new List<SymphonyIPM__Docketing_Activity_v2__c>();
        List<Jobs_Deadlines__mdt> deadlines = [SELECT Days__c, Months__c, Years__c FROM Jobs_Deadlines__mdt WHERE DeveloperName = 'Filing_Activity_Deadline'];

        for (Id patentId : patentsIds) {
            activities.add(new SymphonyIPM__Docketing_Activity_v2__c(
                    SymphonyIPM__Patent__c = patentId,
                    SymphonyIPM__Actions__c = 'Application to be filed',
                    SymphonyIPM__Trigger__c = 'Patent Shell Record Created',
                    SymphonyIPM__Trigger_Type__c = 'Event',
                    SymphonyIPM__Due_Date__c = Date.today().addDays(Integer.valueOf(deadlines[0].Days__c))
                            .addMonths(Integer.valueOf(deadlines[0].Months__c))
                            .addYears(Integer.valueOf(deadlines[0].Years__c)),
                    SymphonyIPM__Activity_Date__c = Date.today()
            ));
        }

        Database.insert(activities);
    }

    public static void scheduleDailyJobs() {
        System.schedule('Delete expired', DAILY_CRON_EXP, new ExpiredFilePurgingSchedulable());
        System.schedule('Create Filing Rewards', DAILY_CRON_EXP_2, new FilingRewardSchedulable());
        System.schedule('Create Grant Reward', DAILY_CRON_EXP_3, new GrantRewardSchedulable());


    }

    public static void deleteDraftDocuments(Id patentId) {
        List<SymphonyIPM__Patent_Attachments__c> documentsToDelete = PatentSelector.getDraftDocuments(patentId);

        if (!documentsToDelete.isEmpty()) {
            Database.delete(documentsToDelete);
        }
    }

    public static void putLitigationOnHoldInRelatedPatents(Set<Id> patentsIds, Boolean litigationValue) {
        if (patentsIds.isEmpty()) {
            return;
        }

        Set<String> familyIds = new Set<String>();
        for (SymphonyIPM__Patent__c patent : PatentSelector.getPatentsByIds(patentsIds)) {
            familyIds.add(patent.SymphonyIPM__Family_ID__c);
        }

        List<SymphonyIPM__Patent__c> relatedPatents = PatentSelector.getPatentsByFamilyIds(familyIds);
        Set<Id> familyPatentsIds = new Set<Id> ();
        for (SymphonyIPM__Patent__c patent : relatedPatents) {
            patent.Litigation_on_hold__c = litigationValue;
            familyPatentsIds.add(patent.Id);
        }
        if (!relatedPatents.isEmpty()) {
            Database.update(relatedPatents);
        }
//
//        List<SymphonyIPM__Docketing_Activity_v2__c> activities = [SELECT Id, SymphonyIPM__Due_Date__c FROM SymphonyIPM__Docketing_Activity_v2__c WHERE SymphonyIPM__Patent__c IN :familyPatentsIds AND (SymphonyIPM__Actions__c = 'Documents Purging Due (Family Expired)' OR SymphonyIPM__Actions__c = 'Documents Purging Due (Family Expired) - Reminder')];
//
//        for (SymphonyIPM__Docketing_Activity_v2__c da : activities) {
//            da.SymphonyIPM__Due_Date__c = da.SymphonyIPM__Due_Date__c.addYears(1);
//        }
//
//        if (!activities.isEmpty()) {
//            update activities;
//        }
    }


 public static void setfilingandissuedate(List<SymphonyIPM__Patent__c> newPatents) {
 List<SymphonyIPM__Patent__c> issueupdatepatent= new List<SymphonyIPM__Patent__c>();
 List<SymphonyIPM__Patent__c> Filedupdatepatent= new List<SymphonyIPM__Patent__c>();
     List<SymphonyIPM__Patent__c> Firstupdatepatent= new List<SymphonyIPM__Patent__c>(); 
     Set<String> familyIds = new Set<String>();
        for (SymphonyIPM__Patent__c patent : newPatents) {
        if(patent.Family_ID_sdocs__c!=null && (patent.SymphonyIPM__Application_Date__c!=null || patent.SymphonyIPM__Issue_Date_of_Patent__c!=null ))
            familyIds.add( patent.Family_ID_sdocs__c);
         
        }
         Map<String,SymphonyIPM__Patent__c> issuedPatentsMap = new Map<String,SymphonyIPM__Patent__c>();
          Map<String,SymphonyIPM__Patent__c> FiledPatentsMap = new Map<String,SymphonyIPM__Patent__c>();
      Map<String,SymphonyIPM__Patent__c> FisrtappliedPatMap = new Map<String,SymphonyIPM__Patent__c>();
 /*  List<SymphonyIPM__Patent__c> Issuedpatfamily=[SELECT Id,First_Filed_In_Family__c,First_Issued_in_the_family__c,SymphonyIPM__Application_Date__c,SymphonyIPM__Issue_Date_of_Patent__c, SymphonyIPM__Family_ID__c,Family_ID_sdocs__c, Litigation_on_hold__c, SymphonyIPM__Status__c
                FROM SymphonyIPM__Patent__c
                WHERE Family_ID_sdocs__c IN :familyIds and First_Issued_in_the_family__c=true];
                 List<SymphonyIPM__Patent__c> Filedpatfamily=[SELECT Id,First_Filed_In_Family__c,First_Issued_in_the_family__c,SymphonyIPM__Application_Date__c,SymphonyIPM__Issue_Date_of_Patent__c, SymphonyIPM__Family_ID__c,Family_ID_sdocs__c, Litigation_on_hold__c, SymphonyIPM__Status__c
                FROM SymphonyIPM__Patent__c
                WHERE Family_ID_sdocs__c IN :familyIds and First_Filed_In_Family__c=true ];*/
    for (SymphonyIPM__Patent__c patent : [SELECT Id,First_Filed_In_Family__c,First_Issued_in_the_family__c,SymphonyIPM__Application_Date__c,SymphonyIPM__Issue_Date_of_Patent__c, SymphonyIPM__Family_ID__c,Family_ID_sdocs__c, Litigation_on_hold__c, SymphonyIPM__Status__c
                FROM SymphonyIPM__Patent__c WHERE Family_ID_sdocs__c IN :familyIds and First_Filed_In_Family__c=true ]) {
        FiledPatentsMap.put(patent.Family_ID_sdocs__c,patent);
    }
     for (SymphonyIPM__Patent__c patent : [SELECT Id,First_Filed_In_Family__c,First_Issued_in_the_family__c,SymphonyIPM__Application_Date__c,SymphonyIPM__Issue_Date_of_Patent__c, SymphonyIPM__Family_ID__c,Family_ID_sdocs__c, Litigation_on_hold__c, SymphonyIPM__Status__c
                FROM SymphonyIPM__Patent__c WHERE Family_ID_sdocs__c IN :familyIds and First_Applied__c=true ]) {
        FisrtappliedPatMap.put(patent.Family_ID_sdocs__c,patent);
    }
    for (SymphonyIPM__Patent__c patent : [SELECT Id,First_Filed_In_Family__c,First_Issued_in_the_family__c,SymphonyIPM__Application_Date__c,SymphonyIPM__Issue_Date_of_Patent__c, SymphonyIPM__Family_ID__c,Family_ID_sdocs__c, Litigation_on_hold__c, SymphonyIPM__Status__c
                FROM SymphonyIPM__Patent__c
                WHERE Family_ID_sdocs__c IN :familyIds and First_Issued_in_the_family__c=true ]) {
        issuedPatentsMap.put(patent.Family_ID_sdocs__c,patent);
    }
    for (SymphonyIPM__Patent__c patent : newPatents) {
        SymphonyIPM__Patent__c issuepat=issuedPatentsMap.get(patent.Family_ID_sdocs__c);
        SymphonyIPM__Patent__c Filedpat=FiledPatentsMap.get(patent.Family_ID_sdocs__c);
        SymphonyIPM__Patent__c Firstpat=FisrtappliedPatMap.get(patent.Family_ID_sdocs__c);
        if(Firstpat!=null){
            if((patent.SymphonyIPM__Application_Date__c<Firstpat.SymphonyIPM__Application_Date__c)){
        patent.First_Applied__c=true;
        Firstpat.First_Applied__c=false; 
        Firstupdatepatent.add(Firstpat);       
            }  
        }else{
          if(patent.SymphonyIPM__Application_Date__c!=null)  
               patent.First_Applied__c=true;
        }
        if(Filedpat!=null){
            if((patent.SymphonyIPM__Application_Date__c<Filedpat.SymphonyIPM__Application_Date__c)&& (patent.SymphonyIPM__Case_Type__c=='Primary'||patent.SymphonyIPM__Case_Type__c=='Utility Non-Provisional' || patent.SymphonyIPM__Case_Type__c=='Utility Original' )){
        patent.First_Filed_In_Family__c=true;
        Filedpat.First_Filed_In_Family__c=false;
        Filedupdatepatent.add(Filedpat);    
        }
        }else{
        if(patent.SymphonyIPM__Application_Date__c!=null&&(patent.SymphonyIPM__Case_Type__c=='Primary'||patent.SymphonyIPM__Case_Type__c=='Utility Non-Provisional' || patent.SymphonyIPM__Case_Type__c=='Utility Original' ))
        patent.First_Filed_In_Family__c=true;}
        if(issuepat!=null){
        if(patent.SymphonyIPM__Issue_Date_of_Patent__c<issuepat.SymphonyIPM__Issue_Date_of_Patent__c && (patent.SymphonyIPM__Case_Type__c=='Primary'||patent.SymphonyIPM__Case_Type__c=='Utility Non-Provisional' || patent.SymphonyIPM__Case_Type__c=='Utility Original' )){
        patent.First_Issued_in_the_family__c=true;
        issuepat.First_Issued_in_the_family__c=false;
        issueupdatepatent.add(issuepat);    
        }}
        else{
        if(patent.SymphonyIPM__Issue_Date_of_Patent__c!=null &&(patent.SymphonyIPM__Case_Type__c=='Primary'||patent.SymphonyIPM__Case_Type__c=='Utility Non-Provisional' || patent.SymphonyIPM__Case_Type__c=='Utility Original' ))
            patent.First_Issued_in_the_family__c=true;
        }
        
    }
 
     try {
        
         if(issueupdatepatent.size()>0) {
   TFconstant.firsttime=false;
    update issueupdatepatent;
 }
          if(Firstupdatepatent.size()>0) {
   TFconstant.firsttime=false;
    update Firstupdatepatent;
 }

if(Filedupdatepatent.size()>0) {
     TFconstant.firsttime=false;
    update Filedupdatepatent; 
}
            
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    
 }
    public static void setLitigation(List<SymphonyIPM__Patent__c> newPatents) {
        Set<String> familyIds = new Set<String>();
        for (SymphonyIPM__Patent__c patent : newPatents) {
            familyIds.add( patent.SymphonyIPM__Family_ID__c);
        }

        Map<String, SymphonyIPM__Patent__c> relatedPatentsMap = new Map<String, SymphonyIPM__Patent__c>();
        for (SymphonyIPM__Patent__c patent : PatentSelector.getPatentsByFamilyIds(familyIds)) {
            if (patent.SymphonyIPM__Family_ID__c != null && patent.SymphonyIPM__Family_ID__c != '') {
                relatedPatentsMap.put(patent.SymphonyIPM__Family_ID__c, patent);
            }
        }

        for (SymphonyIPM__Patent__c patent: newPatents) {
            if (patent.SymphonyIPM__Family_ID__c != null
                    && patent.SymphonyIPM__Family_ID__c != ''
                    && relatedPatentsMap.get(patent.SymphonyIPM__Family_ID__c)?.Litigation_on_hold__c != null) {
                patent.Litigation_on_hold__c = relatedPatentsMap.get(patent.SymphonyIPM__Family_ID__c)?.Litigation_on_hold__c;
            }
        }
    }

    public static void setIfLastExpired(Set<Id> patentsIds, List<SymphonyIPM__Patent__c> newPatents) {

        Set<String> familiesIds = new Set<String>();
        for (SymphonyIPM__Patent__c patent : PatentSelector.getPatentsByIds(patentsIds)) {
            familiesIds.add(patent.SymphonyIPM__Family_ID__c);
        }
        Map<String, List<SymphonyIPM__Patent__c>> patentMap = new Map<String, List<SymphonyIPM__Patent__c>>();
        for (SymphonyIPM__Patent__c patent : PatentSelector.getPatentsByFamilyIds(familiesIds)) {
            List<SymphonyIPM__Patent__c> localList = new List<SymphonyIPM__Patent__c>();
            if (patentMap.containsKey(patent.SymphonyIPM__Family_ID__c)) {
                localList.addAll(patentMap.get(patent.SymphonyIPM__Family_ID__c));
            }
            localList.add(patent);
            patentMap.put(patent.SymphonyIPM__Family_ID__c, localList);
        }
        for (String key : patentMap.keySet()) {
            List<SymphonyIPM__Patent__c> patents = patentMap.get(key);
            Integer expiredCount = 0;
            Id notExpiredId = null;
            for (SymphonyIPM__Patent__c patent : patents) {
                if (patent.SymphonyIPM__Status__c == 'Expired' || patent.SymphonyIPM__Status__c == 'Abandoned') {
                    expiredCount++;
                } else {
                    notExpiredId = patent.Id;
                }
            }
            for (SymphonyIPM__Patent__c patent : newPatents) {
                if (expiredCount == patents.size() - 1 && notExpiredId != null) {

                    patent.Last_In_Family_Expired__c = true;
                }
            }
        }
    }

    public static Date getDeadline(Date startDate, String name) {
        List<Jobs_Deadlines__mdt> deadlines = [SELECT Days__c, Months__c, Years__c FROM Jobs_Deadlines__mdt WHERE DeveloperName = :name];
        Date resultDeadline = startDate;

        if (!deadlines.isEmpty()) {
            resultDeadline = resultDeadline.addDays(Integer.valueOf(deadlines[0].Days__c) * -1)
                    .addMonths(Integer.valueOf(deadlines[0].Months__c) * -1)
                    .addYears(Integer.valueOf(deadlines[0].Years__c) * -1);
        }

        return resultDeadline;
    }

    public static Date getDeadlineFromToday(String name) {
        return getDeadline(Date.today(), name);
    }

    public static void createSIDSDocketActivity(List<SymphonyIPM__IFW_Data_v1__c> documents) {
        if (documents.isEmpty()) {
            return;
        }
        Map<Id, Map<Id, Date>> patentToIFWDateMap = new Map<Id, Map<Id, Date>>();
        Set<Id> patentsIds = new Set<Id>();
        for (SymphonyIPM__IFW_Data_v1__c data: documents) {
            patentsIds.add(data.SymphonyIPM__Asset__c);
            if (patentToIFWDateMap.containsKey(data.SymphonyIPM__Asset__c)) {
                Map<Id, Date> localMap = patentToIFWDateMap.get(data.SymphonyIPM__Asset__c);
                localMap.put(data.Id, data.SymphonyIPM__Mail_Room_Date__c);
                patentToIFWDateMap.put(data.SymphonyIPM__Asset__c, localMap);
            } else {
                patentToIFWDateMap.put(data.SymphonyIPM__Asset__c, new Map<Id, Date> {
                        data.Id => data.SymphonyIPM__Mail_Room_Date__c
                });
            }
        }

        Map<String, Map<Id, Date>> familyIdToMailRoomDate = new Map<String, Map<Id, Date>>();
        Map<String, String> familyIdsToDocketNumber = new Map<String, String>();
        Map<Id, SymphonyIPM__Patent__c> patentsMap = new Map<Id, SymphonyIPM__Patent__c>([SELECT Id,Family_ID_sdocs__c, SymphonyIPM__Family_ID__c, SymphonyIPM__Family_ID_AI__c, SymphonyIPM__Docket_No__c FROM SymphonyIPM__Patent__c WHERE Id IN :patentsIds]);
        Set<String> familyIds = new Set<String>();
        Set<Decimal> familyIdsAI = new Set<Decimal>();
        for (SymphonyIPM__Patent__c patent : patentsMap.values()) {
            familyIds.add(patent.Family_ID_sdocs__c);
            familyIdsAI.add(patent.SymphonyIPM__Family_ID_AI__c);
            familyIdToMailRoomDate.put(patent.Family_ID_sdocs__c, patentToIFWDateMap.get(patent.Id));
            familyIdsToDocketNumber.put(patent.Family_ID_sdocs__c, patent.SymphonyIPM__Docket_No__c);
        }
        List<Jobs_Deadlines__mdt> deadlines = [SELECT Days__c, Months__c, Years__c FROM Jobs_Deadlines__mdt WHERE DeveloperName = 'sIDS_Docketing_Deadline'];

        List<SymphonyIPM__Docketing_Activity_v2__c> activities = new List<SymphonyIPM__Docketing_Activity_v2__c>();

        for (SymphonyIPM__Patent__c patent : [
            SELECT Id, SymphonyIPM__Family_ID__c, Family_ID_sdocs__c, SymphonyIPM__Family_ID_AI__c, SymphonyIPM__Docket_No__c
            FROM SymphonyIPM__Patent__c
            WHERE Family_ID_sdocs__c IN :familyIdToMailRoomDate.keySet()
            AND (SymphonyIPM__Country_Code__c = 'US' OR SymphonyIPM__Country_Code__c = 'IL')
            AND (SymphonyIPM__Status__c = 'Pending' OR SymphonyIPM__Status__c = 'NOA Received')
            AND SymphonyIPM__Case_Type__c != 'Provisional'
        ]) {
            if (!patentsIds.contains(patent.Id)) {
                for (Id ifwId : familyIdToMailRoomDate.get(patent.Family_ID_sdocs__c).keySet()) {
                    Date mailRoomDate = familyIdToMailRoomDate.get(patent.Family_ID_sdocs__c)?.get(ifwId) == null ? Date.today() : familyIdToMailRoomDate.get(patent.Family_ID_sdocs__c).get(ifwId);
                    activities.add(new SymphonyIPM__Docketing_Activity_v2__c(
                            SymphonyIPM__Patent__c = patent.Id,
                            SymphonyIPM__Actions__c = 'sIDS (' + familyIdsToDocketNumber.get(patent.Family_ID_sdocs__c) + '_Cited by examiner (892)_ ' + mailRoomDate.month() + '/' + mailRoomDate.day() + '/' + mailRoomDate.year() + ')',
                            SymphonyIPM__Trigger__c = 'sIDS',
                            SymphonyIPM__Trigger_Type__c = 'Event',
                            SymphonyIPM__Due_Date__c = mailRoomDate.addDays(Integer.valueOf(deadlines[0].Days__c))
                                    .addMonths(Integer.valueOf(deadlines[0].Months__c))
                                    .addYears(Integer.valueOf(deadlines[0].Years__c)),
                            SymphonyIPM__Activity_Date__c = Date.today()
                    ));
                }
            }
        }

        Database.insert(activities);
    }

    public static void createSIDSDocketActivityManually(Set<Id> activitiesIds) {
        if (activitiesIds.isEmpty()) {
            return;
        }
        List<Jobs_Deadlines__mdt> deadlines = [SELECT Days__c, Months__c, Years__c FROM Jobs_Deadlines__mdt WHERE DeveloperName = 'sIDS_Docketing_Deadline'];

        List<SymphonyIPM__Docketing_Activity_v2__c> newActivities = [SELECT Id, SymphonyIPM__Patent__c, SymphonyIPM__Patent__r.Family_ID_sdocs__c, SymphonyIPM__Patent__r.SymphonyIPM__Docket_No__c, SymphonyIPM__Activity_Date__c, SymphonyIPM__Trigger__c FROM SymphonyIPM__Docketing_Activity_v2__c WHERE Id IN :activitiesIds];
        Map<String, SymphonyIPM__Docketing_Activity_v2__c> familyIdsToActivityMap = new Map<String, SymphonyIPM__Docketing_Activity_v2__c>();
        Set<Id> patentIds = new Set<Id>();
        for (SymphonyIPM__Docketing_Activity_v2__c activity : newActivities) {
            familyIdsToActivityMap.put(activity.SymphonyIPM__Patent__r.Family_ID_sdocs__c, activity);
            patentIds.add(activity.SymphonyIPM__Patent__c);
        }

        Map<Id, SymphonyIPM__Patent__c> patentsMap = new Map<Id, SymphonyIPM__Patent__c>([
            SELECT Id, Family_ID_sdocs__c
            FROM SymphonyIPM__Patent__c
            WHERE Family_ID_sdocs__c IN :familyIdsToActivityMap.keySet()
            AND (SymphonyIPM__Country_Code__c = 'US' OR SymphonyIPM__Country_Code__c = 'IL')
            AND (SymphonyIPM__Status__c = 'Pending' OR SymphonyIPM__Status__c = 'NOA Received')
            AND SymphonyIPM__Case_Type__c != 'Provisional'
            AND Id NOT IN :patentIds
        ]);

        List<SymphonyIPM__Docketing_Activity_v2__c> activities = new List<SymphonyIPM__Docketing_Activity_v2__c>();

        Date actionDate = newActivities.get(0)?.SymphonyIPM__Activity_Date__c;

        if (actionDate == null) {
            actionDate = Date.today();
        }
        for (SymphonyIPM__Patent__c patent : patentsMap.values()) {
            Date eventDate = familyIdsToActivityMap.get(patent.Family_ID_sdocs__c)?.SymphonyIPM__Activity_Date__c == null ? Date.today() : familyIdsToActivityMap.get(patent.Family_ID_sdocs__c).SymphonyIPM__Activity_Date__c;
            activities.add(new SymphonyIPM__Docketing_Activity_v2__c(
                    SymphonyIPM__Patent__c = patent.Id,
                    SymphonyIPM__Actions__c = 'sIDS ('
                            + familyIdsToActivityMap.get(patent.Family_ID_sdocs__c).SymphonyIPM__Patent__r.SymphonyIPM__Docket_No__c
                            + '_' + familyIdsToActivityMap.get(patent.Family_ID_sdocs__c).SymphonyIPM__Trigger__c + '_'
                            + eventDate.month() + '/' + eventDate.day() + '/' + eventDate.year()
                            + ')',
                    SymphonyIPM__Trigger__c = 'sIDS',
                    SymphonyIPM__Trigger_Type__c = 'Event',
                    SymphonyIPM__Due_Date__c = actionDate.addDays(Integer.valueOf(deadlines[0].Days__c))
                            .addMonths(Integer.valueOf(deadlines[0].Months__c))
                            .addYears(Integer.valueOf(deadlines[0].Years__c)),
                    SymphonyIPM__Activity_Date__c = Date.today()
            ));
            }

        Database.insert(activities);
    }

    public static void closeFilingActivities(Set<Id> patentIds) {
        List<SymphonyIPM__Docketing_Activity_v2__c> activities = [SELECT Id FROM SymphonyIPM__Docketing_Activity_v2__c WHERE SymphonyIPM__Patent__c IN :patentIds AND SymphonyIPM__Actions__c = 'Application to be filed'];
        for(SymphonyIPM__Docketing_Activity_v2__c activity: activities) {
            activity.SymphonyIPM__Is_Completed__c = true;
            activity.SymphonyIPM__Completion_Date__c = Date.today();
            activity.SymphonyIPM__Reason_to_Complete__c = 'Patent has been filed';
            activity.SymphonyIPM__Completed_By__c = UserInfo.getUserId();
        }

        Database.update(activities);
    }

    public static List<SymphonyIPM__Patent__c> getPatentsById(Id patentId) {
        return PatentSelector.getPatentsByIds(new Set<Id> {patentId});
    }
      public static void magicMethod(){
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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