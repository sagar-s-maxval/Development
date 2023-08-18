public class HrIntegrationScheduleClass implements Schedulable {
    public void execute(SchedulableContext ctx) {
        HRIntegrationBatch hr = new HRIntegrationBatch();
        database.executebatch(hr);
        
    }
}