//==================================================================================================================================
// GtkMenuShell.m
//==================================================================================================================================
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
