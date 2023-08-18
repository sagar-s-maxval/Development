({
    init: function(component, event, helper) {
        
        // var newdate  = component.find("datein").get("v.value");
        // var newdate = $A.localizationService.formatDate("v.todaydate", "YYYY-MM-DD");
        //alert('ques 1'+component.get("v.que1"));
        //alert('ques 2'+component.get("v.que2"));
        //alert('optionsvaluedefault'+component.get('v.optionsvaluedefault'));
        component.set('v.storedate', component.get("v.todaydate"));
        var dat= $A.localizationService.formatDate(component.get("v.todaydate"));
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.futuredate', today);
        //alert('future>>'+component.get('v.futuredate'));
        component.set('v.todaydate', component.get("v.todaydate"));
        component.set('v.storedate', dat);
        console.log('date: ',dat);
        
        //For Date of Earliest Use
        var value = component.set('v.storedate2', component.get("v.todaydate2"));
        var dat2= $A.localizationService.formatDate(component.get("v.todaydate2"));
        /*var today2 = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.futuredate1', today2);
        component.set('v.todaydate2', component.get("v.todaydate2"));*/
        console.log('date: ',value);
        component.set('v.storedate2', dat2);
        
        
         //For Date of Earliest External Use
        component.set('v.storedate3', component.get("v.todaydate3"));
        var dat3= $A.localizationService.formatDate(component.get("v.todaydate3"));
        /*var today3 = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.futuredate2', today3);
        component.set('v.todaydate3', component.get("v.todaydate3"));*/
        component.set('v.storedate3', dat3);
        
        //For Date of Earliest Planned Use
        component.set('v.storedate4', component.get("v.todaydate4"));
        var dat4= $A.localizationService.formatDate(component.get("v.todaydate4"));
        /*var today4 = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.futuredate2', today4);
        component.set('v.todaydate4', component.get("v.todaydate4"));*/
        component.set('v.storedate4', dat4);
        
        component.set("v.ques273check",component.get("v.ques273check"));
        component.set("v.ques273",component.get("v.ques273"));
        component.set("v.CheckboxNew",component.get("v.CheckboxNew"));
        component.set("v.CheckboxNew1",component.get("v.CheckboxNew1"));
        component.set("v.CheckboxNew2",component.get("v.CheckboxNew2"));
        component.set("v.CheckboxNew3",component.get("v.CheckboxNew3"));
        component.set("v.CheckboxNew4",component.get("v.CheckboxNew4"));
        component.set("v.CheckboxNew5",component.get("v.CheckboxNew5"));
        component.set("v.ques21",component.get("v.ques21"));
        //alert('Prior submission onload cmp2'+component.get("v.ques21"));
        component.set("v.que2",component.get("v.que2"));
        component.set("v.ques22",component.get("v.ques22"));
        component.set("v.ques23",component.get("v.ques23"));

        //-------------VALIDATION---------
        
        
        component.set("v.publicDisclosurechk",component.get("v.publicDisclosurechk"));
        
        component.set("v.CurrentCommercial23",component.get("v.CurrentCommercial23"));
        
        component.set("v.useExternal230",component.get("v.useExternal230"));
        //alert('idf form'+component.get("v.ThirdPartyConfidentiality24"));
        component.set("v.ThirdPartyConfidentiality24",component.get("v.ThirdPartyConfidentiality24"));
        component.set("v.FutureImplementation25",component.get("v.FutureImplementation25"));
        component.set("v.CompetingProducts26",component.get("v.CompetingProducts26"));
        component.set("v.ThirdPartyContributions27",component.get("v.ThirdPartyContributions27"));
        //--------------------------------
        if(component.get("v.todaydate") == false)
        {
            component.set('v.storedate','');
        }
        else if(component.get("v.todaydate2") == false)
        {
            component.set('v.storedate2','');
        }
        else if(component.get("v.todaydate3") == false)
        {
            component.set('v.storedate3','');
        }
        else if(component.get("v.todaydate4") == false)
        {
            component.set('v.storedate4','');
        }
        
        
    },
    ans21 : function (component, event, helper) {
        //var ans1 = component.find("question21").get("v.checked"); Mar 30
        var ans1 = component.find("question21").get("v.value");
        
        //alert(ans1+ 'ans1');
        if(ans1 == 'false' || ans1 == 'true')
        {
            component.set('v.ques21','');
        }
        //alert('ques21'+component.get('v.ques21'));
        component.set('v.optionsvaluedefault',ans1);
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:PriorsubmissionEvent21');
        cmpevent.setParams({"PriorsubmissionEvent21":component.get('v.ques21')});
        cmpevent.fire();
        //----------------
        //  component.set("v.selectans1", ans1);
        //alert('is prior submission-->'+component.find("question21").get("v.checked"));
        var cmpevent = $A.get('e.c:IsPriorSubmission21Event');
        cmpevent.setParams({"IsPriorsubmission21":ans1});
        cmpevent.fire();  
    },
    ans22 : function (component, event, helper) {
        var ans2 = component.find("question22").get("v.value");
        // alert(ans2+ 'ans2');
        if(ans2 == 'false')
        {
            component.set('v.storedate','');
            component.set('v.ques22','');
            component.set('v.validatedate',false)
            
        }        
        component.set("v.publicDisclosurechk", ans2);
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:PublicDisclosureDateEvent23Chk');
        cmpevent.setParams({"PublicDisclosureDate":component.get("v.storedate")});
        cmpevent.fire();
        var cmpevent = $A.get('e.c:PublicDisclosure22');
        cmpevent.setParams({"PublicDisclosure22":component.get('v.ques22')});
        cmpevent.fire();
        
        //----------------
        //alert(component.get("v.publicDisclosurechk"));
        var cmpevent = $A.get('e.c:ISPublicDisclosureCheckQ22');
        cmpevent.setParams({"ISPublicDisclosureCheckQ22":ans2});
        cmpevent.fire();
    },
    ans23 : function (component, event, helper) {
        var ans3 = component.find("question23").get("v.value");
        // alert('form2 controller 23>>>>>'+ans3);
        if(ans3 == 'false'|| ans3 == 'true') 
        {
            component.set('v.storedate2','');
            component.set('v.ques23','');
            component.set('v.validateearlierusedate',false)
        }
            component.set("v.CurrentCommercial23", ans3);

        var cmpevent = $A.get('e.c:DateofEarliestUseEvent');
        cmpevent.setParams({"Dateofearliestuse":component.get("v.storedate2")});
        cmpevent.fire();
        
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:CommercialEvent23');
        cmpevent.setParams({"CommercialEvent23":component.get('v.ques23')});
        cmpevent.fire();
        //----------------
        
        // alert('seting value to c.current'+component.get("v.CurrentCommercial23"));
        var cmpevent = $A.get('e.c:IsCommercialCheckQ23');
        cmpevent.setParams({"IsCommercialCheckQ23":ans3});
        cmpevent.fire();
        
    },
    
    ans230 : function (component, event, helper) {
        var ans230 = component.find("question230").get("v.value");
        if(ans230 == 'false' || ans230 == 'true')
        {
            component.set('v.storedate3','');
            component.set('v.ques230','');
            component.set('v.validateEarliestExternalUsedate',false)
        }
        var cmpevent = $A.get('e.c:DateofEarliestExternalUseEvent');
        cmpevent.setParams({"DateofEarliestExternalUse":component.get("v.storedate3")});
        cmpevent.fire();
        
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:ExternalTxt230Event');
        cmpevent.setParams({"ExternalTxt230Event": component.set('v.ques230')});
        cmpevent.fire();
        //----------------
        
        component.set("v.useExternal230", ans230);
        //alert('ck'+ans230);
        var cmpevent = $A.get('e.c:ExternalUseEvent23Chk');
        cmpevent.setParams({"ExternalUseChk":ans230});
        cmpevent.fire();
        
    },
    que24added : function (component, event, helper) {
        var added = component.find("queadd").get("v.value");
        //alert('form 2 checkbox>'+ added);
        if(added == 'false')
        {
            component.set('v.q24added','');
        }
        
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:ThirdPartyConfidentiality');
        cmpevent.setParams({"ThirdPartyConfidentiality":component.get('v.q24added')});
        cmpevent.fire();
        //----------------
        
        component.set("v.ThirdPartyConfidentiality24", added);
        //alert('ThirdPartyConfidentiality24 '+component.get('v.ThirdPartyConfidentiality24'));
        var cmpevent = $A.get('e.c:IsThirdPartyConfidentiality');
        cmpevent.setParams({"IsThirdPartyConfidentiality":added});
        cmpevent.fire();
        
    },
    ans24 : function (component, event, helper) {
        var ans24 = component.find("question24").get("v.value");
        //alert('ans24>>>  '+ans24);
        if(ans24 == 'false'|| ans24 == 'true')
        {
            component.set('v.storedate4','');
            component.set('v.ques24','');
            component.set('v.validateEarliestPlannedUseDate',false)

        }
        var cmpevent = $A.get('e.c:DateofEarliestPlannedUseEvent');
        cmpevent.setParams({"EarliestPlanUseDate":component.get("v.storedate4")});
        cmpevent.fire();
        
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:FutureEventQ24');
        cmpevent.setParams({"FutureEventQ24":component.get('v.ques24')});
        cmpevent.fire();
        //----------------
        
        component.set("v.FutureImplementation25", ans24);
        //alert('FutureImplementation25'+component.get('v.FutureImplementation25'));
        var cmpevent = $A.get('e.c:Futureimplementation24checkbox');
        cmpevent.setParams({"Futureimplementation24checkbox":ans24});
        cmpevent.fire();
        
    },
    ans25 : function (component, event, helper) {
        var ans25 = component.find("question25").get("v.value");
        //alert('ans25>>>> '+ans25);
        if(ans25 == 'false'|| ans25 == 'true')
        {
            component.set('v.ques25','');
        }
        
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:ProductsQ25');
        cmpevent.setParams({"productsQ25":component.get('v.ques25')});
        cmpevent.fire();
        //----------------
        
        component.set("v.CompetingProducts26", ans25);
        var cmpevent = $A.get('e.c:IsproductsQ25checkbox');
        cmpevent.setParams({"IsproductsQ25checkbox":ans25});
        cmpevent.fire();
        
    },
    ans26 : function (component, event, helper)
    {
        var ans26 = component.find("question26").get("v.value");
        if(ans26 == 'false')
        {
            component.set('v.ques26','');
        }
        
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:ThirdPartyQ26');
        cmpevent.setParams({"ThirdPartyQ26":component.get('v.ques26')});
        cmpevent.fire();
        //----------------
        
        component.set("v.ThirdPartyContributions27", ans26);
        var cmpevent = $A.get('e.c:IsThirdparty26checkbox');
        cmpevent.setParams({"IsThirdparty26checkbox":ans26});
        cmpevent.fire();
    },
    
    
    checkboxSelect:function(component, event, helper)
    {
        var Answer3=component.find("boxPack").get("v.checked");
        if(Answer3 == false)
        {
            component.set('v.ques270','');
        }
        component.set("v.CheckboxNew", Answer3);
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:ReverseDetectionEvent');
        cmpevent.setParams({"ReverseDetectionEvent": component.get('v.ques270')});
        cmpevent.fire();
        //-----------------
        
        var cmpevent = $A.get('e.c:IsReverseDetectionEvent');
        cmpevent.setParams({"IsReverseDetectionEvent":Answer3});
        cmpevent.fire();
        //   alert("chckbox" + component.get("v.CheckboxNew"));
        
    },
    checkboxSelect1:function(component, event, helper)
    {
        var Ans=component.find("boxPack1").get("v.checked");
        if(Ans == false)
        {
            component.set('v.ques271','');
        }
        
        component.set("v.CheckboxNew1", Ans);
        
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:TestingTxtboxEvent27b');
        cmpevent.setParams({"TestingTxtboxEvent27b": component.get('v.ques271')});
        cmpevent.fire();
        //-----------------
        
        var cmpevent = $A.get('e.c:IsTestingcheckboxEvent27b');
        cmpevent.setParams({"IsTestingcheckboxEvent27b":Ans});
        cmpevent.fire();
        //   alert("chckbox" + component.get("v.CheckboxNew1"));
        
    },
    checkboxSelect2:function(component, event, helper)
    {
        var Anss=component.find("boxPack2").get("v.checked");
        if(Anss == false)
        {
            component.set('v.ques272','');
        }
        component.set("v.CheckboxNew2", Anss);
        
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:literatureTxtEvent27c');
        cmpevent.setParams({"literatureTxtEvent27c": component.get('v.ques272')});
        cmpevent.fire();
        //-----------------
        
        var cmpevent = $A.get('e.c:IsliteraturecheckboxEvent27c');
        cmpevent.setParams({"IsliteraturecheckboxEvent27c":Anss});
        cmpevent.fire();
        //  alert("chckbox" + component.get("v.CheckboxNew2"));
        
    },
    checkboxSelect3:function(component, event, helper)
    {
        var An=component.find("boxPack3").get("v.checked");
        component.set("v.ques273check", An);
        var cmpevent = $A.get('e.c:ImpossibleEvent');
        cmpevent.setParams({"ImpossibleEvent":An});
        cmpevent.fire();
        // alert("chckbox" + component.get("v.ques273check"));
        
    },
    checkboxSelect4:function(component, event, helper)
    {
        var Ann=component.find("boxPack4").get("v.checked");
        component.set("v.ques274check", Ann);
        var cmpevent = $A.get('e.c:DontknowEvent');
        cmpevent.setParams({"DontknowEvent":Ann});
        cmpevent.fire();
        //alert("chckbox" + component.get("v.ques274check"));
        
    },
    
    checkboxSelect5:function(component, event, helper)
    {
        var Aann=component.find("boxPack5").get("v.checked");
        if(Aann == false)
        {
            component.set('v.ques275','');
        }
        
        component.set("v.CheckboxNew5", Aann);
        
        //Added on 8/5/2020
        var cmpevent = $A.get('e.c:OtherTxtboxEvent27f');
        cmpevent.setParams({"OtherTxtboxEvent27f": component.get('v.ques275')});
        cmpevent.fire();
        //-----------------
        
        //    alert("chckbox" + component.get("v.CheckboxNew5"));
        var cmpevent = $A.get('e.c:IsOthercheckboxEvent27f');
        cmpevent.setParams({"IsOthercheckboxEvent27f":Aann});
        cmpevent.fire();
        
    },
    
    question11 :function(component, event, helper)
    {
        var que11=component.find("q1").get("v.value");
        component.set("v.que1", que11);
        //alert("que1" + component.get("v.que1"));
        //alert("length" + component.get("v.que1.length"));
        var cmpevent = $A.get('e.c:problemstatementQ11');
        cmpevent.setParams({"problemQ11":que11});
        cmpevent.fire();
    },
    
    question12:function(component, event, helper)
    {
        var que12 = component.find("q2").get("v.value");
        component.set("v.que2", que12);
        //alert("que1" + component.get("v.que2"));
        var cmpevent = $A.get('e.c:solutionQ12Event');
        cmpevent.setParams({"solutionQ12":que12});
        cmpevent.fire();
    },
    question13:function(component, event, helper)
    {
        var que13 = component.find("q3").get("v.value");
        component.set("v.que3", que13);
        //alert("que1" + component.get("v.que1"));
        var cmpevent = $A.get('e.c:FeatureQue13');
        cmpevent.setParams({"FeatureQue13":que13});
        cmpevent.fire();
    },
    question14:function(component, event, helper)
    {
        var que14 = component.find("q4").get("v.value");
        component.set("v.que4", que14);
        //   alert("que1" + component.get("v.que1"));
        var cmpevent = $A.get('e.c:AlternativeQue14');
        cmpevent.setParams({"AlternativeQue14":que14});
        cmpevent.fire();
    },
    quest21:function(component, event, helper)
    {
        var que21 = component.find("que21Id").get("v.value");
        component.set("v.ques21", que21);
        //alert(component.get('v.optionsvaluedefault')+ 'sdfds');
        
        //alert("prior submission text value" + component.get("v.ques21"));
        var cmpevent = $A.get('e.c:PriorsubmissionEvent21');
        cmpevent.setParams({"PriorsubmissionEvent21":que21});
        cmpevent.fire();
    },
    quest22:function(component, event, helper)
    {
        var que22 = component.find("que22Id").get("v.value");
        //alert('que22'+que22);
        component.set("v.ques22", que22);
        var cmpevent = $A.get('e.c:PublicDisclosure22');
        cmpevent.setParams({"PublicDisclosure22":que22});
        cmpevent.fire();
    },
    quest23:function(component, event, helper)
    {
        var que23 = component.find("que23Id").get("v.value");
        component.set("v.ques23", que23);
        //alert("que1" + que23);
        var cmpevent = $A.get('e.c:CommercialEvent23');
        cmpevent.setParams({"CommercialEvent23":que23});
        cmpevent.fire();
    },
    quest24:function(component, event, helper)
    {
        var que24 = component.find("que24Id").get("v.value");
        component.set("v.ques24", que24);
        //alert("que24" + que24);
        var cmpevent = $A.get('e.c:FutureEventQ24');
        //  alert('cmpevent:  '+cmpevent);
        cmpevent.setParams({"FutureEventQ24":que24});
        cmpevent.fire();
    },
    quest24added:function(component, event, helper)
    {
        var que24add = component.find("que24Idadded").get("v.value");
        component.set("v.q24added", que24add);
        // alert('que24add txtbox >> '+ que24add);
        var cmpevent = $A.get('e.c:ThirdPartyConfidentiality');
        cmpevent.setParams({"ThirdPartyConfidentiality":que24add});
        cmpevent.fire();
    },
    quest25:function(component, event, helper)
    {
        var que25 = component.find("que25Id").get("v.value");
        component.set("v.ques25", que25);
        //   alert("que1" + component.get("v.que1"));
        var cmpevent = $A.get('e.c:ProductsQ25');
        cmpevent.setParams({"productsQ25":que25});
        cmpevent.fire();
    },
    quest26:function(component, event, helper)
    {
        var que26 = component.find("que26Id").get("v.value");
        component.set("v.ques26", que26);
        //   alert("que1" + component.get("v.que1"));
        var cmpevent = $A.get('e.c:ThirdPartyQ26');
        cmpevent.setParams({"ThirdPartyQ26":que26});
        cmpevent.fire();
    },
    
    quest29 :function(component, event, helper)
    {
        var que29=component.find("q29").get("v.value");
        component.set("v.businessValue", que29);
        //alert("que29" + component.get("v.businessValue"));
        var cmpevent = $A.get('e.c:businessValueInventionEvent');
        cmpevent.setParams({"businessValueInvention":que29});
        cmpevent.fire();
    },
    
    setPublicDisclosureDate : function(component, event, helper)
    {
        var PublicDisDate = component.find("datein").get("v.value");
        
        /*if(PublicDisDate < component.get("v.futuredate"))
           {
           component.set("v.todaydate", '');
           component.set("v.storedate", ''); 
           component.set("v.validatedate",true);
           }
        else{
            component.set("v.validatedate",false);
        component.set("v.todaydate", PublicDisDate);
        component.set("v.storedate", PublicDisDate);
        var cmpevent = $A.get('e.c:PublicDisclosureDateEvent23Chk');
        cmpevent.setParams({"PublicDisclosureDate":component.get("v.todaydate")});
        cmpevent.fire();
             }
       */
        component.set("v.validatedate",false);
        component.set("v.todaydate", PublicDisDate);
        component.set("v.storedate", PublicDisDate);
        var cmpevent = $A.get('e.c:PublicDisclosureDateEvent23Chk');
        cmpevent.setParams({"PublicDisclosureDate":component.get("v.todaydate")});
        cmpevent.fire();
        
    },
    setEarliestUseDate : function(component, event, helper)
    {
        var EarlierUseDate1 = component.find("datein2").get("v.value");
        component.set("v.validateearlierusedate",false);
        component.set("v.todaydate2", EarlierUseDate1);
        component.set("v.storedate2", EarlierUseDate1);
        var cmpevent = $A.get('e.c:DateofEarliestUseEvent');
        cmpevent.setParams({"Dateofearliestuse":component.get("v.todaydate2")});
        cmpevent.fire();
        
    },
     setEarliestExternaluseDate : function(component, event, helper)
    {
        var EarliestExternalUseDate = component.find("datein3").get("v.value");
        component.set("v.validateEarliestExternalUsedate",false);
        component.set("v.todaydate3", EarliestExternalUseDate);
        component.set("v.storedate3", EarliestExternalUseDate);
        var cmpevent = $A.get('e.c:DateofEarliestExternalUseEvent');
        cmpevent.setParams({"DateofEarliestExternalUse":component.get("v.todaydate3")});
        cmpevent.fire();
    },
     setEarliestPlannedDate : function(component, event, helper)
    {
        var EarlierPlannedDate = component.find("datein4").get("v.value");
        component.set("v.validateEarliestPlannedUseDate",false);
        component.set("v.todaydate4", EarlierPlannedDate);
        component.set("v.storedate4", EarlierPlannedDate);
        var cmpevent = $A.get('e.c:DateofEarliestPlannedUseEvent');
        cmpevent.setParams({"EarliestPlanUseDate":component.get("v.todaydate4")});
        cmpevent.fire();
    },
        
    setExternalUseDes : function(component, event, helper)
    {
        var QuestExternalUse = component.find("que230Id").get("v.value");
        component.set("v.ques230", QuestExternalUse);
        //alert('tx'+QuestExternalUse);
        var cmpevent = $A.get('e.c:ExternalTxt230Event');
        cmpevent.setParams({"ExternalTxt230Event": QuestExternalUse});
        cmpevent.fire();
    },
    
    setReverseTxt : function(component, event, helper)
    {
        var QuestReverse = component.find("que270Id").get("v.value");
        //alert('tx'+QuestReverse);
        component.set("v.ques270", QuestReverse);
        //alert('tx'+QuestExternalUse);
        var cmpevent = $A.get('e.c:ReverseDetectionEvent');
        cmpevent.setParams({"ReverseDetectionEvent": QuestReverse});
        cmpevent.fire();
    },
    setTestingTxt : function(component, event, helper)
    {
        var QuestTesting = component.find("que271Id").get("v.value");
        component.set("v.ques271", QuestTesting);
        //alert('tx'+QuestExternalUse);
        var cmpevent = $A.get('e.c:TestingTxtboxEvent27b');
        cmpevent.setParams({"TestingTxtboxEvent27b": QuestTesting});
        cmpevent.fire();
    },
    
    setLiteratureTxt : function(component, event, helper)
    {
        var QuestLiterature = component.find("que272Id").get("v.value");
        component.set("v.ques272", QuestLiterature);
        //alert('tx'+QuestExternalUse);
        var cmpevent = $A.get('e.c:literatureTxtEvent27c');
        cmpevent.setParams({"literatureTxtEvent27c": QuestLiterature});
        cmpevent.fire();
    },
    
    setOtherTxt : function(component, event, helper)
    {
        var QuestOther = component.find("que275Id").get("v.value");
        component.set("v.ques275", QuestOther);
        //alert('tx'+QuestExternalUse);
        var cmpevent = $A.get('e.c:OtherTxtboxEvent27f');
        cmpevent.setParams({"OtherTxtboxEvent27f": QuestOther});
        cmpevent.fire();
    },
    
    setcheckboxesfromfooter : function(component, event, helper)
    {
        component.set('v.optionsvaluedefault',event.getParam("IsPrior"));
        component.set('v.publicDisclosurechk',event.getParam("IsPublic"));
        component.set('v.CurrentCommercial23',event.getParam("IsCommercial"));
        component.set('v.useExternal230',event.getParam("IsExternal"));
        component.set('v.FutureImplementation25',event.getParam("IsFuture"));
        component.set('v.CompetingProducts26',event.getParam("IsProduct"));
        component.set('v.ThirdPartyContributions27',event.getParam("IsThirdparty"));
        component.set('v.ThirdPartyConfidentiality24',event.getParam("IsThirdPartyConf"));
        //alert('PriorText'+event.getParam("PriorText"));
        component.set('v.ques21',event.getParam("PriorText"));
        //alert('ques21'+component.get('v.ques21'));
        component.set('v.ques22',event.getParam("PublicText"));
        component.set('v.ques23',event.getParam("CommercialText"));
        component.set('v.q24added',event.getParam("ThirdPartyConfiText"));
        component.set('v.ques24',event.getParam("FutureText"));
        component.set('v.ques230',event.getParam("ExternalText"));
        component.set('v.ques25',event.getParam("ProductText"));
        component.set('v.todaydate',event.getParam("PublicDate"));
        component.set('v.ques26',event.getParam("ThirdPartyText"));
        component.set('v.todaydate2',event.getParam("EarlierDate"));
        component.set('v.todaydate3',event.getParam("ExternalDate"));
        component.set('v.todaydate4',event.getParam("PlannedDate"));

        
    }
    
})