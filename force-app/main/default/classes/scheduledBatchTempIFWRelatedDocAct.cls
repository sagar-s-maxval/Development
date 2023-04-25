global class scheduledBatchTempIFWRelatedDocAct implements Schedulable {
    global void execute(SchedulableContext SC) {
        /*BatchTempIFWRelatedDocAct cls = NEW BatchTempIFWRelatedDocAct();
        database.executeBatch(cls, 1);*/
        datetime dtStampToday = system.now();
        DAReport__c DAReport = DAReport__c.getInstance(userinfo.getprofileid());
        integer hrsFrom = 0;
        if(DAReport.No_of_Days__c != null || DAReport.No_of_Days__c > 0)
        {
            hrsFrom = Integer.valueOf(DAReport.No_of_Days__c) * 24;
        }
        else
            hrsFrom  = 24;
        datetime dtStampYesterday = dtStampToday.addHours(-hrsFrom );
        BatchTempIFWRelatedDocAct1 cls = NEW BatchTempIFWRelatedDocAct1(dtStampYesterday,dtStampToday);
        database.executeBatch(cls, 1);
    }
}