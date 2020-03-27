# Salesforce Trigger Framework

Trigger Handler based on Chris Aldridge's [Lightweight Apex Trigger Framework](https://github.com/ChrisAldridge/Lightweight-Trigger-Framework)

See Chris' original blog post: [Lightweight Apex Trigger Framework](http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/)

This repository is a simple trigger framework for bulkifying triggers and allowing for the encapsulation of complex logic.

---

[TOC]

## TriggerHandler Class

- Generic TriggerHandler for triggers
- Based on Chris Aldridge's [Lightweight Apex Trigger Framework](http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework)

``` csharp
/**
 * Generic TriggerHandler for triggers
 * Based on: http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
 *
 * @author Joseph Allen
 */
public with sharing class TriggerHandler {

    /**
     * Call this method from your trigger, passing in an instance of a trigger handler which implements TriggerHandler.IEvents
     * This method will fire the appropriate methods on the handler depending on the trigger context.
     * @param events IEvents interface
     */
    public static void execute(IEvents events) {
        // Check to see if the trigger has been disabled. If it has, return
        if (events.isDisabled()) {
            return;
        }

        switch on Trigger.operationType {

            when BEFORE_INSERT {
                events.beforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE {
                events.beforeUpdate(Trigger.newMap, Trigger.oldMap);
            }
            when BEFORE_DELETE {
                events.beforeDelete(Trigger.oldMap);
            }
            when AFTER_INSERT {
                events.afterInsert(Trigger.newMap);
            }
            when AFTER_UPDATE {
                events.afterUpdate(Trigger.newMap, Trigger.oldMap);
            }
            when AFTER_DELETE {
                events.afterDelete(Trigger.oldMap);
            }
            when AFTER_UNDELETE {
                events.afterUndelete(Trigger.oldMap);
            }
        }
    }

    /**
     * TriggerHandler Interface for trigger handlers
     * Based on: http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
     *
     * Interface containing methods Trigger Handlers must implement to enforce best practice
     * and bulkification of triggers.
     */
    public interface IEvents {
        boolean isDisabled();
        void beforeInsert(List<SObject> newItems);
        void beforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap);
        void beforeDelete(Map<Id, SObject> oldMap);
        void afterInsert(Map<Id, SObject> newMap);
        void afterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap);
        void afterDelete(Map<Id, SObject> oldMap);
        void afterUndelete(Map<Id, SObject> oldMap);
    }
}
```

## Example Files

### AccountTH Class

- Trigger handler using the TriggerHandler framework
- Based on Chris Aldridge's [Lightweight Apex Trigger Framework](http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework)

``` csharp
/**
 * Trigger handler using the TriggerHandler framework from
 * http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
 *
 * @author Joseph Allen
 */
public with sharing class AccountTH implements TriggerHandler.IEvents {

    // Allows unit tests (or other code) to disable this trigger for the transaction
    public static Boolean triggerDisabled = false;

    public Boolean isDisabled() {
        return false;
    }

    public void beforeInsert(List<SObject> newItems) {}

    public void afterInsert(Map<Id, SObject> newMap) {
        doFuture(newMap.keyset());
    }

    public void beforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {}

    public void afterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {}

    public void beforeDelete(Map<Id, SObject> oldMap) {}

    public void afterDelete(Map<Id, SObject> oldMap) {}

    public void afterUndelete(Map<Id, SObject> oldMap) {}

    @future
    private static void doFuture(Set<Id> newIds) {
        Account[] objs = [SELECT Id FROM Account WHERE Id IN : newIds];
        for (Account objCur : objs) {

        }
    }
}
```

### Account Trigger

- Trigger for Account
- Uses the TriggerHandler framework to handle logic
- Based on Chris Aldridge's [Lightweight Apex Trigger Framework](http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework)

``` csharp
/**
 * Trigger for Account
 * Uses the TriggerHandler framework to handle logic
 * Based on: http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
 *
 * @author Joseph Allen
 */
trigger Account on Account (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

    TriggerHandler.execute(new AccountTH());
}
```

### AccountTH_Test Test Class

- Example Test class for testing a trigger handler

``` csharp
/**
 * Test Class for AccountTH Trigger Handler
 *
 * @author Joseph Allen
 */
@isTest
private class AccountTH_Test {

    /**
     * Tests the Methods for the Handler
     * @return void
     */
    @isTest static void Main_Unit() {

        Account rec = new Account();
        rec.Name = 'Insert Test';
        insert rec;

        rec.Name = 'Update Test';
        update rec;

        delete rec;
        undelete rec;
    }
}
```
