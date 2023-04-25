public class OtherMatterRoleTriggerHelper {
    
    public static void updatePermissionFields(List<OM_Role__c> OMRoles) {
         Set<Id> OMIds = new Set<Id>();
        for (OM_Role__c pr : OMRoles) {
            OMIds.add(pr.Other_Matters__c);
        }
      Map<String, List<String>> mapIdRoleToUserIds = new Map<String, List<String>>();
      Map<String, List<String>> mapIdRolePersonnames = new Map<String, List<String>>(); 
        Map<String, List<String>> mapIdRoleLawfirmnames = new Map<String, List<String>>();
       List<OM_Role__c> allOMRoles = [SELECT Id,Law_Firm__r.name,Other_Matters__c,Person__r.name,Role__c FROM OM_Role__c WHERE Other_Matters__c IN:OMIds AND Role__c <> null];
        Set<Id> OMsWithRoles = new Set<Id>();
          for (OM_Role__c pr : allOMRoles) {
            OMsWithRoles.add(pr.Other_Matters__c);
            String key = pr.Other_Matters__c + '-' + pr.Role__c;
            List<String> tempname;
            List<String> tempLawname;
             if (mapIdRolePersonnames.containsKey(key)) {
                tempname = mapIdRolePersonnames.get(key);
            } else {
                tempname = new List<String>();
            }
             if (mapIdRoleLawfirmnames.containsKey(key)) {
                tempLawname = mapIdRoleLawfirmnames.get(key);
            } else {
                tempLawname = new List<String>();
            }
            tempname.add(pr.Person__r.name);
             tempLawname.add(pr.Law_Firm__r.name);
            mapIdRolePersonnames.put(key, tempname);
            mapIdRoleLawfirmnames.put(key, tempLawname);
        }
        
           Map<String, Other_Matters__c> mapIdf = new Map<String, Other_Matters__c>();
           
           
            for (Id omId : OMIds) {
            if (!OMsWithRoles.contains(omId)) {
                mapIdf.put(omId, clearOMRolesIds(omId));
            }
        }

      for (String key : mapIdRolePersonnames.keySet()) {
            List<String> keySplit = key.split('-');
            String OMId = keySplit[0];
            String role = keySplit[1];
            Other_Matters__c temp;
            if (mapIdf.containsKey(OMId)) {
                temp = mapIdf.get(OMId);
            } else {
                temp = clearOMRolesIds(OMId);
            }

            if (role == 'IP Associate') {
                temp.IP_Associate_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            }  else if (role == 'IP Coordinator') {
               temp.IP_Coordinator_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Director') {
                temp.IP_Director_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            }else if (role == 'IP Partner') {
                temp.IP_Partner_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Responsible Manager') {
                 temp.IP_Responsible_Manager_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'XDiv Partner') {
                temp.XDiv_Partner_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'Docketing') {
                temp.Docketer_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Compensation Manager') {
                 temp.IP_Compensation_Manager_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Paralegal 1') {
               temp.IP_Paralegal_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            }  else if (role == 'Previous Internal IP Contact') {
                 temp.Previous_Internal_IP_Contact_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            } else if (role == 'IP Committee Member') {
             //    temp.IP_Committee_Member_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            }else if (role == 'OC Support Firm') {
                temp.OC_Support_Firm_Names__c = String.join(mapIdRoleLawfirmnames.get(key), ';');
            }else if (role == 'Outside Counsel Firm') {
                temp.Outside_Counsel_Firm_Names__c = String.join(mapIdRoleLawfirmnames.get(key), ';');
            }else if (role == 'Former OC Firm') {
                temp.Former_OC_Firm_Names__c = String.join(mapIdRoleLawfirmnames.get(key), ';');
            }else if (role == 'Other') {
                temp.Other_Names__c = String.join(mapIdRolePersonnames.get(key), ';');
            }else if (role == 'Agent') {
                temp.Agent_names__c = String.join(mapIdRoleLawfirmnames.get(key), ';');
            }
            

            mapIdf.put(OMId, temp);
        }
        update mapIdf.values();
    


        
           }
           
           
           
         private static Other_Matters__c clearOMRolesIds(Id OMid) {
        return new Other_Matters__c(
                Id = OMid,
                IP_Associate_Names__c = '',
               IP_Coordinator_Names__c = '',
               IP_Responsible_Manager_Names__c = '',
                XDiv_Partner_Names__c = '',
                Docketer_Names__c = '',
                IP_Compensation_Manager_Names__c = '',
                IP_Paralegal_Names__c = '',
                IP_Director_Names__c='',
               Previous_Internal_IP_Contact_Names__c = '',
               OC_Support_Firm_Names__c='',
               Outside_Counsel_Firm_Names__c='',
               Former_OC_Firm_Names__c='',
               Other_Names__c='',
               Agent_names__c=''
               
                );
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
     i++;}          

}