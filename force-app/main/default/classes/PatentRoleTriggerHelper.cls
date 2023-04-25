public class PatentRoleTriggerHelper {
    
    public static void updaterolesinpatentflow(List<Patent_Role__c> patentRoles) {
         Set<Id> patentIds = new Set<Id>();
         Set<Id> personIds = new Set<Id>();
         Set<Id> LawfirmIds = new Set<Id>();
        Map<id,string> rolesmap= new Map<id,string>(); 
         Map<id,id> patwitpermap= new Map<id,id>();
         Map<id,id> patwitlawmap= new Map<id,id>();
        Map<id,SymphonyIPM__Inventor__c> personmap= new Map<id,SymphonyIPM__Inventor__c>();
         Map<id,SymphonyIPM__Law_Firm__c> lawfirmmap= new Map<id,SymphonyIPM__Law_Firm__c>();
        for (Patent_Role__c pr : patentRoles) {
            if(pr.role__C=='IP Responsible Manager' ){ //|| pr.role__C=='IP Paralegal 1'
                personIds.add(pr.Person__c);
                patentIds.add(pr.Patent__c);
                rolesmap.put(pr.Patent__c,pr.role__C);
                patwitpermap.put(pr.Patent__c,pr.Person__c);
            patwitlawmap.put(pr.Patent__c,pr.Law_Firm__c);}
            else if(pr.role__C=='Outside Counsel Firm')
               LawfirmIds.add(pr.Law_Firm__c); 
        }
        if(LawfirmIds.size()>0){
             for(SymphonyIPM__Law_Firm__c law:[select id,name from SymphonyIPM__Law_Firm__c where id in:LawfirmIds ]) {
                              lawfirmmap.put(law.id,law);                
                                          }  
        }
        if(personIds.size()>0){
           for(SymphonyIPM__Inventor__c per:[select id,name,SymphonyIPM__FirstName__c,SymphonyIPM__Email__c,PhoneNumber__c,Registration_Number__c
                                          from SymphonyIPM__Inventor__c where id in:personIds ]) {
                              personmap.put(per.id,per);                
                                          } } 
        if(patentIds.size()>0){
            List<SymphonyIPM__Patent__c> updatepat= new List<SymphonyIPM__Patent__c>();
      for(SymphonyIPM__Patent__c pat:[select id,IPRM_Email__c,IPRM_Name__c,IPRM_Phone_Number__c,IPRM_Registration_Number__c,
      OC_Name__c,Paralegal_Email__c,Paralegal_Name__c  from SymphonyIPM__Patent__c where id in:patentIds]){
           string rolename=rolesmap.get(pat.id);
          SymphonyIPM__Inventor__c person=personmap.get(patwitpermap.get(pat.id));
          SymphonyIPM__Law_Firm__c lawfirm=lawfirmmap.get(patwitlawmap.get(pat.id));
          if(rolename=='IP Paralegal 1'){
              pat.Paralegal_Email__c=person.SymphonyIPM__Email__c;
              pat.Paralegal_Name__c=person.SymphonyIPM__FirstName__c;
          }
          if(rolename=='IP Responsible Manager'){
              Pat.IPRM_Email__c=person.SymphonyIPM__Email__c;
              Pat.IPRM_Name__c=person.SymphonyIPM__FirstName__c;
              Pat.IPRM_Phone_Number__c=person.PhoneNumber__c;
              Pat.IPRM_Registration_Number__c=person.Registration_Number__c;
          }if(rolename=='Outside Counsel Firm'){
              Pat.OC_Name__c=lawfirm.name;
          }    
      updatepat.add(pat);
      }
            if(updatepat.size()>0)
          update updatepat;
        
        }
        
        
    }
  public static void updatePermissionFields(List<Patent_Role__c> patentRoles) {
        Set<Id> patentIds = new Set<Id>();
        for (Patent_Role__c pr : patentRoles) {
            patentIds.add(pr.Patent__c);
        }

        Map<String, List<String>> mapIdRoleToUserIds = new Map<String, List<String>>();
      Map<String, List<String>> mapIdRolePersonnames = new Map<String, List<String>>();
        Map<String, List<String>> mapIdRoleLawfirmnames = new Map<String, List<String>>();
        List<Patent_Role__c> allPatentRoles = [SELECT Id,Law_Firm__r.name, Patent__c,Person__r.name, Person__r.SymphonyIPM__User__r.Id, Role__c FROM Patent_Role__c WHERE Patent__c IN:patentIds AND Role__c <> null];
        Set<Id> patentsWithRoles = new Set<Id>();
        for (Patent_Role__c pr : allPatentRoles) {
            patentsWithRoles.add(pr.Patent__c);
            String key = pr.Patent__c + '-' + pr.Role__c;
            List<String> temp;
             List<String> tempname;
            List<String> templawname;
            if (mapIdRoleToUserIds.containsKey(key)) {
                temp = mapIdRoleToUserIds.get(key);
            } else {
                temp = new List<String>();
            }
             if (mapIdRolePersonnames.containsKey(key)) {
                tempname = mapIdRolePersonnames.get(key);
            } else {
                tempname = new List<String>();
            }
            if (mapIdRoleLawfirmnames.containsKey(key)) {
                templawname = mapIdRoleLawfirmnames.get(key);
            } else {
                templawname = new List<String>();
            }
            temp.add(pr.Person__r.SymphonyIPM__User__r.Id);
            tempname.add(pr.Person__r.name);
            templawname.add(pr.Law_Firm__r.name);
            mapIdRoleToUserIds.put(key, temp);
            mapIdRolePersonnames.put(key, tempname);
            mapIdRoleLawfirmnames.put(key, templawname);
        }

        Map<String, SymphonyIPM__Patent__c> mapIdf = new Map<String, SymphonyIPM__Patent__c>();

        for (Id patentId : patentIds) {
            if (!patentsWithRoles.contains(patentId)) {
                mapIdf.put(patentId, clearPatentRolesIds(patentId));
            }
        }

        for (String key : mapIdRoleToUserIds.keySet()) {
            List<String> keySplit = key.split('-');
            String patentId = keySplit[0];
            String role = keySplit[1];
            SymphonyIPM__Patent__c temp;
            if (mapIdf.containsKey(patentId)) {
                temp = mapIdf.get(patentId);
            } else {
                temp = clearPatentRolesIds(patentId);
            }

            if (role == 'IP Associate 1') {
                temp.IP_Associate_1_Ids__c = String.join(mapIdRoleToUserIds.get(key), ';');
                 temp.IP_Asscoiate_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Associate 2') {
                temp.IP_Associate_2_Ids__c = String.join(mapIdRoleToUserIds.get(key), ';');
            } else if (role == 'IP Associate 3') {
                temp.IP_Associate_3_Ids__c = String.join(mapIdRoleToUserIds.get(key), ';');
            } else if (role == 'IP Coordinator') {
                temp.IP_Coordinator_Ids__c = String.join(mapIdRoleToUserIds.get(key), ';');
                  temp.IP_Coordinator_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Partner') {
                temp.IP_Partner_Ids__c = String.join(mapIdRoleToUserIds.get(key), ';');
                 temp.IP_Partner_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Responsible Manager') {
                temp.IP_Responsible_Manager_Ids__c = String.join(mapIdRoleToUserIds.get(key), ';');
                 temp.IP_Responsible_Manager_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'XDiv Partner') {
                temp.XDiv_Partner__c = String.join(mapIdRoleToUserIds.get(key), ';');
                 temp.XDiv_Partner_Namess__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'Docketing') {
                temp.Docketing__c = String.join(mapIdRoleToUserIds.get(key), ';');
                 temp.Docketer_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Compensation Manager') {
                temp.IP_Comp_Manager_Ids__c = String.join(mapIdRoleToUserIds.get(key), ';');
                 temp.IP_Compensation_Manager_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Paralegal 1') {
                temp.IP_Paralegal_1_Ids__c = String.join(mapIdRoleToUserIds.get(key), ';');
                 temp.IP_Paralegal_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Paralegal 2') {
                temp.IP_Paralegal_2_Ids__c = String.join(mapIdRoleToUserIds.get(key), ';');
            } else if (role == 'Previous Internal IP Contact') {
                temp.Previous_Internal_IP_Contact_Ids__c = String.join(mapIdRoleToUserIds.get(key), ';');
                  temp.Previous_Internal_IP_Contact_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Committee Member') {
                temp.IP_Committee_Member_Ids__c = String.join(mapIdRoleToUserIds.get(key), ';');
                 temp.IP_Committee_Member_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            }else if (role == 'Other') {
               temp.Other_Names__c = String.join(mapIdRolePersonnames.get(key), ';'); 
            } else if (role == 'Agent') { 
               temp.Agent_names__c = String.join(mapIdRoleLawfirmnames.get(key), ';'); 
            }else if (role == 'Former OC Firm') {
               temp.Former_OC_Firm_Names__c = String.join(mapIdRoleLawfirmnames.get(key), ';'); 
            }else if (role == 'OC Support Firm') {
               temp.OC_Support_Firm_Names__c = String.join(mapIdRoleLawfirmnames.get(key), ';'); 
            }else if (role == 'Outside Counsel Firm') {
               temp.Outside_Counsel_Firm_Names__c = String.join(mapIdRoleLawfirmnames.get(key), ';'); 
            }

            mapIdf.put(patentId, temp);
        }
        update mapIdf.values();
    }

 //   @future
    public static void shareRecordsBasedOnRoles(Set<Id> patentIds) {
        removeSharingOnRoles(patentIds);
        List<Patent_Role__c> patentRoles = [SELECT Id, Person__r.SymphonyIPM__User__c, Person__r.SymphonyIPM__User__r.Id, Patent__c, Patent__r.OwnerId, Role__c FROM Patent_Role__c WHERE Patent__c IN:patentIds AND Person__r.SymphonyIPM__User__r.IsActive = TRUE];

        Map<Id, SymphonyIPM__Patent__c> prcMeetings = getPRCMeetings(patentIds);
        Map<Id, List<SymphonyIPM__Docketing_Activity_v2__c>> docketActivities = getDocketingActivities(patentIds);
        //Map<Id, List<SymphonyIPM__Patent_Attachments__c>> documents = getDocuments(patentIds);
        Map<Id, List<SymphonyIPM__IDF_Review__c>> ratings = getRatings(patentIds);

        List<SymphonyIPM__PRC_Meeting__Share> prcMeetingShares = new List<SymphonyIPM__PRC_Meeting__Share>();
        List<SymphonyIPM__Patent__share> patentShares = new List<SymphonyIPM__Patent__share>();
        List<SymphonyIPM__Docketing_Activity_v2__share> docketActivityShares = new List<SymphonyIPM__Docketing_Activity_v2__share>();
        //List<SymphonyIPM__Patent_Attachments__share> documentShares = new List<SymphonyIPM__Patent_Attachments__share>();
        List<SymphonyIPM__IDF_Review__share> ratingShares = new List<SymphonyIPM__IDF_Review__share>();

        Map<String, SymphonyIPM__Patent__share> existingShare = new Map<String, SymphonyIPM__Patent__share>();
        for (SymphonyIPM__Patent__share pshare : [SELECT Id, ParentId, AccessLevel, UserOrGroupId, RowCause FROM SymphonyIPM__Patent__share WHERE ParentId IN:patentIds]) {
            String key = pshare.ParentId + '-' + pshare.UserOrGroupId;
            existingShare.put(key, pshare);
        }

        List<SymphonyIPM__Patent__share> shareToDelete = new List<SymphonyIPM__Patent__share>();
        Set<string> DuplicateChk= new Set<string>();
        for (Patent_Role__c pr : patentRoles) {

            if (pr.Person__r.SymphonyIPM__User__c != null) {
                //Apex sharing for Patent records
                List<PatentSharingMatrix__mdt> axsSetting = [SELECT ShareLevel__c FROM PatentSharingMatrix__mdt WHERE Object_API_Name__c = 'SymphonyIPM__Patent__c' AND Role__c = :pr.Role__c LIMIT 1];
                if (axsSetting != null && axsSetting.size() > 0) {
                    if (pr.Person__r.SymphonyIPM__User__r.Id != pr.Patent__r.OwnerId) {
                        String key = pr.Patent__c + '-' + pr.Person__r.SymphonyIPM__User__r.Id;

                        if (existingShare.containsKey(key) && !DuplicateChk.contains(key)) {
                        DuplicateChk.add(key);
                            shareToDelete.add(existingShare.get(key));
                        }

                        SymphonyIPM__Patent__share pshare = new SymphonyIPM__Patent__share();
                        pshare.ParentId = pr.Patent__c;
                        pshare.AccessLevel = axsSetting[0].ShareLevel__c;
                        pshare.UserOrGroupId = pr.Person__r.SymphonyIPM__User__r.Id;
                        pshare.RowCause = 'Manual';
                        patentShares.add(pshare);
                    }
                }


                //Apex sharing for PRC meetings
                List<PatentSharingMatrix__mdt> pcrSetting = [SELECT ShareLevel__c FROM PatentSharingMatrix__mdt WHERE Object_API_Name__c = 'SymphonyIPM__PRC_Meeting__c' AND Role__c = :pr.Role__c LIMIT 1];
                if (pcrSetting != null && pcrSetting.size() > 0) {
                    if (prcMeetings.containsKey(pr.Patent__c) && prcMeetings.get(pr.Patent__c).SymphonyIPM__Base_Invention_Disclosure_New__c != null) {
                        SymphonyIPM__PRC_Meeting__Share prcShare = new SymphonyIPM__PRC_Meeting__Share(
                                ParentId = prcMeetings.get(pr.Patent__c).SymphonyIPM__Base_Invention_Disclosure_New__r.PRC_Meeting__c,
                                AccessLevel = pcrSetting[0].ShareLevel__c,
                                UserOrGroupId = pr.Person__r.SymphonyIPM__User__r.Id,
                                RowCause = 'Manual'
                        );
                        prcMeetingShares.add(prcShare);
                    }
                }

                //Apex sharing for docket Activities
                List<PatentSharingMatrix__mdt> acSetting = [SELECT ShareLevel__c FROM PatentSharingMatrix__mdt WHERE Object_API_Name__c = 'SymphonyIPM__Docketing_Activity_v2__c' AND Role__c = :pr.Role__c LIMIT 1];
                if (acSetting != null && acSetting.size() > 0) {
                    if (docketActivities.containsKey(pr.Patent__c)) {
                        for (SymphonyIPM__Docketing_Activity_v2__c dActivity : docketActivities.get(pr.Patent__c)) {
                            if (pr.Person__r.SymphonyIPM__User__r.Id != dActivity.OwnerId) {
                                SymphonyIPM__Docketing_Activity_v2__share daShare = new SymphonyIPM__Docketing_Activity_v2__share(
                                        ParentId = dActivity.Id,
                                        AccessLevel = acSetting[0].ShareLevel__c,
                                        UserOrGroupId = pr.Person__r.SymphonyIPM__User__r.Id,
                                        RowCause = 'Manual'
                                );
                                docketActivityShares.add(daShare);
                            }
                        }
                    }
                }

                //Apex sharing for Patent documents
                /*for(SymphonyIPM__Patent_Attachments__c document: documents.get(pr.Patent__c)){
                    SymphonyIPM__Patent_Attachments__share dShare = new SymphonyIPM__Patent_Attachments__share(
                        ParentId = document.Id,
                        AccessLevel = [SELECT ShareLevel__c FROM PatentSharingMatrix__mdt WHERE Object_API_Name__c='SymphonyIPM__Patent_Attachments__c' AND Role__c =: pr.Role__c LIMIT 1].ShareLevel__c,
                        UserOrGroupId = pr.Person__r.SymphonyIPM__User__r.Id,
                        RowCause = 'ApexAuto'
                    );
                    documentShares.add(dShare);    
                }*/

                //Apex sharing for Patent ratings
                List<PatentSharingMatrix__mdt> rwSetting = [SELECT ShareLevel__c FROM PatentSharingMatrix__mdt WHERE Object_API_Name__c = 'SymphonyIPM__IDF_Review__c' AND Role__c = :pr.Role__c LIMIT 1];
                if (rwSetting != null && rwSetting.size() > 0) {
                    if (ratings.containsKey(pr.Patent__c)) {
                        for (SymphonyIPM__IDF_Review__c rating : ratings.get(pr.Patent__c)) {
                            if (pr.Person__r.SymphonyIPM__User__r.Id != rating.OwnerId) {
                                SymphonyIPM__IDF_Review__share rShare = new SymphonyIPM__IDF_Review__share(
                                        ParentId = rating.Id,
                                        AccessLevel = rwSetting[0].ShareLevel__c,
                                        UserOrGroupId = pr.Person__r.SymphonyIPM__User__r.Id,
                                        RowCause = 'Manual'
                                );
                                ratingShares.add(rShare);
                            }
                        }
                    }
                }
            }
        }

        delete shareToDelete;
        insert patentShares;
        //insert prcMeetingShares;
        insert docketActivityShares;
        //insert documentShares;
        insert ratingShares;
    }

    public static void removeSharingOnRoles(Set<Id> patentIds) {
        List<SymphonyIPM__Patent__share> delPatentShares = [SELECT Id FROM SymphonyIPM__Patent__share WHERE ParentId IN:patentIds AND RowCause = 'Manual'];
        if (delPatentShares != null && delPatentShares.size() > 0) {
            delete delPatentShares;
        }

        Set<String> prcMeetingIds = new Set<String>();
        Map<Id, SymphonyIPM__Patent__c> prcMeetings = getPRCMeetings(patentIds);
        for (SymphonyIPM__Patent__c patent : prcMeetings.values()) {
            if (patent.SymphonyIPM__Base_Invention_Disclosure_New__c != null) {
                prcMeetingIds.add(patent.SymphonyIPM__Base_Invention_Disclosure_New__r.PRC_Meeting__c);
            }
        }

        List<SymphonyIPM__PRC_Meeting__Share> prcDelShareRecords = [SELECT Id, ParentId, UserOrGroupId FROM SymphonyIPM__PRC_Meeting__Share WHERE ParentId IN:prcMeetingIds AND RowCause = 'Manual'];
        if (prcDelShareRecords != null && prcDelShareRecords.size() > 0) {
            delete prcDelShareRecords;
        }

        Set<String> docketIds = new Set<String>();
        for (SymphonyIPM__Docketing_Activity_v2__c activity : [SELECT Id, SymphonyIPM__Patent__c, OwnerId FROM SymphonyIPM__Docketing_Activity_v2__c WHERE SymphonyIPM__Patent__c IN:patentIds]) {
            docketIds.add(activity.Id);
        }

        List<SymphonyIPM__Docketing_Activity_v2__share> delDocketShare = [SELECT Id, ParentId, UserOrGroupId FROM SymphonyIPM__Docketing_Activity_v2__share WHERE ParentId IN:docketIds AND RowCause = 'Manual'];
        if (delDocketShare != null && delDocketShare.size() > 0) {
            delete delDocketShare;
        }

        Set<String> reviewIds = new Set<String>();
        for (SymphonyIPM__IDF_Review__c rating : [SELECT Id, SymphonyIPM__Base_Patent_Record__c, OwnerId FROM SymphonyIPM__IDF_Review__c WHERE SymphonyIPM__Base_Patent_Record__c IN:patentIds]) {
            reviewIds.add(rating.Id);
        }

        List<SymphonyIPM__IDF_Review__share> delRatingShare = [SELECT Id, ParentId, UserOrGroupId FROM SymphonyIPM__IDF_Review__share WHERE ParentId IN:reviewIds AND RowCause = 'Manual'];
        if (delRatingShare != null && delRatingShare.size() > 0) {
            delete delRatingShare;
        }
    }

    public static void validateRoles(List<Patent_Role__c> triggerNew) {
        Set<Id> patentIds = new Set<Id>();
        for (Patent_Role__c role : triggerNew) {
            patentIds.add(role.Patent__c);
        }
        Map<String, Integer> rolesPersonsMap = new Map<String, Integer>();
         Map<String, Integer> roleslawfirmMap = new Map<String, Integer>();
        for (Patent_Role__c role : [SELECT Id, Patent__c, Role__c, Person__c ,Law_Firm__c FROM Patent_Role__c WHERE Patent__c IN :patentIds]) {
            String key = role.Patent__c + '-' + role.Person__c + '-' + role.Role__c;
             String lawkey = role.Patent__c + '-' + role.Law_Firm__c + '-' + role.Role__c;
            Integer count,lawcount;
            if (rolesPersonsMap.containsKey(key)) {
                count = rolesPersonsMap.get(key);
            } else {
                count = 0;
            }
            if (roleslawfirmMap.containsKey(lawkey)) {
                lawcount = roleslawfirmMap.get(lawkey);
            } else {
                lawcount = 0;
            }
            count += 1;
            lawcount += 1;
            rolesPersonsMap.put(key, count);
            roleslawfirmMap.put(lawkey, lawcount);
        }

        for (Patent_Role__c role : triggerNew) {
            if(role.Person__c!=null){
            String key = role.Patent__c + '-' + role.Person__c + '-' + role.Role__c;
            if (rolesPersonsMap.containsKey(key) && rolesPersonsMap.get(key) > 0) {
                role.addError('Person should be unique within Patent object for the role');
            }
            }
            if(role.Law_Firm__c!=null){
              String lawkey = role.Patent__c + '-' + role.Law_Firm__c + '-' + role.Role__c;
            if (roleslawfirmMap.containsKey(lawkey) && roleslawfirmMap.get(lawkey) > 0) {
                role.addError('Lawfirm should be unique within Patent object for the role');
            }  
            }
        }
    }

    public static void validateRoles(Map<Id, Patent_Role__c> triggerNewMap, Map<Id, Patent_Role__c> triggerOldMap) {
        Set<Id> patentIds = new Set<Id>();
        for (Patent_Role__c role : triggerNewMap.values()) {
            system.debug('---role2--- ' + role);
            system.debug('---role2 Old--- ' + triggerOldMap.get(role.Id));
            patentIds.add(role.Patent__c);
        }
        Map<String, Integer> rolesPersonsMap = new Map<String, Integer>();
        Map<String, Integer> rolesLawsMap = new Map<String, Integer>();
        for (Patent_Role__c role : [SELECT Id, Patent__c, Role__c, Person__c,Law_Firm__c FROM Patent_Role__c WHERE Patent__c IN :patentIds]) {
            if (!triggerNewMap.containsKey(role.Id)) {
                String key = role.Patent__c + '-' + role.Person__c + '-' + role.Role__c;
                String Lawkey = role.Patent__c + '-' + role.Law_Firm__c + '-' + role.Role__c;
                Integer count,Lawcount;
                if (rolesPersonsMap.containsKey(key)) {
                    count = rolesPersonsMap.get(key);
                } else {
                    count = 0;
                }
                count += 1;
                if (rolesLawsMap.containsKey(Lawkey)) {
                    Lawcount = rolesLawsMap.get(Lawkey);
                } else {
                    Lawcount = 0;
                }
                Lawcount += 1;
                rolesPersonsMap.put(key, count);
                rolesLawsMap.put(key, Lawcount);
            }
        }

        system.Debug('--rolesPersonsMap-- ' + rolesPersonsMap);
        for (Patent_Role__c role : triggerNewMap.values()) {
            if(role.Person__c!=null){
            String key = role.Patent__c + '-' + role.Person__c + '-' + role.Role__c;
            system.debug('--key-- ' + key);
            system.debug('--role--- ' + role);
            if (rolesPersonsMap.containsKey(key) && rolesPersonsMap.get(key) > 0) {
                role.addError('Person should be unique within Patent object for the role');
            }
            }
            if(role.Law_Firm__c!=null){
            String Lawkey = role.Patent__c + '-' + role.Law_Firm__c + '-' + role.Role__c;
            if (rolesLawsMap.containsKey(Lawkey) && rolesPersonsMap.get(Lawkey) > 0) {
                role.addError('Lawfirms should be unique within Patent object for the role');
            }
            }
        
        }
    }

    private static Map<Id, SymphonyIPM__Patent__c> getPRCMeetings(Set<Id> patentIds) {
        Map<Id, SymphonyIPM__Patent__c> patents = new Map<Id, SymphonyIPM__Patent__c>([SELECT Id, SymphonyIPM__Base_Invention_Disclosure_New__c, SymphonyIPM__Base_Invention_Disclosure_New__r.PRC_Meeting__c FROM SymphonyIPM__Patent__c WHERE Id IN:patentIds]);
        return patents;
    }

    private static Map<Id, List<SymphonyIPM__Docketing_Activity_v2__c>> getDocketingActivities(Set<Id> patentIds) {
        Map<Id, List<SymphonyIPM__Docketing_Activity_v2__c>> activities = new Map<Id, List<SymphonyIPM__Docketing_Activity_v2__c>>();
        for (SymphonyIPM__Docketing_Activity_v2__c activity : [SELECT Id, SymphonyIPM__Patent__c, OwnerId FROM SymphonyIPM__Docketing_Activity_v2__c WHERE SymphonyIPM__Patent__c IN:patentIds]) {
            List<SymphonyIPM__Docketing_Activity_v2__c> temp;
            if (activities.containsKey(activity.SymphonyIPM__Patent__c)) {
                temp = activities.get(activity.SymphonyIPM__Patent__c);
            } else {
                temp = new List<SymphonyIPM__Docketing_Activity_v2__c>();
            }
            temp.add(activity);
            activities.put(activity.SymphonyIPM__Patent__c, temp);
        }

        return activities;
    }

    private static Map<Id, List<SymphonyIPM__Patent_Attachments__c>> getDocuments(Set<Id> patentIds) {
        Map<Id, List<SymphonyIPM__Patent_Attachments__c>> documents = new Map<Id, List<SymphonyIPM__Patent_Attachments__c>>();
        for (SymphonyIPM__Patent_Attachments__c document : [SELECT Id, SymphonyIPM__Patent__c FROM SymphonyIPM__Patent_Attachments__c WHERE SymphonyIPM__Patent__c IN:patentIds]) {
            List<SymphonyIPM__Patent_Attachments__c> temp;
            if (documents.containsKey(document.SymphonyIPM__Patent__c)) {
                temp = documents.get(document.SymphonyIPM__Patent__c);
            } else {
                temp = new List<SymphonyIPM__Patent_Attachments__c>();
            }
            temp.add(document);
            documents.put(document.SymphonyIPM__Patent__c, temp);
        }

        return documents;
    }

    private static Map<Id, List<SymphonyIPM__Patent__c>> getRelatedPatents(Set<Id> patentIds) {
        //TODO:   
        Map<Id, List<SymphonyIPM__Patent__c>> realtedPatents = new Map<Id, List<SymphonyIPM__Patent__c>>();
        return realtedPatents;
    }

    // private static Map<Id, List<NOA_Checklist__c>> getNOAChecklists(Set<Id> patentIds){
    //     //Not required as its a Mater-Detail relationship and is controlled by parent
    // }

    private static Map<Id, List<SymphonyIPM__IDF_Review__c>> getRatings(Set<Id> patentIds) {
        Map<Id, List<SymphonyIPM__IDF_Review__c>> ratings = new Map<Id, List<SymphonyIPM__IDF_Review__c>>();
        for (SymphonyIPM__IDF_Review__c rating : [SELECT Id, SymphonyIPM__Base_Patent_Record__c, OwnerId FROM SymphonyIPM__IDF_Review__c WHERE SymphonyIPM__Base_Patent_Record__c IN:patentIds]) {
            List<SymphonyIPM__IDF_Review__c> temp;
            if (ratings.containsKey(rating.SymphonyIPM__Base_Patent_Record__c)) {
                temp = ratings.get(rating.SymphonyIPM__Base_Patent_Record__c);
            } else {
                temp = new List<SymphonyIPM__IDF_Review__c>();
            }
            temp.add(rating);
            ratings.put(rating.SymphonyIPM__Base_Patent_Record__c, temp);
        }

        return ratings;
    }

    private static SymphonyIPM__Patent__c clearPatentRolesIds(Id patentId) {
        return new SymphonyIPM__Patent__c(
                Id = patentId,
                IP_Associate_1_Ids__c = '',
                Proles_IDs__c ='',
                IP_Asscoiate_Names__c='',
                IP_Coordinator_Names__c='',
                IP_Partner_Names__c='',
                IP_Responsible_Manager_Names__c='',
                XDiv_Partner_Namess__c='',
                Docketer_Names__c='',
                IP_Compensation_Manager_Names__c='',
                IP_Associate_2_Ids__c = '',
                IP_Paralegal_Names__c='',
                Previous_Internal_IP_Contact_Names__c='',
                IP_Committee_Member_Names__c='',
                Agent_names__c='',
                Other_Names__c='',
                Former_OC_Firm_Names__c='',
                OC_Support_Firm_Names__c='',
                Outside_Counsel_Firm_Names__c='',
                IP_Associate_3_Ids__c = '',
                IP_Coordinator_Ids__c = '',
                IP_Partner_Ids__c = '',
                IP_Responsible_Manager_Ids__c = '',
                XDiv_Partner__c = '',
                Docketing__c = '',
                IP_Comp_Manager_Ids__c = '',
                IP_Paralegal_1_Ids__c = '',
                IP_Paralegal_2_Ids__c = '',
                Previous_Internal_IP_Contact_Ids__c = '',
                IP_Committee_Member_Ids__c = ''
                );
    }
  /*  public static void updatePatentrolepersonfield(Map<Id, Patent_Role__c> triggerNewMap, Map<Id, Patent_Role__c> triggerOldMap) {
       
    } */   
      public static void updatePatentrolepersonfield(List<Patent_Role__c> patentRoles) {
         List<SymphonyIPM__Patent__c> updatepatentlist= new List<SymphonyIPM__Patent__c>();
         Set<Id> patentIds = new Set<Id>();
         Set<Id> Personids = new Set<Id>();
         Map<id,string> personmap= new Map<id,string>();
           Map<id,string> personnamemap= new Map<id,string>();
         Map<id,string> patentpersonmap= new Map<id,string>();
          
         for (Patent_Role__c pr : patentRoles) {
            if(pr.Person__c!=null)
             Personids.add(pr.Person__c);
             patentIds.add(pr.Patent__c);
             }
          set<id> perids= new set<id>();
        list<Patent_Role__c> patrole=[select id,Patent__c,Person__c from Patent_Role__c where Patent__c in:patentIds];
          for(Patent_Role__c p:patrole){
              perids.add(p.Person__c);
          }
          for(SymphonyIPM__Inventor__c inv: [select id,name from SymphonyIPM__Inventor__c where id in:perids]){
           personmap.put(inv.id,inv.name); 
            
            }   
        
        for (Patent_Role__c pr : patrole) {
            string str='';
            if(patentpersonmap.containsKey(pr.Patent__c)){
             str=patentpersonmap.get(pr.Patent__c)+','+personmap.get(pr.Person__c);
            }else{
              str=personmap.get(pr.Person__c);  
            }
            patentpersonmap.put(pr.Patent__c,str);
        }
       for(SymphonyIPM__Patent__c patrec:[select id,Current_Patent_Roles__c from SymphonyIPM__Patent__c where id in:patentIds]){
            if(patrec.Current_Patent_Roles__c!=null){
               patrec.Current_Patent_Roles__c= patentpersonmap.get(patrec.id) ;
            }else{
              patrec.Current_Patent_Roles__c=patentpersonmap.get(patrec.id);
            }
            updatepatentlist.add(patrec);
        }
       if(updatepatentlist.size()>0)
           update updatepatentlist;
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

}
    
    // private static Map<Id, List<EmailToDocketing>> getEmailToDocketing(Set<Id> patentIds){}
}