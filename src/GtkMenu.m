//==================================================================================================================================
// GtkMenu.m
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
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_MENU   ((struct _GtkMenu   *)_native)

//==================================================================================================================================
@implementation GtkMenu

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ menu { return [[[self alloc] initMenu] autorelease]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initMenu
{
  self = [super init];
  if(self)
  {
    _native = gtk_menu_new();
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(BOOL)alwaysShowGutter                           { return gtk_menu_get_reserve_toggle_size(NATIVE_MENU);            }
-(void)setAlwaysShowGutter:(BOOL)alwaysShowGutter { gtk_menu_set_reserve_toggle_size(NATIVE_MENU, alwaysShowGutter); }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)attach:(GtkWidget *)child column:(int)left row:(int)top 
{
  [_children addObject:child];
  gtk_menu_attach(NATIVE_MENU, child.native, left,left, top,top);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)attach:(GtkWidget *)child leftColumn:(int)left rightColumn:(int)right topRow:(int)top bottomRow:(int)bottom
{
  [_children addObject:child];
  gtk_menu_attach(NATIVE_MENU, child.native, left, right, top, bottom);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)reorderChild:(GtkWidget *)child toIndex:(int)index { gtk_menu_reorder_child(NATIVE_MENU, child.native, index);              }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)popupFromButton:(int)button { gtk_menu_popup(NATIVE_MENU, NULL, NULL, NULL, NULL, button, gtk_get_current_event_time());    }
-(void)popdown                     { gtk_menu_popdown(NATIVE_MENU);                                                                }


//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
