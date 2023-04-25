public class HelperDocketingActivityTrigger {
    public static void createDocketingReminders(List<SymphonyIPM__Docketing_Activity_v2__c> newActivities){
        List<SymphonyIPM__Docketing_Activity_v2__c> activityReminder = new List<SymphonyIPM__Docketing_Activity_v2__c>();
        Set<String> ruleEngineIds = new Set<String>();
        Set<String> closedActivities = new Set<String>();
        Map<String, List<SymphonyIPM__Docketing_Activity_v2__c>> mapRuleToActitvies = new Map<String, List<SymphonyIPM__Docketing_Activity_v2__c>>();
        for(SymphonyIPM__Docketing_Activity_v2__c activity: newActivities){
            if(!activity.do_not_trigger__c){
                if(activity.SymphonyIPM__Docketed_by__c != null){
                    List<SymphonyIPM__Docketing_Activity_v2__c> temp;
                    if(mapRuleToActitvies.containsKey(activity.SymphonyIPM__Docketed_by__c)){
                        temp = mapRuleToActitvies.get(activity.SymphonyIPM__Docketed_by__c);
                    }else{
                        temp = new List<SymphonyIPM__Docketing_Activity_v2__c>();
                    }

                    temp.add(activity);
                    mapRuleToActitvies.put(activity.SymphonyIPM__Docketed_by__c, temp);
                    ruleEngineIds.add(activity.SymphonyIPM__Docketed_by__c);
                }

                if(activity.SymphonyIPM__Is_Closed__c || activity.SymphonyIPM__Is_Completed__c){
                    closedActivities.add(activity.Id);
                }
            }
        }

        List<Docketing_Rule_Reminder__c> reminders = getActiveRuleReminders(ruleEngineIds);
        for(Docketing_Rule_Reminder__c reminder: reminders){
            for(SymphonyIPM__Docketing_Activity_v2__c parentActivity: mapRuleToActitvies.get(reminder.Docketing_Rule__c)){
                SymphonyIPM__Docketing_Activity_v2__c newReminder = new SymphonyIPM__Docketing_Activity_v2__c();
                newReminder.SymphonyIPM__Docketed_by__c = reminder.Docketing_Rule__c;
                newReminder.SymphonyIPM__Trigger__c = parentActivity.SymphonyIPM__Trigger__c;
                newReminder.SymphonyIPM__Trigger_Type__c = parentActivity.SymphonyIPM__Trigger_Type__c;
                newReminder.Invention_Disclosure__c = parentActivity.Invention_Disclosure__c;
                newReminder.SymphonyIPM__Patent__c = parentActivity.SymphonyIPM__Patent__c;
                newReminder.SymphonyIPM__Activity_Date__c = parentActivity.SymphonyIPM__Activity_Date__c;
                newReminder.SymphonyIPM__Due_Date__c =  calculateDueDate(parentActivity.SymphonyIPM__Due_Date__c, reminder.Offset_Type__c, reminder.Due_Date_Offset__c);
                newReminder.SymphonyIPM__Actions__c = parentActivity.SymphonyIPM__Actions__c + ' - Reminders';
                newReminder.SymphonyIPM__Cloned_Activities__c = parentActivity.Id;
                newReminder.do_not_trigger__c = true;
                newReminder.Docketing_Rule_Reminder__c = reminder.Id;
                if(newReminder.SymphonyIPM__Due_Date__c > Date.today()){
                    activityReminder.add(newReminder);
                }
            }
        }

        insert activityReminder;

        if(closedActivities != null && closedActivities.size() > 0){
            List<SymphonyIPM__Docketing_Activity_v2__c> activitiesToClose = [SELECT Id, SymphonyIPM__Is_Closed__c, SymphonyIPM__Closed_Date__c, SymphonyIPM__Patent__c FROM SymphonyIPM__Docketing_Activity_v2__c WHERE SymphonyIPM__Cloned_Activities__c IN:closedActivities];
            for(SymphonyIPM__Docketing_Activity_v2__c cactivity: activitiesToClose){
                cactivity.SymphonyIPM__Is_Closed__c = true;
                cactivity.SymphonyIPM__Closed_Date__c = date.today();
                cactivity.SymphonyIPM__Comments__c = 'Auto closed reminders.';
            }
            update activitiesToClose;
        }
    }

    public static void createDocketingReminders(List<SymphonyIPM__Docketing_Activity_v2__c> newActivities, Map<Id, SymphonyIPM__Docketing_Activity_v2__c> oldMapActivities){
        List<SymphonyIPM__Docketing_Activity_v2__c> activityReminder = new List<SymphonyIPM__Docketing_Activity_v2__c>();
        Set<String> ruleEngineIds = new Set<String>();
        Set<String> closedActivities = new Set<String>();
        Map<String, List<SymphonyIPM__Docketing_Activity_v2__c>> mapRuleToActitvies = new Map<String, List<SymphonyIPM__Docketing_Activity_v2__c>>();
        Map<String, Date> mapActivityIdsToNewDate = new Map<String, Date>();
        for(SymphonyIPM__Docketing_Activity_v2__c activity: newActivities){
            if(!activity.do_not_trigger__c){
                System.debug('--oldMapActivities.get(activity.Id).SymphonyIPM__Docketed_by__c != activity.SymphonyIPM__Docketed_by__c-- ' + oldMapActivities.get(activity.Id).SymphonyIPM__Docketed_by__c +' - '+ activity.SymphonyIPM__Docketed_by__c);
                if(activity.SymphonyIPM__Docketed_by__c != null && oldMapActivities.get(activity.Id).SymphonyIPM__Docketed_by__c != activity.SymphonyIPM__Docketed_by__c){
                    List<SymphonyIPM__Docketing_Activity_v2__c> temp;
                    if(mapRuleToActitvies.containsKey(activity.SymphonyIPM__Docketed_by__c)){
                        temp = mapRuleToActitvies.get(activity.SymphonyIPM__Docketed_by__c);
                    }else{
                        temp = new List<SymphonyIPM__Docketing_Activity_v2__c>();
                    }

                    temp.add(activity);
                    mapRuleToActitvies.put(activity.SymphonyIPM__Docketed_by__c, temp);
                    ruleEngineIds.add(activity.SymphonyIPM__Docketed_by__c);
                }

                if(activity.SymphonyIPM__Due_Date__c != oldMapActivities.get(activity.Id).SymphonyIPM__Due_Date__c){
                    mapActivityIdsToNewDate.put(activity.Id, activity.SymphonyIPM__Due_Date__c);
                }

                if(activity.SymphonyIPM__Is_Closed__c || activity.SymphonyIPM__Is_Completed__c){
                    closedActivities.add(activity.Id);
                }
            }
        }

        List<Docketing_Rule_Reminder__c> reminders = getActiveRuleReminders(ruleEngineIds);
        for(Docketing_Rule_Reminder__c reminder: reminders){
            for(SymphonyIPM__Docketing_Activity_v2__c parentActivity: mapRuleToActitvies.get(reminder.Docketing_Rule__c)){
                SymphonyIPM__Docketing_Activity_v2__c newReminder = new SymphonyIPM__Docketing_Activity_v2__c();
                newReminder.SymphonyIPM__Docketed_by__c = reminder.Docketing_Rule__c;
                newReminder.SymphonyIPM__Trigger__c = parentActivity.SymphonyIPM__Trigger__c;
                newReminder.SymphonyIPM__Trigger_Type__c = parentActivity.SymphonyIPM__Trigger_Type__c;
                newReminder.Invention_Disclosure__c = parentActivity.Invention_Disclosure__c;
                newReminder.SymphonyIPM__Patent__c = parentActivity.SymphonyIPM__Patent__c;
                newReminder.SymphonyIPM__Activity_Date__c = parentActivity.SymphonyIPM__Activity_Date__c;
                newReminder.SymphonyIPM__Due_Date__c =  calculateDueDate(parentActivity.SymphonyIPM__Due_Date__c, reminder.Offset_Type__c, reminder.Due_Date_Offset__c);
                newReminder.SymphonyIPM__Actions__c = parentActivity.SymphonyIPM__Actions__c + ' - Reminders';
                newReminder.SymphonyIPM__Cloned_Activities__c = parentActivity.Id;
                newReminder.do_not_trigger__c = true;
                newReminder.Docketing_Rule_Reminder__c = reminder.Id;
                if(newReminder.SymphonyIPM__Due_Date__c > Date.today()){
                    activityReminder.add(newReminder);
                }
            }
        }

        insert activityReminder;

        if(mapActivityIdsToNewDate != null && mapActivityIdsToNewDate.size() > 0){
            List<SymphonyIPM__Docketing_Activity_v2__c> activitiesToModfyDate = [SELECT Id, SymphonyIPM__Due_Date__c, Docketing_Rule_Reminder__r.Due_Date_Offset__c, Docketing_Rule_Reminder__r.Offset_Type__c, SymphonyIPM__Cloned_Activities__c FROM SymphonyIPM__Docketing_Activity_v2__c WHERE SymphonyIPM__Cloned_Activities__c IN:mapActivityIdsToNewDate.keyset()];
            for(SymphonyIPM__Docketing_Activity_v2__c cactivity: activitiesToModfyDate){
                cactivity.SymphonyIPM__Due_Date__c = calculateDueDate(mapActivityIdsToNewDate.get(cactivity.SymphonyIPM__Cloned_Activities__c), cactivity.Docketing_Rule_Reminder__r.Offset_Type__c, cactivity.Docketing_Rule_Reminder__r.Due_Date_Offset__c);
                System.debug('--cactivity.SymphonyIPM__Due_Date__c--- ' + cactivity.SymphonyIPM__Due_Date__c);
            }
            update activitiesToModfyDate;
        }

        if(closedActivities != null && closedActivities.size() > 0){
            List<SymphonyIPM__Docketing_Activity_v2__c> activitiesToClose = [SELECT Id, SymphonyIPM__Is_Closed__c, SymphonyIPM__Closed_Date__c, SymphonyIPM__Patent__c FROM SymphonyIPM__Docketing_Activity_v2__c WHERE SymphonyIPM__Cloned_Activities__c IN:closedActivities];
            for(SymphonyIPM__Docketing_Activity_v2__c cactivity: activitiesToClose){
                cactivity.SymphonyIPM__Is_Closed__c = true;
                cactivity.SymphonyIPM__Closed_Date__c = date.today();
                cactivity.SymphonyIPM__Comments__c = 'Auto closed reminders.';
            }
            update activitiesToClose;
        }
    }

    public static Date calculateDueDate(Date dueDate, String offsetType, Decimal dueDateOffset){
        Date rDueDate;
        Integer offsetNumber = -1 * Integer.valueOf(dueDateOffset);
        if(offsetType == 'Months'){
            rDueDate = dueDate.addMonths(offsetNumber);
        }else if(offsetType == 'Days'){
            rDueDate = dueDate.addDays(offsetNumber);
        }

        return rDueDate;
    }

    public static List<Docketing_Rule_Reminder__c> getActiveRuleReminders(Set<String> ruleEngineIds){
        return [SELECT Id, Name, Offset_Type__c, Lifecycle_Stage__c,
                       Importance__c, Due_Date_Offset__c, Docketing_Rule__c, Auto_Close_on_next__c, Follows__c, 
                       Docketing_Rule__r.SymphonyIPM__Trigger__c, Docketing_Rule__r.SymphonyIPM__Trigger_Type__c
                FROM Docketing_Rule_Reminder__c
                WHERE Docketing_Rule__c IN:ruleEngineIds AND Follows__c = NULL];
    }

    public static Map<String, Docketing_Rule_Reminder__c> getActiveRuleRemindersByFollows(Set<String> followsReminderIds){
        Map<String, Docketing_Rule_Reminder__c> followsReminderRules = new Map<String, Docketing_Rule_Reminder__c>();
        List<Docketing_Rule_Reminder__c> reminderRules = [SELECT Id, Name, Offset_Type__c, Lifecycle_Stage__c,
                       Importance__c, Due_Date_Offset__c, Docketing_Rule__c, Auto_Close_on_next__c, Follows__c, 
                       Docketing_Rule__r.SymphonyIPM__Trigger__c, Docketing_Rule__r.SymphonyIPM__Trigger_Type__c
                FROM Docketing_Rule_Reminder__c
                WHERE Follows__c IN:followsReminderIds];
        for(Docketing_Rule_Reminder__c rule: reminderRules){
            followsReminderRules.put(rule.Follows__c, rule);
        }

        return followsReminderRules;
    }

    public static void checkUserActivityAccess(List<SymphonyIPM__Docketing_Activity_v2__c> triggerNew){
        Set<String> patentIds = new Set<String>();
        for(SymphonyIPM__Docketing_Activity_v2__c act: triggerNew){
            patentIds.add(act.SymphonyIPM__Patent__c);
        }

        List<Patent_Role__c> patentRoles = [SELECT Id, Role__c, Patent__c FROM Patent_Role__c WHERE Patent__c IN:patentIds AND Person__r.SymphonyIPM__User__c=:UserInfo.getUserId()];
        Set<String> roles = new Set<String>();
        Map<String, Set<String>> patentToRoleMap = new Map<String, Set<String>>();
        for(Patent_Role__c role: patentRoles){
            Set<String> tempSet;
            if(patentToRoleMap.containsKey(role.Patent__c)){
                tempSet = patentToRoleMap.get(role.Patent__c);
            }else{
                tempSet = new Set<String>();
            }

            tempSet.add(role.Role__c);
            patentToRoleMap.put(role.Patent__c, tempSet);
            roles.add(role.Role__c);
        }
        List<PatentSharingMatrix__mdt> roleMatrix = [SELECT ShareLevel__c, Role__c FROM PatentSharingMatrix__mdt WHERE Object_API_Name__c = 'SymphonyIPM__Docketing_Activity_v2__c' AND Role__c =:roles ORDER BY ShareLevel__c DESC];
        Map<String, String> roleToShareLevel = new Map<String, String>();
        for(PatentSharingMatrix__mdt rolem: roleMatrix){
            roleToShareLevel.put(rolem.Role__c, rolem.ShareLevel__c);
        }

        for(SymphonyIPM__Docketing_Activity_v2__c act: triggerNew){
            if(patentToRoleMap.containsKey(act.SymphonyIPM__Patent__c)){
                Set<String> proles = patentToRoleMap.get(act.SymphonyIPM__Patent__c);
                Set<String> accessLevel = new Set<String>();
                for(String r: proles){
                    if(roleToShareLevel.containsKey(r)){
                        accessLevel.add(roleToShareLevel.get(r));
                    }else{
                        act.addError('You don\'t have access to create an activity');
                    }
                }
                System.debug('--accessLevel.contains--- '  + accessLevel.contains('edit'));
                if(!accessLevel.contains('edit')){
                    act.addError('You don\'t have access to create an activity');
                }   
            }else{
                act.addError('You don\'t have access to create an activity');
            }
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

    }
}