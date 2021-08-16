({
    getRecordCounts: function(component, object_name){
        let self = this;
        
        return new Promise(
            $A.getCallback(function(resolve, reject){
                let action = component.get('c.getRecordCounts')
                
                action.setParams({
                    object_name: object_name
                })
                
                action.setCallback(this, function(result){
                    let state = result.getState();
                    let returned_value = result.getReturnValue();
                    let error = result.getError();
                    
                    if(state != 'SUCCESS') reject(error)
                    
                    resolve({
                        object_name: object_name,
                        count: returned_value
                    })
                })
                
                $A.enqueueAction(action)
            })
        )
    },
	getData : function(component) {
        let self = this;
        
        return new Promise(
            $A.getCallback(function(resolve, reject){
                let action = component.get('c.loadData')
                
                action.setCallback(this, function(result){
                    let state = result.getState();
                    let returned_value = result.getReturnValue();
                    let error = result.getError();
                    
                    if(state != 'SUCCESS') reject(error)
                    
                    component.set('v.csv_data', returned_value);
                    
                    resolve()
                })
                
                $A.enqueueAction(action)
            })
        )
	},
    formatData: function(component, object_name){
        let self = this;
        
        return new Promise(
            $A.getCallback(function(resolve, reject){
                let formatted_data = [];
                let data = component.get('v.csv_data');
                let rows = data.split(/\r\n|\n|\r/);
                let headers_row = rows.shift();
                let object_keys = headers_row.split(',');
                
                rows.map(function(row){
                    let column = row.split(',');
                    let created_date = new Date();
                    let hour = column[5].substring(0,2);
                    let minute = column[5].substring(3,5);
                    let second = column[5].substring(6,8);
                    
                    created_date = created_date.setDate(created_date.getDate() + parseInt(column[4]));
                    
                    formatted_data.push({
                        sobjectType: object_name,
                        CreatedDate: new Date(created_date).toISOString(),
                        Region__c: column[0],
                        Skill__c: column[1],
                        Custom__c: column[2],
                        Handle_Time__c: column[3]
                    });
                })
                
                resolve(formatted_data);
            })
        )
    },
    createData: function(component, data){
        let self = this;
        
        return new Promise(
            $A.getCallback(function(resolve, reject){
                let action = component.get('c.createData')
                
                action.setParams({
                    data:data
                })
                
                action.setCallback(this, function(result){
                    let state = result.getState();
                    let returned_value = result.getReturnValue();
                    let error = result.getError();
                    
                    if(state != 'SUCCESS') reject(error)
                    
                    resolve()
                })
                
                $A.enqueueAction(action)
            })
        )
    },
    getRecordIds: function(component, object_name){
        let self = this;
        
        return new Promise(
            $A.getCallback(function(resolve, reject){
                let action = component.get('c.getRecordIds')
                
                action.setCallback(this, function(result){
                    let state = result.getState();
                    let returned_value = result.getReturnValue();
                    let error = result.getError();
                    
                    if(state != 'SUCCESS') reject(error)
                    
                    resolve()
                })
                
                $A.enqueueAction(action)
            })
        )
    },
    deleteRecords: function(component, object_name, query_offset){
        let self = this;
        
        return new Promise(
            $A.getCallback(function(resolve, reject){
                let action = component.get('c.deleteData')
                
                action.setParams({
                    object_name: object_name,
                    query_offset: query_offset
                })
                
                action.setCallback(this, function(result){
                    let state = result.getState();
                    let returned_value = result.getReturnValue();
                    let error = result.getError();
                    
                    if(state != 'SUCCESS') reject(error);
                    
                    resolve()
                })
                
                $A.enqueueAction(action)
            })
        )
    },
    toggleLoading: function(component){
        let self = this;
        
        return new Promise(
            $A.getCallback(function(resolve, reject){
                component.set('v.is_loading',!component.get('v.is_loading'));
                resolve()
            })
        )
    }
})