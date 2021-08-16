import { LightningElement, track, wire } from 'lwc';
import getObjectApiNames from '@salesforce/apex/SkewSelectController.getObjectApiNames';
import createSkewMetadataRecords from '@salesforce/apex/SkewSelectController.createSkewMetadataRecords';
import queueJobs from '@salesforce/apex/SkewSelectController.queueJobs';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SkewSelectComponent extends NavigationMixin(LightningElement) {

    progress = 0;
    @track objectApiNames = [];
    selected = [];
    objSearch = '';
    filteredObjects = [];
    isAllObjects = false;
    showDropdown = false;
    error;

    @wire(getObjectApiNames)
    wiredObjList({data,error}){
        if(data){
            this.objectApiNames = data.map(item => {
                return { label: item, value: item, isVisible: true, selected: false }
            });
            this.error=undefined;
        }else if(error){
            this.error=error;
            this.objectApiNames=undefined;
        }
    }

    // connectedCallback() {
    //     getObjectApiNames()
    //         .then(result => {
    //             this.objectApiNames = result.map(item => {
    //                 return { label: item, value: item, isVisible: true, selected: false }
    //             })
    //         })
    //         .catch(error => {
    //             this.error = error;
    //         });
    // }

    get enableSubmit() {
        return Boolean(this.selected.length > 0 || this.isAllObjects);
    }

    async handleClick() {
        try {
            const chunkSize = 5;
            let allObjs = [];
            let step;
            let arrOfPromises=[];

            if (this.isAllObjects) {
                allObjs = this.objectApiNames
                    .map((obj) => obj.label);
                step = 100 / Math.ceil(allObjs.length / chunkSize);
            } else {
                step = 100 / Math.ceil(this.selected.length / chunkSize);
                allObjs = [...this.selected];
              }

            while (allObjs.length > 0) {
                // arrOfPromises.push(createSkewMetadataRecords({ masterObjLst: allObjs.splice(0, chunkSize) }));
                await createSkewMetadataRecords({ masterObjLst: allObjs.splice(0, chunkSize) })
                this.progress += step;
            }
            // await this.allProgress(arrOfPromises,
            //     (p) => {
            //         console.log(`% Done = ${p.toFixed(2)}`);
            //         this.progress = p.toFixed(2);
            //     });
            this.navigateToObjectHome('Skew_Metadata__c');
        } catch (e) {
            this.showNotification('Error', e?.body?.message, 'error');
        }
    }

    // allProgress(proms, progress_cb) {
    //     let step = 0;
    //     progress_cb(0);
    //     for (const p of proms) {
    //         p.then(() => {
    //             step++;
    //             progress_cb((step * 100) / proms.length);

    //         });
    //     }
    //     return Promise.all(proms);
    // }
    
    navigateToObjectHome(objectApiName) {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: objectApiName,
                actionName: 'list',
            },
            state: {
                filterName: 'All'
            }
        });
    }

    filterObjects(event) {
        this.showDropdown = true;
        let objName = event.target.value;
        for (let obj of this.objectApiNames) {
            if (obj.label.toLowerCase().startsWith(objName.toLowerCase()) || obj.label.toLowerCase().endsWith(objName.toLowerCase())) {
                obj.isVisible = true;
            } else {
                obj.isVisible = false;
            }
        }
    }

    selectItem(event) {
        let selectedVal = event.currentTarget.dataset.id;
        for (let obj of this.objectApiNames) {
            if (obj.label === selectedVal) {
                if (!obj.selected) {
                    obj.selected = true;
                    this.selected.push(selectedVal);
                } else {
                    obj.selected = false;
                    this.selected = this.selected.filter(
                        (obj) => obj !== selectedVal
                    );
                }
            }
        }
        event.preventDefault();
    }

    // hideDropdown() {
    //     this.filteredObjects = [];
    // }

    // addObjects(event) {
    //     this.hideDropdown();
    //     let val = event.target.dataset.name;
    //     this.selected.push(val);
    // }

    removeObj(event) {
        let val = event.currentTarget.dataset.index;
        this.selected = this.selected.filter(
            (obj) => obj !== val
        );

        for (let obj of this.objectApiNames) {
            if (obj.label === val) {
                obj.selected = false;
            }
        }
    }

    clearFocus() {
        this.showDropdown = false;
    }

    checkboxHandler(event) {
        if (event.target.checked) {
            this.filteredObjects = [];
            this.selected = [];
            this.isAllObjects = true;
        } else {
            this.isAllObjects = false;
            for (let obj of this.objectApiNames) {
                obj.selected=false;
            }
        }
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    async handleRun() {
        try {
            await queueJobs({ listOfObjs: this.selected });
            this.navigateToObjectHome('Skew_Result__c');
        } catch (e) {
            this.showNotification('Error', e?.body?.message, 'error');
        }
    }

}