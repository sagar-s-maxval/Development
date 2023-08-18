trigger keywordtrigg on SymphonyIPM__Keyword__c (before insert, before update,before delete,after delete, after insert, after update) {
    if(trigger.isbefore ){
        
        list<id> keylist = new list<id>();
        list<id> highid=new list<id>();
        map<id,id> keymap= new map<id,id>();
        if(trigger.isinsert ){
            for(SymphonyIPM__Keyword__c  sym:trigger.new){
                if(sym.SymphonyIPM__Keyword_Hierarchy__c!=null){
                    highid.add(sym.SymphonyIPM__Keyword_Hierarchy__c);
                    keylist.add(sym.id);
                    keymap.put(sym.id,sym.SymphonyIPM__Keyword_Hierarchy__c);
                }
                else{
                    sym.Fullname__c='';
                    sym.number__c=0;
                }
            }
            map<id,string> mapstring= new map<id,string>();
            list<SymphonyIPM__Keyword__c > keylis=[select id,name,Description__c,Fullname__c,(select id from SymphonyIPM__Keywords__r) from SymphonyIPM__Keyword__c 
                                                   where id in:highid ];
            map<id,string> keyfulname=new map<id,string>();
            map<id,string> keydes= new map<Id,string>();
            map<id,integer> keynum= new map<id,integer>();
            for(SymphonyIPM__Keyword__c  key:keylis){
                mapstring.put(key.id,key.name);
                keyfulname.put(key.id,key.Fullname__c);
                keydes.put(key.id,key.Description__c);
                list<SymphonyIPM__Keyword__c >  keysize=key.SymphonyIPM__Keywords__r;
                integer intt =keysize.size();
                keynum.put(key.id,intt );
            }
            list<SymphonyIPM__Keyword__c> updatekeys= new list<SymphonyIPM__Keyword__c>();
            for(SymphonyIPM__Keyword__c  sym:trigger.new){
                if(sym.SymphonyIPM__Keyword_Hierarchy__c!=null){
                    sym.number__c=keynum.get(sym.SymphonyIPM__Keyword_Hierarchy__c)+1;
                    updatekeys.add(sym);
                }
            }
            if(updatekeys.size()>0){
                //update updatekeys;
            }
            list<SymphonyIPM__Keyword__c> kelupdate= new list<SymphonyIPM__Keyword__c>();
            for(SymphonyIPM__Keyword__c  sym:trigger.new){
                if(sym.SymphonyIPM__Keyword_Hierarchy__c!=null){
                    
                    system.debug('sym.name'+sym.name);
                    string str=sym.name;
                    sym.name=str.remove(mapstring.get(sym.SymphonyIPM__Keyword_Hierarchy__c)+':');
                    sym.name__c=sym.name;
                    string sstrdec=keydes.get(sym.SymphonyIPM__Keyword_Hierarchy__c);
                    if(sstrdec.contains(' (')){
                        
                        sstrdec=sstrdec.remove(')');
                        sstrdec=sstrdec+'.'+sym.number__c +')';
                        sym.Description__c=sstrdec;
                    }else{
                        
                        sym.Description__c=keydes.get(sym.SymphonyIPM__Keyword_Hierarchy__c)+' ('+sym.number__c +')';
                    }
                    //sym.Description__c=keydes.get(sym.SymphonyIPM__Keyword_Hierarchy__c)+' ('+sym.number__c +')';
                    //sym.Description__c=keydes.get(sym.SymphonyIPM__Keyword_Hierarchy__c)+'.'+sym.number__c;
                    sym.Fullname__c=keyfulname.get(sym.SymphonyIPM__Keyword_Hierarchy__c)+':'+sym.name;
                }else{
                    sym.Description__c=sym.name;
                    sym.name__c=sym.name;
                    sym.Fullname__c=sym.name;
                }    
                kelupdate.add(sym);
            }
        }    
        
        if(trigger.isupdate){
            //Child canno be added as parent
            set<string> setofParentIds = new set<string>();
            for(SymphonyIPM__Keyword__c objkeyword : Trigger.new)
            {
                setofParentIds.add(objkeyword.SymphonyIPM__Keyword_Hierarchy__c);
            }
            if(setofParentIds.size() > 0)
            {
                map<id,SymphonyIPM__Keyword__c > mapParentkeywordsAdded = new map<id,SymphonyIPM__Keyword__c>([select id,name,Description__c,Fullname__c,SymphonyIPM__Keyword_Hierarchy__c from SymphonyIPM__Keyword__c WHERE id IN: setofParentIds]);
                for(SymphonyIPM__Keyword__c objkeyword : Trigger.new)
                {
                    if(mapParentkeywordsAdded.containskey(objkeyword.SymphonyIPM__Keyword_Hierarchy__c))
                    {
                        SymphonyIPM__Keyword__c objKeywordParent = mapParentkeywordsAdded.get(objkeyword.SymphonyIPM__Keyword_Hierarchy__c);
                        if(objKeywordParent.SymphonyIPM__Keyword_Hierarchy__c == objkeyword.Id)
                        {
                            objkeyword.addError('You cannot add a child keyword to Parent');
                        }
                    }
                    if(objkeyword.SymphonyIPM__Keyword_Hierarchy__c == objkeyword.Id)
                    {
                        objkeyword.addError('You cannot add a parent keyword to itself');
                    }
                }
            }
            
            
            
            list<id> hierid= new list<id>();
            list<id> oldsym= new list<id>();
            list<SymphonyIPM__Keyword__c> oldsymkey = new list<SymphonyIPM__Keyword__c>();
            for(SymphonyIPM__Keyword__c sym:trigger.new){
                SymphonyIPM__Keyword__c oldkey=Trigger.oldMap.get(sym.ID);
                if(oldkey.SymphonyIPM__Keyword_Hierarchy__c!=null&&oldkey.SymphonyIPM__Keyword_Hierarchy__c!=sym.SymphonyIPM__Keyword_Hierarchy__c){
                    // oldsym.add(oldkey.SymphonyIPM__Keyword_Hierarchy__c);
                    hierid.add(oldkey.SymphonyIPM__Keyword_Hierarchy__c);
                }
                if(sym.SymphonyIPM__Keyword_Hierarchy__c!=null){
                    hierid.add(sym.SymphonyIPM__Keyword_Hierarchy__c); 
                }}
            if(oldsym.size()>0){
                oldsymkey=[select id,name,name__C,Description__c,Fullname__c,(select id,name,name__C,Description__c,Fullname__c from SymphonyIPM__Keywords__r order by createddate ASC) from SymphonyIPM__Keyword__c 
                           where id in:oldsym];
            }
            if(oldsymkey.size()>0){
            }
            
            list<SymphonyIPM__Keyword__c> hierlist=[select id,name,name__C,Description__c,Fullname__c,(select id,name,name__C,Description__c,Fullname__c from SymphonyIPM__Keywords__r order by createddate ASC) from SymphonyIPM__Keyword__c 
                                                    where id in:hierid];
            map<id,integer> mapnumber =new map<id,integer>();
            map<id,string> fullnamemap= new map<id,string>();
            map<id,string> descriptionmap= new map<id,string>();
            map<id,string> namemap= new map<id,string>();
            for(SymphonyIPM__Keyword__c slist:hierlist){
                system.debug(slist.Description__c);
                system.debug(slist.Fullname__c);
                fullnamemap.put(slist.id,slist.Fullname__c);
                descriptionmap.put(slist.id,slist.Description__c);
                
                integer count=0;
                for(SymphonyIPM__Keyword__c ss:slist.SymphonyIPM__Keywords__r){
                    mapnumber.put(ss.id,count+1);
                    count++;
                }
                system.debug('mapnumber'+mapnumber);
            }
            for(SymphonyIPM__Keyword__c sym:trigger.new){
                if(sym.SymphonyIPM__Keyword_Hierarchy__c!=null){
                    
                    /* if(Constant.relateupdate==false){
system.debug('new keywoed'+sym);
string str=sym.name;
list<string> liststr=str.split(':');
sym.name=liststr[1];
if(sym.Fullname__c!=null){
string fullname=sym.Fullname__c;
sym.Fullname__c=fullname.replace(sym.name__C,sym.name);}
else{
sym.Fullname__c='';
}
sym.name__C=sym.name;
}*/
                    //   else{
                    system.debug('new keywoed'+sym);
                    string str=sym.name;
                    System.debug(sym.name);
                    If(str.contains(':'))
                    {
                    list<string> liststr=str.split(':');
                    sym.name=liststr[1];
                    System.debug(sym.name);
                        system.debug('Before exe');}
                    else
                    {
                        sym.name=str;
                    }
                    //sym.name=sym.name__C;
                    sym.number__c=mapnumber.get(sym.id);
                    string sstrdec=descriptionmap.get(sym.SymphonyIPM__Keyword_Hierarchy__c);
                    if(sstrdec.contains(' (')){
                        
                        sstrdec=sstrdec.remove(')');
                        sstrdec=sstrdec+'.'+sym.number__c +')';
                        sym.Description__c=sstrdec;
                    }else{
                        
                        sym.Description__c=descriptionmap.get(sym.SymphonyIPM__Keyword_Hierarchy__c)+' ('+sym.number__c +')';
                    }
                    
                    // sym.Description__c=descriptionmap.get(sym.SymphonyIPM__Keyword_Hierarchy__c)+'.'+sym.number__c;
                    string fullname=fullnamemap.get(sym.SymphonyIPM__Keyword_Hierarchy__c);
                    sym.Fullname__c=fullname+':'+sym.name;
                    // }
                }
                else{
                    sym.Description__c=sym.Name;
                    sym.Fullname__c=sym.name;
                    sym.name__C=sym.name;
                    
                }
            }
            if(!System.isFuture())  
                UpdateChildKeywords.updatekeywordsonparentUpdate(Trigger.newMap.keyset()); 
            
        }
        
        if(trigger.isdelete){
            list<id> oldids= new list<id>();
            list<id> parentkey= new list<id>();
            map<id,id> keyparent= new map<id,id>();
            map<id,list<SymphonyIPM__Keyword__c>> keychild= new map<id,list<SymphonyIPM__Keyword__c>>();
            //map<id,id> keyparent= new map<id,id>();
            for(SymphonyIPM__Keyword__c ss:trigger.old){
                if(ss.SymphonyIPM__Keyword_Hierarchy__c!= null){
                    parentkey.add(ss.SymphonyIPM__Keyword_Hierarchy__c);
                    keyparent.put(ss.id,ss.SymphonyIPM__Keyword_Hierarchy__c);
                    oldids.add(ss.id);
                    keyparent.put(ss.id,ss.SymphonyIPM__Keyword_Hierarchy__c);
                    
                } }
            list<SymphonyIPM__Keyword__c > keylistold=[select id,name,SymphonyIPM__Keyword_Hierarchy__c,Description__c,Fullname__c from SymphonyIPM__Keyword__c 
                                                       where SymphonyIPM__Keyword_Hierarchy__c in:oldids ];
            for(SymphonyIPM__Keyword__c slis:keylistold){
                if(keychild.containskey(slis.SymphonyIPM__Keyword_Hierarchy__c)){
                    list<SymphonyIPM__Keyword__c> symli=keychild.get(slis.SymphonyIPM__Keyword_Hierarchy__c);
                    symli.add(slis);
                    keychild.put(slis.SymphonyIPM__Keyword_Hierarchy__c,symli);
                }
                else{
                    list<SymphonyIPM__Keyword__c> sym=new list<SymphonyIPM__Keyword__c>();
                    sym.add(slis);
                    keychild.put(slis.SymphonyIPM__Keyword_Hierarchy__c,sym);
                    
                }
            }
            list<SymphonyIPM__Keyword__c> keylistt= new list<SymphonyIPM__Keyword__c>();
            for(id keyid:keychild.keyset()){
                list<SymphonyIPM__Keyword__c> slist=keychild.get(keyid);
                for(SymphonyIPM__Keyword__c sll:slist){
                    sll.SymphonyIPM__Keyword_Hierarchy__c=keyparent.get(keyid);
                    keylistt.add(sll);
                }
            }
            if(keylistt.size()>0){
                update keylistt;
            }
            if(parentkey.size()>0){
                list<SymphonyIPM__Keyword__c> parents=[select id from SymphonyIPM__Keyword__c where id in:parentkey];
                update parents;
                //update parentkey;
            }
            
        }
    }  
    if(trigger.isafter && (trigger.isupdate|| trigger.isdelete)){
        list<SymphonyIPM__Keyword__c> updatelist= new list<SymphonyIPM__Keyword__c>(); 
        
        
        
        
        
        if(trigger.isupdate)   {
            system.debug('After exe');
            list<SymphonyIPM__Keyword__c > listtoupdate = new list<SymphonyIPM__Keyword__c >();
            list<id> idslist= new list<id>();
            list<id> hierid= new list<id>();
            for(SymphonyIPM__Keyword__c key:trigger.new){
                system.debug('keyowrd old'+key);
                SymphonyIPM__Keyword__c oldkey=Trigger.oldMap.get(key.ID);
                if(oldkey.SymphonyIPM__Keyword_Hierarchy__c!=null&&oldkey.SymphonyIPM__Keyword_Hierarchy__c!=key.SymphonyIPM__Keyword_Hierarchy__c){
                    // oldsym.add(oldkey.SymphonyIPM__Keyword_Hierarchy__c);
                    hierid.add(key.SymphonyIPM__Keyword_Hierarchy__c);
                }
                idslist.add(key.id);
                
                listtoupdate.add(key);
            }
            if(hierid.size()>0){
                list<SymphonyIPM__Keyword__c > keylist=[select id from SymphonyIPM__Keyword__c 
                                                        where id in:hierid ];
                //system.debug('keylist'+keylist);
                Constant.relateupdate=true;
               update keylist;
                
            }
            else{
                system.debug('coming inside');
                list<SymphonyIPM__Keyword__c > keylis=[select id,name,Description__c,Fullname__c,(select id from SymphonyIPM__Keywords__r) from SymphonyIPM__Keyword__c 
                                                       where id in:idslist ];
                //list<SymphonyIPM__Keyword__c> updatelist= new list<SymphonyIPM__Keyword__c>();
                for(SymphonyIPM__Keyword__c  sim:keylis){
                    for(list<SymphonyIPM__Keyword__c>  ss:sim.SymphonyIPM__Keywords__r){
                        if(ss.size()>0){
                            Constant.relateupdate=true;
                            updatelist.addall(ss);
                        }
                    }
                } 
                System.debug('updatelist'+updatelist);    
                if(updatelist.size()>0 && updatelist.size()<40 ){
                   //update updatelist;
                }else if(updatelist.size()>40){
                    //Database.executeBatch(new Keywordchunk(updatelist), 1);
                    
                }
            }
        }
        
        
    }
}