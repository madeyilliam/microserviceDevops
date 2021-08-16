trigger SDO_OMS_Shipment on Shipment (after insert) {
    if(System.isBatch()) return;
    if(trigger.isAfter && trigger.isInsert){

        Shipment []newShipment = Trigger.new;
        SDO_FSL_blogic_Shipment_CreateTransfer.InsertAfter(newShipment);
        }
     
    }