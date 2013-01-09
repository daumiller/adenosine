//==================================================================================================================================
// GtkMenuBar.m
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
#define NATIVE_WIDGET  ((struct _GtkWidget  *)_native)
#define NATIVE_MENUBAR ((struct _GtkMenuBar *)_native)

//==================================================================================================================================
@implementation GtkMenuBar

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ menuBar { return [[[self alloc] initMenuBar] autorelease]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initMenuBar
{
  self = [super init];
  if(self)
  {
    _native = gtk_menu_bar_new();
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(GtkMenuPacking)packing                  { return (GtkMenuPacking)gtk_menu_bar_get_pack_direction(NATIVE_MENUBAR);     }
-(void)setPacking:(GtkMenuPacking)packing { gtk_menu_bar_set_pack_direction(NATIVE_MENUBAR, (GtkPackDirection)packing); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkMenuPacking)childPacking                       { return (GtkMenuPacking)gtk_menu_bar_get_child_pack_direction(NATIVE_MENUBAR);          }
-(void)setChildPacking:(GtkMenuPacking)childPacking { gtk_menu_bar_set_child_pack_direction(NATIVE_MENUBAR, (GtkPackDirection)childPacking); }

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
