public class Disclosurecalloc {

    @auraenabled
    Public static list<string> getlawfirm(id recordid){
        list<string> firmlist = new list<string>();
        SymphonyIPM__Invention_Disclosure_New__c inv=[select id,Law_Firm__r.name from SymphonyIPM__Invention_Disclosure_New__c
                                                           where id=:recordid];
        if(inv.Law_Firm__r.name!=null){
            system.debug('Valus is'+inv.Law_Firm__r.name);
          firmlist.add(inv.Law_Firm__r.name);
            list<SymphonyIPM__Law_Firm__c > lawlist=[select id,name from SymphonyIPM__Law_Firm__c where name!=:inv.Law_Firm__r.name];
            // firmlist.add('--Select--');
            for(SymphonyIPM__Law_Firm__c law:lawlist){
                
                firmlist.add(law.name);
            }
        }
        
        else{
           list<SymphonyIPM__Law_Firm__c > lawlist=[select id,name from SymphonyIPM__Law_Firm__c ];
             firmlist.add('--Select--');
            for(SymphonyIPM__Law_Firm__c law:lawlist){
                
                firmlist.add(law.name);
            }
        }
        return firmlist;
    }
    
      @auraenabled
    Public static list<string> getlawcounsel(id recordid){
        list<string> firmlist = new list<string>();
        SymphonyIPM__Invention_Disclosure_New__c inv=[select id,Outside_Counsel__c,Law_Firm__r.name,Outside_Counsel__r.name from SymphonyIPM__Invention_Disclosure_New__c
                                                           where id=:recordid];
        if(inv.Outside_Counsel__c!=null ){
          
         firmlist.add(inv.Outside_Counsel__r.name);
             SymphonyIPM__Invention_Disclosure_New__c laswfirm=[select id,Law_Firm__r.name from SymphonyIPM__Invention_Disclosure_New__c
                                                           where id=:recordid];
            string lawf=laswfirm.Law_Firm__r.name;
             list<SymphonyIPM__Inventor__c> counsel=[select id,SymphonyIPM__User__r.name from SymphonyIPM__Inventor__c where SymphonyIPM__Law_Firm__r.name =:lawf
                                                 and   recordtype.name='OC'];
            for(SymphonyIPM__Inventor__c invv:counsel){
                firmlist.add(invv.SymphonyIPM__User__r.name);
            }
        system.debug('fiem lsit-->'+firmlist);
        
        }
        
        else
        {
           SymphonyIPM__Invention_Disclosure_New__c sym=[select id,Law_Firm__r.name from 
           SymphonyIPM__Invention_Disclosure_New__c where id=:recordid];
       string lawfrimname=sym.Law_Firm__r.name;
         system.debug('lawfrimname-->'+lawfrimname);
        list<string> counsellist = new list<string>();
        list<SymphonyIPM__Inventor__c> invlist=[select id,name,recordtype.name from SymphonyIPM__Inventor__c
                                                     where recordtype.name='OC' AND SymphonyIPM__Law_Firm__r.name=:lawfrimname ];
       system.debug('invlist'+invlist);
        if(invlist!=null){
              system.debug('coming inn%%');
            firmlist.add('--Select one--');
           for(SymphonyIPM__Inventor__c  ilis:invlist){
                firmlist.add(ilis.name);
            }
        }else{
              system.debug('coming else%%');
             firmlist.add('--None--');
        }  
        }
        return firmlist;
    }
     @auraenabled
    Public static list<string> getousidecounsel(string  lawfirm,id recordid){
        SymphonyIPM__Law_Firm__c law=[select id,name from SymphonyIPM__Law_Firm__c where name=:lawfirm];
         system.debug('law'+law);
         SymphonyIPM__Invention_Disclosure_New__c sym=[select id,Law_Firm__c from 
           SymphonyIPM__Invention_Disclosure_New__c where id=:recordid];
        sym.Law_Firm__c=law.id;
        update sym;
         system.debug('lawfirm'+lawfirm);
        list<string> counsellist = new list<string>();
        list<SymphonyIPM__Inventor__c> invlist=[select id,name,recordtype.name from SymphonyIPM__Inventor__c
                                                     where recordtype.name='OC' AND SymphonyIPM__Law_Firm__r.name=:lawfirm ];
       system.debug('invlist'+invlist);
        if(invlist!=null){
              system.debug('coming inn%%');
            counsellist.add('--Select one--');
           for(SymphonyIPM__Inventor__c  ilis:invlist){
                counsellist.add(ilis.name);
            }
           // firmlist.add(inv.Law_Firm__r.name);
        }else{
              system.debug('coming else%%');
             counsellist.add('--None--');
        }
        
        return counsellist;
    }
    @auraenabled
    Public static string updatedisclosure(string  outcounsel,id recordid){
      //  list<string> counsellist = new list<string>();
       system.debug('outcounsel-->'+outcounsel);
        
         SymphonyIPM__Inventor__c invlist=[select id,SymphonyIPM__User__r.id,SymphonyIPM__User__r.email,name,recordtype.name from SymphonyIPM__Inventor__c
                                                     where recordtype.name='OC' AND name=:outcounsel limit 1];
      //SymphonyIPM__Inventor__c per=[select id,SymphonyIPM__User__c from SymphonyIPM__Inventor__c where SymphonyIPM__User__r.name =:outcounsel limit 1];
       // system.debug('counsel-->'+per.id);
      SymphonyIPM__Invention_Disclosure_New__c sym=[select id,Law_Firm__c from 
           SymphonyIPM__Invention_Disclosure_New__c where id=:recordid];
      sym.Outside_Counsel__c=invlist.SymphonyIPM__User__r.id;
        if(invlist.SymphonyIPM__User__r.email!=null){
           // sym.SymphonyIPM__Outside_Counsel_User_Emailid__c=invlist.SymphonyIPM__User__r.email;
        }
        
        try{ update sym;
           return 'success';
           }
        catch(Exception e){
            string str=e.getMessage();
            system.debug('str'+str);
            return str;
            //return null;
        }
        
        
    }
    
}