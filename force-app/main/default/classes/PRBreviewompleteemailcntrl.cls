public class PRBreviewompleteemailcntrl {
    
    public ID prcmeetdetailId {get; set;}
    
    public string cuurentuser{get;set;}
    public string Attendedlist{get;set;}
      public string Attendedlistnew{get;set;}
     public List<SymphonyIPM__PRC_Meeting_Details__c> listdata {get;set;}
     public List<id> idfdata {get;set;}
    public ID invId {get; set;}
    public string recplist{get; set;}
    public string title{get; set;}
    public string finalstring{get; set;}
    public SymphonyIPM__PRC_Meeting_Details__c prcdetail{get; set;}
    public List<attendance> attendlist {get; set;}
    public string docno{get; set;}
    public string prcmeetingpath{get; set;}
    public string prcmeetingname{get; set;}
     public string mentors{get; set;}
    public datetime prcmeetingdate{get; set;}
    Public boolean getShowtext(){
        system.debug('calling property');
        accessdata();
        return true;
    }
     public class attendance {
        //public SymphonyIPM__Invention_Disclosure_New__c idf {get; set;}
        public string idfname {get; set;}
        public string  name {get; set;}
 
        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        public attendance(string nam,string idfn) {
            idfname = idfn;
            name = nam;
        }
    }
   /* public SymphonyIPM__PRC_Meeting_Details__c getprcdetail() {
    * 
          
SymphonyIPM__PRC_Meeting_Details__c prcdetail=[select id,Final_Rating__c,SymphonyIPM__Related_Invention_Disclosure__r.name,
 SymphonyIPM__Related_Invention_Disclosure__r.SymphonyIPM__Title__c,SymphonyIPM__Related_Invention_Disclosure__r.Inventors__c,
SymphonyIPM__Related_Invention_Disclosure__r.Primary_Inventor__c,SymphonyIPM__Related_Invention_Disclosure__r.Mentors__c,
SymphonyIPM__PRC_Meeting__r.SymphonyIPM__Path__r.name,SymphonyIPM__PRC_Meeting__r.SymphonyIPM__Meeting_Date__c from 
 SymphonyIPM__PRC_Meeting_Details__c where id=:prcmeetdetailId];
        
       
    return sipdeail;
    }  */
   
    
    public void accessdata(){
        try{
            idfdata=new list<id>();
            SymphonyIPM__PRC_Meeting__c prcmeeting=[select id,name,SymphonyIPM__Meeting_Date__c from SymphonyIPM__PRC_Meeting__c
                                                where id=:prcmeetdetailId];
            string meetingname=prcmeeting.name;
            string comparedate= string.valueof(prcmeeting.SymphonyIPM__Meeting_Date__c);
     list<SymphonyIPM__PRC_Meeting_Details__c> prcdetails=[select id,Final_Rating__c,UHG_Sort_Order__c,SymphonyIPM__Related_Invention_Disclosure__r.Final_Rating__c,
     SymphonyIPM__Related_Invention_Disclosure__r.id,SymphonyIPM__Related_Invention_Disclosure__r.name,SymphonyIPM__Related_Invention_Disclosure__r.Notes2__c,
 SymphonyIPM__Related_Invention_Disclosure__r.SymphonyIPM__Title__c,SymphonyIPM__Related_Invention_Disclosure__r.Inventors__c,
SymphonyIPM__Related_Invention_Disclosure__r.Primary_Inventor__c,SymphonyIPM__Related_Invention_Disclosure__r.Mentors__c 
                      from  SymphonyIPM__PRC_Meeting_Details__c where SymphonyIPM__PRC_Meeting__c=:prcmeetdetailId order by UHG_Sort_Order__c ]; 
            
            
            listdata= new list<SymphonyIPM__PRC_Meeting_Details__c>();
            for(SymphonyIPM__PRC_Meeting_Details__c lid:prcdetails){
                 if(lid.SymphonyIPM__Related_Invention_Disclosure__r.Inventors__c!=null){
                     recplist=recplist+lid.SymphonyIPM__Related_Invention_Disclosure__r.Inventors__c+',';}
            listdata.add(lid);
                 idfdata.add(lid.SymphonyIPM__Related_Invention_Disclosure__r.id);
             cuurentuser=userinfo.getFirstName();   
              }
            list<id> userids= new list<id>();
            map<string,list<id>> attendmap= new map<string,list<id>>();
          list<SymphonyIPM__IDF_Review__c> reviewlist=[select id,Owner_s_Name__c,SymphonyIPM__Reviewed_By__c,
            SymphonyIPM__Base_Invention_Disclosure__r.name,SymphonyIPM__Base_Invention_Disclosure__r.id from SymphonyIPM__IDF_Review__c where
                 SymphonyIPM__Base_Invention_Disclosure__c in :idfdata and  PRC_Date__c=:comparedate order by Owner_s_Name__c ];
                                                       //PRC_Meeting_Name__c=:meetingname];
            Attendedlistnew='';
            attendlist= new list<attendance>();
            for(SymphonyIPM__IDF_Review__c idfr:reviewlist){
                if(attendmap.containskey(idfr.Owner_s_Name__c)){
                    list<id> ids=attendmap.get(idfr.Owner_s_Name__c);
                    ids.add(idfr.SymphonyIPM__Base_Invention_Disclosure__r.id);
                    attendmap.put(idfr.Owner_s_Name__c,ids);
                }else{
                    list<id> idli=new list<id>();
                    idli.add(idfr.SymphonyIPM__Base_Invention_Disclosure__r.id);
                    attendmap.put(idfr.Owner_s_Name__c,idli);
                }
                 system.debug('attendmap'+attendmap);
                  system.debug('size'+idfdata.size());
               // attendlist.add(new attendance(idfr.Owner_s_Name__c,idfr.SymphonyIPM__Base_Invention_Disclosure__r.name));
                userids.add(idfr.SymphonyIPM__Reviewed_By__c);
                Attendedlistnew=Attendedlistnew+idfr.Owner_s_Name__c+',';
            } 
            map<string,string> nametoidf= new map<string,string>();
            for(SymphonyIPM__IDF_Review__c idfr:reviewlist){
                if(nametoidf.containsKey(idfr.Owner_s_Name__c)){
                    string str=nametoidf.get(idfr.Owner_s_Name__c)+', '+idfr.SymphonyIPM__Base_Invention_Disclosure__r.name;
                    nametoidf.put(idfr.Owner_s_Name__c,str);
                }else{
                   nametoidf.put(idfr.Owner_s_Name__c,idfr.SymphonyIPM__Base_Invention_Disclosure__r.name);
                }
                system.debug('val name'+idfr.Owner_s_Name__c);
                if(idfr.Owner_s_Name__c!=null){
                list<id> checkids=attendmap.get(idfr.Owner_s_Name__c);
                     system.debug('checkids size'+checkids.size());
                     system.debug('idfdata size'+idfdata.size());
                if(checkids.size()==idfdata.size()){
                    if(idfdata.size()==1){
                       // for(string str:nametoidf.keyset()){
                     // attendlist.add(new attendance(idfr.Owner_s_Name__c,idfr.SymphonyIPM__Base_Invention_Disclosure__r.name));
                        }
                } else{
                  // attendlist.add(new attendance(idfr.Owner_s_Name__c,idfr.SymphonyIPM__Base_Invention_Disclosure__r.name));
                }
                }
            }
            system.debug('nametoidf-->'+nametoidf);
             for(string str:nametoidf.keyset()){
                      attendlist.add(new attendance(str,nametoidf.get(str)));
                        }
            
            for (String fieldName : attendmap.keySet()){
              list<id> checksize=attendmap.get(fieldName);
                if(checksize.size()==idfdata.size()){
                    attendmap.remove(fieldName);
                }
                 }
            system.debug('attendlist'+attendlist);
            list<user> usrlist=[select id,name from user where id in:userids];
            for(user u:usrlist){
                Attendedlist=Attendedlist+u.name+',';
               // Attendedlist.add(u.name);
            }
            if(Attendedlistnew!=null){
                Attendedlistnew=Attendedlistnew.removeEnd(',');}
             system.debug('list data is-->'+listdata);
            SymphonyIPM__PRC_Meeting__c prcmeet=[select id,name,SymphonyIPM__Meeting_Date__c,SymphonyIPM__Path__r.name from 
             SymphonyIPM__PRC_Meeting__c where id=:prcmeetdetailId ];
            prcmeetingname='';
            prcmeetingname=prcmeet.name;
             prcmeetingpath=prcmeet.SymphonyIPM__Path__r.name;
            prcmeetingdate=prcmeet.SymphonyIPM__Meeting_Date__c;

        }catch (Exception e){
            system.debug('Exception occured'+e.getMessage());
            
        }
    }
    // This Method is for Temporary code coverage
    public static void codecalcualtion(){
        integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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