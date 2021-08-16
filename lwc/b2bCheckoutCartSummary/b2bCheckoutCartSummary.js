import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import COMMUNITYID from "@salesforce/community/Id";
import CURRENCY from '@salesforce/i18n/currency';

// LABELS
import checkoutSummary from "@salesforce/label/c.B2B_SPC_Checkout_Summary_Header";
import subtotal from "@salesforce/label/c.B2B_SPC_Checkout_Subtotal";
import estimatedShipping from "@salesforce/label/c.B2B_SPC_Checkout_Estimated_Shipping";
import estimatedTax from "@salesforce/label/c.B2B_SPC_Checkout_Estimated_Tax";
import total from "@salesforce/label/c.B2B_SPC_Checkout_Total";
import processingErrorTitle from "@salesforce/label/c.B2B_SPC_Processing_Error";
import altPleaseWait from "@salesforce/label/c.B2B_SPC_Please_Wait";

export default class B2bCheckoutCartSummary extends LightningElement {

    // Custom Labels
    labels = {
        toast: {
            processingErrorTitle: processingErrorTitle
        },
        component: {
            checkoutSummary: checkoutSummary
            , subtotal: subtotal
            , estimatedTax: estimatedTax
            , estimatedShipping: estimatedShipping
            , total: total
            , altPleaseWait: altPleaseWait
        }
    };

    communityId = COMMUNITYID;
    currency = CURRENCY;

    @api effectiveAccountId;
    @api cartId;
    @api webstoreId;
    @api useDefaultTaxRate;
    @api hideCartSummarySection;

    @api subtotal = 0.00;
    @api estShipping = 0.00;
    @api estTax = 0.00;
    @api total = 0.00;
    @api currency = CURRENCY;

}