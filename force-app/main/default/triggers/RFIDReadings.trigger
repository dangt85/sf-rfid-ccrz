trigger RFIDReadings on RFIDReading__e (after insert) {
    Set<String> tagIds = new Set<String>();
    for(RFIDReading__e reading : Trigger.new) {
        tagIds.add(reading.TagId__c);
    }

    List<ccrz__E_Product__c> matchingProducts = [SELECT Id FROM ccrz__E_Product__c WHERE ccrz__SKU__c IN :tagIds];

    ccrz__E_Cart__c cart = [SELECT Id FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c = '9251a8c2-a8cb-45e3-8cd9-141933829ead'];

    List<ccrz__E_CartItem__c> items = new List<ccrz__E_CartItem__c>();

    for(ccrz__E_Product__c product : matchingProducts) {
        items.add(new ccrz__E_CartItem__c(
            ccrz__Cart__c = cart.Id,
            ccrz__Product__c = product.Id
        ));
    }

    if(!items.isEmpty()) insert items;
}