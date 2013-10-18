FarCry form plugin
==================

** Overview

With this plugin you can let users of FarCry add custom forms to their websites. Each form submission will be emailed to an address that is defined for each form, as well as being logged and available from the FarCry administration.
Documentation

No documentation for the time being, but please contact trond@idl.no if you should have any questions.
You can watch a introduction video here

** License
This plugin is open-source under the GNU GENERAL PUBLIC LICENSE

** Installation Notes for FarCry 6.0
Go to your project www folder and edit farcryConstructor.cfm, add idlform to THIS.plugins. E.g:
<cfset THIS.plugins = "farcrycms" />  
Change this to include idlform:
<cfset THIS.plugins = "farcrycms,idlform" /> 
Update your application scope and deploy the database schema changes.
