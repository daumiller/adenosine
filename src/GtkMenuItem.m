//==================================================================================================================================
// GtkMenuItem.m
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

//==================================================================================================================================
#define NATIVE_WIDGET   ((struct _GtkWidget   *)_native)
#define NATIVE_MENUITEM ((struct _GtkMenuItem *)_native)

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_Activated(struct _GtkMenuItem *menuItem, void *data)
{
  GtkMenuItem *obj = (GtkMenuItem *)[GtkWidget nativeToWrapper:(void *)menuItem];
  [obj onActivated];
}

//==================================================================================================================================
@implementation GtkMenuItem

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ menuItem                            { return [[[self alloc] initMenuItem      ] autorelease]; }
+ menuItemWithText:(OFString *)text   { return [[[self alloc] initWithText:text ] autorelease]; }
+ menuItemWithAccel:(OFString *)text  { return [[[self alloc] initWithAccel:text] autorelease]; }
+ menuItemWithAccel:(OFString *)text andDelegate:(id)delegate
{
  return [[[self alloc] initWithAccel:text andDelegate:delegate] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- initMenuItem
{
  self = [super init];
  if(self)
  {
    _native = gtk_menu_item_new();
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithText:(OFString *)text
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_menu_item_new_with_label([text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithAccel:(OFString *)text
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_menu_item_new_with_mnemonic([text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithAccel:(OFString *)text andDelegate:(id)delegate
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_menu_item_new_with_mnemonic([text UTF8String]);
    [self installNativeLookup];
    self.delegate = delegate;
    [pool drain];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  self.submenu = nil;
  [super dealloc];
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(OFString *)text { return [OFString stringWithUTF8String:gtk_menu_item_get_label(NATIVE_MENUITEM)]; }
-(void)setText:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_menu_item_set_label(NATIVE_MENUITEM, [text UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)textIsAccel                      { return gtk_menu_item_get_use_underline(NATIVE_MENUITEM);       }
-(void)setTextIsAccel:(BOOL)textIsAccel { gtk_menu_item_set_use_underline(NATIVE_MENUITEM, textIsAccel); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkWidget *)submenu { return _submenu; }
-(void)setSubmenu:(GtkWidget *)submenu
{
  [_submenu release];
  _submenu = [submenu retain];
  gtk_menu_item_set_submenu(NATIVE_MENUITEM, [_submenu native]);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setDelegate:(id)delegate
{
  [super setDelegate:delegate];
  
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkMenuItemActivated:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "activate", G_CALLBACK(ConnectionProxy_Activated),NULL)]];
  }
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)addHotkey:(unsigned int)keyCode withModifiers:(GtkModifier)modifiers toWindow:(GtkWindow *)window
{
  gtk_widget_add_accelerator(NATIVE_WIDGET, "activate", window.hotkeyId, keyCode, (GdkModifierType)modifiers, GTK_ACCEL_VISIBLE);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)removeHotkey:(unsigned int)keyCode withModifiers:(GtkModifier)modifiers fromWindow:(GtkWindow *)window
{
  gtk_widget_remove_accelerator(NATIVE_WIDGET, window.hotkeyId, keyCode, (GdkModifierType)modifiers);
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onActivated
{
  [_delegate gtkMenuItemActivated:self];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
