# Salesforce Trigger Framework

## Why should I use a Trigger Framework?

A trigger framework is a way to remove the logic from your triggers and enforce consistency across the platform. The framework itself will do the heavy lifting in terms of figuring out which kind of trigger is currently running and firing the correct logic.  Few advantages of using the framework are: 
* Removing trigger logic from the trigger makes unit testing and maintenance much easier.
* Standardizing triggers means all of your triggers work in a consistent way.
* A single trigger per object gives full control over order of execution.
* Prevention of trigger recursion. 
* It makes it easy for large teams of developers to work across an org with lots of triggers. 

## How the new Trigger Framework  works?
* The framework should be easy to understand. Any developer should be able to see how the framework works without having to read through a load of boilerplate code and comments.
* A single handler per object to handle all events in bulkified form (no need for single record implementations).
* An interface for the trigger handlers to enforce consistency.
* Need the ability to switch off triggers. This ability must be enforced on every trigger.
* Initial implementation of the framework on a new org needs to be extremely simple.
* Despite the framework being lightweight, it needs to be extensible so that it can be added to as the requirements of the org grow.
* Developers only need to worry about writing their trigger handler class. They don't need to change or even understand the underlying logic of the framework itself (no need to put a new IF statement in a TriggerHandlerFactory class, for example).

## Below are the key elements of this framework

![ERD](https://github.com/GSA/sf-trigger-framework/blob/master/ERD.png)

## How to Use the new framework


## Naming Convention

* All the triggers should follow a consistent naming standard of SobjectName followed by keyword Trigger i.e. SojectNameTrigger. For example a trigger on Contact object should be named as ContactTrigger.
* All the trigger handlers should be named as TriggerName followed by keyword Handler. For example for Contact trigger, the handler should be named as ContactTriggerHandler.
* All the test classes should be  named as TriggerName followed by Test keyword. For example for ContactTrigger the test class should be declared as ContactTriggerTest.
* None of the components in the framework should contain org name or app name.
