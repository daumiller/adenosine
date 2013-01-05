//==================================================================================================================================
// GtkMenuCheck.m
/*==================================================================================================================================
Copyright © 2013 Dillon Aumiller <dillonaumiller@gmail.com>

This file is part of the adenosine library.

adenosine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

adenosine is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with adenosine.  If not, see <http://www.gnu.org/licenses/>.
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
