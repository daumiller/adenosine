//==================================================================================================================================
// GtkWindow.h
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
#import <atropine/OMCoordinate.h>
#import <adenosine/GtkBin.h>

//==================================================================================================================================
typedef enum
{
  GTKWINDOWTYPE_TOPLEVEL,
  GTKWINDOWTYPE_POPUP
} GtkWindowType;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKWINDOWSTATE_NORMAL,
  GTKWINDOWSTATE_MINIMIZED,
  GTKWINDOWSTATE_MAXIMIZED,
  GTKWINDOWSTATE_FULLSCREEN,
  GTKWINDOWSTATE_HIDDEN
} GtkWindowState;

//==================================================================================================================================
@class GtkWindow;
@protocol GtkWindowDelegate <OFObject>
@optional
-(BOOL)gtkWindowShouldClose:(GtkWindow *)window;
-(void)gtkWindowDidClose:(GtkWindow *)window;
@end

//==================================================================================================================================
@interface GtkWindow : GtkBin

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign)   OFString *title;
@property (assign)   GtkWidget *modalParent;
@property (assign)   GtkWindowState state;
@property (assign)   BOOL isResizable;
@property (assign)   BOOL isModal;
@property (assign)   BOOL isUrgent;
@property (assign)   BOOL isDecorated;
@property (assign)   BOOL showInTaskbar;
@property (assign)   BOOL showInPager;
@property (assign)   BOOL quitOnClose;
@property (assign)   OMSize       size;
@property (assign)   OMCoordinate position;
@property (readonly) void        *hotkeyId;

//----------------------------------------------------------------------------------------------------------------------------------
+ window;
+ windowWithType:(GtkWindowType)type;
- initWindow;
- initWithType:(GtkWindowType)type;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)reposition:(GtkWindowPosition)position;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onShouldClose;
-(void)onDidClose;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
