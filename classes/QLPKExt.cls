public with sharing class QLPKExt {

	public QLPKExt(Apexpages.Standardcontroller controller){
	}

    @RemoteAction
    public static List<Account> queryChunk(String firstId, String lastId, Boolean isLast) {
		
		//last Id range uses <=, all others use <
		String lastClause = 'AND Id < \''+ lastId +'\'  ';
		if (isLast) {
			lastClause = 'AND Id <= \''+ lastId +'\'  ';	
		}		
		
		String SOQL =  	'SELECT Id, Name ' +
						'FROM Account ' +
						'WHERE Id >= \'' + firstId + '\' ' +
						lastClause;
						
		return database.query(SOQL);
    }    



    
}