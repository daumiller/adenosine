//==================================================================================================================================
// GtkMenu.m
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
