//==================================================================================================================================
// GtkDialog.m
/*==================================================================================================================================
Copyright © 2013, Dillon Aumiller <dillonaumiller@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
==================================================================================================================================*/
#import "GtkNative.h"
#import <adenosine/adenosine.h>
#include <malloc.h>

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_DIALOG ((struct _GtkDialog *)_native)
#define DEFAULT_RESPONSE_PROPERTY @"adenosine-gtkDialog-defaultResonse"

//==================================================================================================================================
@implementation GtkDialog

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+dialog { return [[[self alloc] initDialog] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
-initDialog
{
  self = [super init];
  if(self)
  {
    _native = gtk_dialog_new();
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(GtkWidget *)actionArea
{
  void *nativeActionArea = gtk_dialog_get_action_area(NATIVE_DIALOG);
  if(!nativeActionArea) return nil;
  GtkWidget *actionArea = [GtkWidget nativeToWrapper:nativeActionArea];
  if(!actionArea) actionArea = [GtkWidget wrapExistingNative:nativeActionArea];
  return actionArea;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkWidget *)contentArea
{
  void *nativeContentArea = gtk_dialog_get_content_area(NATIVE_DIALOG);
  if(!nativeContentArea) return nil;
  GtkWidget *contentArea = [GtkWidget nativeToWrapper:nativeContentArea];
  if(!contentArea) contentArea = [GtkWidget wrapExistingNative:nativeContentArea];
  return contentArea;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(int)defaultResponse { return (int)(long)[self getProperty:DEFAULT_RESPONSE_PROPERTY]; }
-(void)setDefaultResponse:(int)defaultResponse
{
  [self setProperty:DEFAULT_RESPONSE_PROPERTY toValue:(void *)(long)defaultResponse];
  gtk_dialog_set_default_response(NATIVE_DIALOG, defaultResponse);
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(int)run { return gtk_dialog_run(NATIVE_DIALOG); }
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkWidget *)addButtonWithText:(OFString *)text andId:(int)idNumber
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  void *nativeButton = gtk_dialog_add_button(NATIVE_DIALOG, [text UTF8String], idNumber);
  [pool drain];
  return [GtkWidget wrapExistingNative:nativeButton];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)addButtons:(OFDictionary *)buttons
{
  __block struct _GtkDialog *nativeRef = NATIVE_DIALOG;
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [buttons enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop)
  {
    gtk_dialog_add_button(nativeRef, [(OFString *)object UTF8String], [(OFNumber *)key intValue]);
  }];
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)addActionWidget:(GtkWidget *)child withId:(int)idNumber
{
  gtk_dialog_add_action_widget(NATIVE_DIALOG, child.native, idNumber);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)addActionWidgets:(OFDictionary *)children
{
  __block struct _GtkDialog *nativeRef = NATIVE_DIALOG;
  [children enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop)
  {
    gtk_dialog_add_action_widget(nativeRef, ((GtkWidget *)object).native, [(OFNumber *)key intValue]);
  }];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setButtonOrder:(OFArray *)ids
{
  //this is stupid and annoying, as it relies on a GtkSettings app-wide setting that affects everything else besides us...
  //if this function alone did what one would think, it would be nice... :|
  int count = (int)ids.count;
  int *ints = (int *)malloc(sizeof(int) * count);
  for(int i=0; i<count; i++)
    ints[i] = [(OFNumber *)[ids objectAtIndex:i] intValue];
  gtk_dialog_set_alternative_button_order_from_array(NATIVE_DIALOG, count, ints);
  free(ints);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
