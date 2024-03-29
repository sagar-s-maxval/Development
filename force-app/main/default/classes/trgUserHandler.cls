public with sharing class trgUserHandler {
    public void handleRecycling(set<string> profNames,set<id> userIds,Boolean isInsrt)
    {
        //system.debug('calling handler class');
        Set<String> profileNames = new Set<String>();
        List<User> usersLst = new List<User>();
        Map<id,integer> lastLoginLst = new Map<id,integer>();
        for(string i: profNames)
        {
            //gets the users whose last logged in dates are greater than the deactivation criteria
             
            //Boolean reOrder = licenseRecyclingDetails.isReorderMail(i);
            
            if(i=='Platform Inventor')
            {
                usersLst =licenseRecyclingDetails.getUserList(i,userIds);
                lastLoginLst =licenseRecyclingDetails.getLastLoginDetails(i);
                profileNames.add(i);
            }  
            
            //licenceRecyclingJitUpdate.updateJITCustomSetting(i);
        }
        if(profileNames.size()>0)
        {
           /* List<String> profNamesLst = new List<String>();
            profNamesLst.addAll(profileNames); */
      String profName = '';
            profName = 'Platform Inventor';    
            licenceRecyclingReorderOpBatch bat = new licenceRecyclingReorderOpBatch(profName,usersLst,userIds,lastLoginLst,isInsrt); 
            database.executeBatch(bat,1);
        }
        system.debug('i is: '+profileNames);
    }
}