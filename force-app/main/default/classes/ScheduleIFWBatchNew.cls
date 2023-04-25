global class ScheduleIFWBatchNew implements Schedulable {
     global void execute(SchedulableContext SC) 
    {
        Integer ScopeSize = 1;
        GetIFWDataBatch service = new GetIFWDataBatch(); 
        Database.executeBatch(service, ScopeSize);
   }

}