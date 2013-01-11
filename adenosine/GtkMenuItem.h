//==================================================================================================================================
// GtkMenuItem.h
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
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkBin.h>

//==================================================================================================================================
@class GtkMenuItem;
@protocol GtkMenuItemDelegate <OFObject>
@optional
-(void)gtkMenuItemActivated:(GtkMenuItem *)menuItem;
@end

//==================================================================================================================================
@interface GtkMenuItem : GtkBin
{
  GtkWidget *_submenu;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ menuItem;
+ menuItemWithText:(OFString *)text;
+ menuItemWithAccel:(OFString *)text;
+ menuItemWithAccel:(OFString *)text andDelegate:(id)delegate;
- initMenuItem;
- initWithText:(OFString *)text;
- initWithAccel:(OFString *)text;
- initWithAccel:(OFString *)text andDelegate:(id)delegate;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) OFString  *text;
@property (assign) BOOL       textIsAccel;
@property (retain) GtkWidget *submenu;

//----------------------------------------------------------------------------------------------------------------------------------
//TODO: we need a wrapper Key Enumeration (not depending on GTK/GDK for this...)
-(void)addHotkey:(unsigned int)keyCode withModifiers:(GtkModifier)modifiers toWindow:(GtkWindow *)window;
-(void)removeHotkey:(unsigned int)keyCode withModifiers:(GtkModifier)modifiers fromWindow:(GtkWindow *)window;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onActivated;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
