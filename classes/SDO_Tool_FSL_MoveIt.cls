public class SDO_Tool_FSL_MoveIt {
    
    @InvocableMethod
    public static list<string> MoveIt (list<Inputs> myInputList) {
        point oldlocation = new point(myInputList[0].inoldlat,myInputList[0].inoldlong);
        point newlocation = new point(myInputList[0].innewlat,myInputList[0].innewlong);
        id tid = myInputList[0].interritoryID;       
        list<string> resultsstring = new list<string>();  
        list<integer> successCodes = new list<integer>();
        resultsstring.add('success');
        
SDO_Tool_FSLDemoTools_BatchUpdateLoc batch = new SDO_Tool_FSLDemoTools_BatchUpdateLoc('ServiceTerritoryMember',tid,oldLocation,newlocation); 
Database.executeBatch(batch);          

        return resultsstring;
        
        }
        
        
    public class Inputs {        
        @InvocableVariable
        public string interritoryID;
        @InvocableVariable
        public double inoldlat;
        @InvocableVariable
        public double inoldlong;  
        @InvocableVariable
        public double innewlat;
        @InvocableVariable
        public double innewlong;          
        }
}