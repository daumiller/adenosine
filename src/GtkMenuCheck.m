//==================================================================================================================================
// GtkMenuCheck.m
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
#define NATIVE_WIDGET    ((struct _GtkWidget        *)_native)
#define NATIVE_MENUCHECK ((struct _GtkCheckMenuItem *)_native)

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_Toggled(struct _GtkMenuItem *menuItem, void *data)
{
  GtkMenuCheck *obj = (GtkMenuCheck *)[GtkWidget nativeToWrapper:(void *)menuItem];
  [obj onToggled];
}

//==================================================================================================================================
@implementation GtkMenuCheck

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ menuCheck                               { return [[[self alloc] initMenuCheck        ] autorelease]; }
+ menuCheckWithText:(OFString *)text      { return [[[self alloc] initWithText:text    ] autorelease]; }
+ menuCheckWithAccel:(OFString *)text     { return [[[self alloc] initWithAccel:text   ] autorelease]; }
+ menuCheckWithText:(OFString *)text andDelegate:(id)delegate
{
  GtkMenuCheck *chk = [[[self alloc] initWithText:text] autorelease];
  chk.delegate = delegate;
  return chk;
}
+ menuCheckWithAccel:(OFString *)text andDelegate:(id)delegate
{
  GtkMenuCheck *chk = [[[self alloc] initWithAccel:text] autorelease];
  chk.delegate = delegate;
  return chk;
}
//----------------------------------------------------------------------------------------------------------------------------------
- initMenuCheck
{
  self = [super init];
  if(self)
  {
    _native = gtk_check_menu_item_new();
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
    _native = gtk_check_menu_item_new_with_label([text UTF8String]);
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
    _native = gtk_check_menu_item_new_with_mnemonic([text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(BOOL)isChecked                              { return gtk_check_menu_item_get_active(NATIVE_MENUCHECK);                }
-(void)setIsChecked:(BOOL)isChecked           { gtk_check_menu_item_set_active(NATIVE_MENUCHECK, isChecked);            }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)isInconsistent                         { return gtk_check_menu_item_get_inconsistent(NATIVE_MENUCHECK);          }
-(void)setIsInconsistent:(BOOL)isInconsistent { gtk_check_menu_item_set_inconsistent(NATIVE_MENUCHECK, isInconsistent); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)drawAsRadio                            { return gtk_check_menu_item_get_draw_as_radio(NATIVE_MENUCHECK);         }
-(void)setDrawAsRadio:(BOOL)drawAsRadio       { gtk_check_menu_item_set_draw_as_radio(NATIVE_MENUCHECK, drawAsRadio);   }
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setDelegate:(id)delegate
{
  [super setDelegate:delegate];
  
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkMenuCheck:toggled:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "toggled", G_CALLBACK(ConnectionProxy_Toggled),NULL)]];
  }
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onToggled
{
  [_delegate gtkMenuCheck:self toggled:self.isChecked];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
