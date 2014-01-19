rivet
=====

A 2-way binding framework for iOS inspired by AngularJS. Still very alpha.

First you need to set the objects you want to bind to your view on the scope. In your view controller add:

    #import "Rivet.h"

Then set objects to the scope with:

    [self.scope setObject:loggedInUser forKey:@"loggedInUser"];
   

Tell the framework to bind a label by setting it's text property in interface builder to the keypath you're after. 
e.g. {{ loggedInUser.emailAddress }} 

if you want to bind a UITextField in Interface Builder select the field, open the Identitiy Inspector then add a User Defined Runtime Attribute like below:

    -------------------------------------------------
    | Key Path | Type   | Value                     |
    -------------------------------------------------
    | model    | String | loggedInUser.emailAddress |
    -------------------------------------------------
