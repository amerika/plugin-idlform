FarCry form plugin
==================

## Overview

With this plugin you can let users of FarCry add custom forms to their websites. Each form submission will be emailed to an address that is defined for each form, as well as being logged and available from the FarCry webtop.

## Documentation

No documentation for the time being, but please contact dev@amerika.no if you should have any questions.

## Requirements
* FarCry 7.0 or newer
* Coldfusion 9+ (tested) or Railo 3.3+ (not tested)

No documentation for the time being, but please contact dev@amerika.no if you should have any questions.


## Installation Notes for FarCry 7.0

Go to your project www folder and edit farcryConstructor.cfm, add idlform to THIS.plugins. E.g.:

    <cfset THIS.plugins = "farcrycms" />  

Change this to include idlform:

    <cfset THIS.plugins = "farcrycms,idlform" /> 

Update your application scope and deploy the database schema changes.

## License
This plugin is open-source under the GNU LESSER GENERAL PUBLIC LICENSE V3
