@IsTest
public class TempTestclass {
    
     @IsTest
    static void generalTests() {
        
          tempbatchclone up= new tempbatchclone();
        database.executeBatch(up,10000);
        
          tempbatch uptemp= new tempbatch();
        database.executeBatch(uptemp,10000);
        
         PatentroleBatchcls PR= new PatentroleBatchcls();
        database.executeBatch(PR,10000);
         tempbatch2 up2= new tempbatch2();
        database.executeBatch(up2,10000);
        RefreshRolesCntrl.finish();
        TrademarkpatentController.magicMethod();
        TrademarkDisputecontroller.magicMethod();
    }

}