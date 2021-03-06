# Salesforce Trigger Framework

Trigger Handler based on Chris Aldridge's [Lightweight Apex Trigger Framework](https://github.com/ChrisAldridge/Lightweight-Trigger-Framework)

See Chris' original blog post: [Lightweight Apex Trigger Framework](http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/)


Below are few things to keep in mind while implementing the framework and in general best practises.

## Naming Convention

* All the triggers should follow a consistent naming standard of SobjectName followed by keyword Trigger i.e. SojectNameTrigger. For example a trigger on Contact object should be named as ContactTrigger.
* All the trigger handlers should be named as TriggerName followed by keyword Handler. For example for Contact trigger, the handler should be named as ContactTriggerHandler.
* All the test classes should be  named as TriggerName followed by Test keyword. For example for ContactTrigger the test class should be declared as ContactTriggerTest.
* None of the components in the framework should contain org name or app name.

## Metadata Type
This package will create an mdt called Trigger Settings.   This mdt contains common levers to control the trigger handler functionality.  
* Trigger Settings Name = Name of the Trigger
* isActive = Determines if the trigger is execute.  This should be read from the IsDisabled() funtion of the Trigger Handler class.
* ObjectName = SObject Type of the Trigger
* Recursion Check = Can be used to control recursion if needed.
* Max Loop Count = Used to control recursion if needed.

## Custom Permission
This package creates a Custom Permission called Bypass Trigger.  Check the user for this permission in the IsDisabled funtion to bypass the trigger. Use the FeatureManagment.CheckPermission method.
```java
FeatureManagment.CheckPermission(Bypass_Trigger);
```
## Create a Trigger Handler
Create a single trigger handler class for each object.  This class will implement the Trigger Handler interface provided.  Add logic to retrieve the Custom Metadata record for that trigger as well has handle the IsDisabled flag.  For example, the Trigger Handler for Account would look like this:
```java
public class AccountTriggerHandler implements ITriggerHandler
{
	/* This class implements ITriggerHander. This sample shows how to 
	 * retrieve the metadata type and set the isDisabled flag
	*/
    public Trigger_Settings__mdt triggerMeta = new Trigger_Settings__mdt();
    
    //create a constructor to get the metadatatype
    public AccountTriggerHandler() {
          //Retrive the metadata type
    	triggerMeta = [Select DeveloperName, isActive__c, ObjectName__c, Recursion_Check__c, Max_Loop_Count__c from Trigger_Settings__mdt where DeveloperName='Account_Trigger' LIMIT 1] ; 
    
    }
    
    //read the custom metadata and look for the customer permission
    public Boolean IsDisabled()
    {
		// return IsDisabled= true if the metadata setting isActive = false or
		// the user has the Bypass Trigger custom permission
        if (!triggerMeta.isActive__c || FeatureManagement.checkPermission('Bypass_Trigger')) 
        	return false;
        else 
        	return true;
    } 
 
    public void BeforeInsert(List<SObject> newItems) {
        
    }
 
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {

            system.debug('Before Update for Account');
    
    }
 
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
 
    public void AfterInsert(Map<Id, SObject> newItems) {}
 
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
 
    public void AfterDelete(Map<Id, SObject> oldItems) {}
 
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
}
```
## Create One Trigger
Create one trigger on an object.  Include every trigger event.  Call the Trigger Dispatcher run() method.  For example, a Account trigger would look like this:
```java
trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    TriggerDispatcher.Run(new AccountTriggerHandler());
}
```

