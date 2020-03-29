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