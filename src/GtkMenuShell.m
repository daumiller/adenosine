//==================================================================================================================================
// GtkMenuShell.m
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
#define NATIVE_WIDGET    ((struct _GtkWidget    *)_native)
#define NATIVE_MENUSHELL ((struct _GtkMenuShell *)_native)

//==================================================================================================================================
@implementation GtkMenuShell

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(BOOL)doesTakeFocus                        { return gtk_menu_shell_get_take_focus(NATIVE_MENUSHELL);         }
-(void)setDoesTakeFocus:(BOOL)doesTakeFocus { gtk_menu_shell_set_take_focus(NATIVE_MENUSHELL, doesTakeFocus); }
-(GtkWidget *)selectedItem                  { return [GtkWidget nativeToWrapper:gtk_menu_shell_get_selected_item(NATIVE_MENUSHELL)]; }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)append :(GtkWidget *)child                    { [_children addObject:child]; gtk_menu_shell_append(NATIVE_MENUSHELL, child.native);        }
-(void)prepend:(GtkWidget *)child                    { [_children addObject:child]; gtk_menu_shell_prepend(NATIVE_MENUSHELL, child.native);       }
-(void)insert :(GtkWidget *)child atIndex:(int)index { [_children addObject:child]; gtk_menu_shell_insert(NATIVE_MENUSHELL, child.native, index); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)appendSeparator { [self append:[GtkMenuSeparator separator]]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)selectFirstItem               { gtk_menu_shell_select_first(NATIVE_MENUSHELL, NO);         }
-(void)selectItem:(GtkWidget *)item  { gtk_menu_shell_select_item(NATIVE_MENUSHELL, item.native); }
-(void)deselectItem                  { gtk_menu_shell_deselect(NATIVE_MENUSHELL);                 }
-(void)cancelSelection               { gtk_menu_shell_cancel(NATIVE_MENUSHELL);                   }
-(void)activateItem:(GtkWidget *)item andDeactivate:(BOOL)deactivate { gtk_menu_shell_activate_item(NATIVE_MENUSHELL, item.native, deactivate); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)deactivate { gtk_menu_shell_deactivate(NATIVE_MENUSHELL); }

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
