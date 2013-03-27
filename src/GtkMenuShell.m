//==================================================================================================================================
// GtkMenuShell.m
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
