//
//  Binding.h
//  Rivet
//
//  Created by Aaron Signorelli on 21/01/2014.
//  Copyright (c) 2014 Five Heads. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Binding : NSObject

@property(nonatomic, weak) NSObject *view; //Can be anything really but normally we want a UIView
@property(nonatomic, readonly) id model;

//Moustache template to render.
// e.g. set this if you've a label you want to change when a model changes.
@property(nonatomic, retain) NSString *template;

//Similar to the template but only contains one key path (a template can have many) and doesn't use curly braces
// e.g. set this if you want to bind an ImageView image name to a model property set this to image.name and set the modelKeyPath
@property(nonatomic, retain) NSString *viewPropertyKeyPath; //The key path of the object to update. i.e. textLabel.text         model -> view

//The path to update on the model. i.e. loggedInUser.emailAddress.         view -> model
// e.g.set this if you're binding a TextField to a model
@property(nonatomic, retain) NSString *modelKeyPath;

// A value to use when the model is empty. This could be an empty string for TextFields or a float for sliders
@property(nonatomic, retain) id defaultValue; 

+(Binding *) bindingWithTemplate:(NSString *)template;
+(Binding *) watchModelKeyPath:(NSString *) aKeyPath;
+(Binding *) whenTemplate:(NSString *)template requiresRenderingUpdateTheViewProperty:(NSString *)viewPropertyKeyPath;


-(NSString *) renderTemplateWithError:(NSError **)error;
-(void) viewDidUpdate; //Call when a user enters text / slides a slider etc
-(void) modelDidUpdate;

-(void) attachModel:(id)aModel;
-(void) detachModel;

-(NSArray *) keyPathsInTemplate;

@end