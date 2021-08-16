({
	init : function(component, event, helper) {
        Promise.all([
            helper.getRecordCounts(component,'Case_History__c'),
            helper.getRecordCounts(component,'Chat_History__c'),
            helper.getRecordCounts(component,'Voice_Call_History__c')
        ])
        .then(function(results){
            let record_count_map = {}
           	results.map(function(result){
                record_count_map[result.object_name] = result.count;
            })
            
            component.set('v.record_counts', record_count_map)
            component.set('v.case_count', record_count_map.Case_History__c);
            component.set('v.chat_count', record_count_map.Chat_History__c);
            component.set('v.call_count', record_count_map.Voice_Call_History__c);
        })
        .then(function(){
            return helper.getData(component);
        })
        .finally(function(){
            component.set('v.is_loading',false);
        })
	},
    loadCases: function(component, event, helper){
        helper.toggleLoading(component)
        .then(function(){
            return helper.formatData(component, 'Case_History__c')
        })
        .then(function(data){
            let promises = [];
            let dml_limit = 10000;
            let batches = Math.ceil(data.length/dml_limit);
            
            for(let current_batch = 0; current_batch < batches; current_batch++){
                promises.push(
                    helper.createData(component,data.slice(current_batch*dml_limit,(current_batch+1)*parseInt(dml_limit)-1))
                )
            }
            
            return Promise.all(promises);
        })
        .then(function(){
            return helper.getRecordCounts(component,'Case_History__c');
        })
        .finally(function(){
            return helper.toggleLoading(component)
        })
    },
    loadChats: function(component, event, helper){
        
        helper.toggleLoading(component)
        .then(function(){
            return helper.formatData(component, 'Chat_History__c')
        })
        .then(function(data){
            let promises = [];
            let dml_limit = 10000;
            let batches = Math.ceil(data.length/dml_limit);
            
            for(let current_batch = 0; current_batch < batches; current_batch++){
                promises.push(
                    helper.createData(component,data.slice(current_batch*dml_limit,(current_batch+1)*parseInt(dml_limit)-1))
                )
            }
            
            return Promise.all(promises);
        })
        .then(function(){
            return helper.getRecordCounts(component,'Chat_History__c');
        })
        .then(function(count_result){
            component.set('v.chat_count',count_result.count)
        })
        .finally(function(){
            return helper.toggleLoading(component)
        })
    },
    loadCalls: function(component, event, helper){
        
        helper.toggleLoading(component)
        .then(function(){
            return helper.formatData(component, 'Voice_Call_History__c')
        })
        .then(function(data){
            let promises = [];
            let dml_limit = 10000;
            let batches = Math.ceil(data.length/dml_limit);
            //console.log('batches',batches);
            
            for(let current_batch = 0; current_batch < batches; current_batch++){
                //console.log(current_batch*dml_limit,(current_batch+1)*parseInt(dml_limit)-1);
                promises.push(
                    helper.createData(component,data.slice(current_batch*dml_limit,(current_batch+1)*parseInt(dml_limit)-1))
                )
            }
            
            return Promise.all(promises);
        })
        .then(function(){
            return helper.getRecordCounts(component,'Voice_Call_History__c');
        })
        .then(function(count_result){
            component.set('v.call_count',count_result.count)
        })
        .finally(function(){
            return helper.toggleLoading(component)
        })
    },
    deleteCases: function(component, event, helper){
        let object_name = 'Case_History__c';
        let promises = [];
        let dml_limit = 10000;
        let record_count = component.get('v.case_count');
        let batches = Math.ceil(record_count/dml_limit);
        
        for(let current_batch = 0; current_batch < batches; current_batch++){
            promises.push(helper.deleteRecords(component, object_name, current_batch * dml_limit));
        }
        
        console.log('batches', batches);
        
        helper.toggleLoading(component)
        
        Promise.all(promises)
        .then(function(){
            component.set('v.case_count', 0);
        })
        .finally(function(){
            return helper.toggleLoading(component)
        })
    },
    deleteChats: function(component, event, helper){
        let object_name = 'Chat_History__c';
        let promises = [];
        let dml_limit = 10000;
        let record_count = component.get('v.chat_count');
        let batches = Math.ceil(record_count/dml_limit);
        
        for(let current_batch = 0; current_batch < batches; current_batch++){
            promises.push(helper.deleteRecords(component, object_name, current_batch * dml_limit));
        }
        
        console.log('batches', batches);
        
        helper.toggleLoading(component)
        
        Promise.all(promises)
        .then(function(){
            component.set('v.chat_count', 0);
        })
        .finally(function(){
            return helper.toggleLoading(component)
        })
    },
    deleteCalls: function(component, event, helper){
        let object_name = 'Voice_Call_History__c';
        let promises = [];
        let dml_limit = 10000;
        let record_count = component.get('v.call_count');
        let batches = Math.ceil(record_count/dml_limit);
        
        for(let current_batch = 0; current_batch < batches; current_batch++){
            promises.push(helper.deleteRecords(component, object_name, current_batch * dml_limit));
        }
        
        console.log('batches', batches);
        
        helper.toggleLoading(component)
        
        Promise.all(promises)
        .then(function(){
            component.set('v.call_count', 0);
        })
        .finally(function(){
            return helper.toggleLoading(component)
        })
    }
})