//==================================================================================================================================
// GtkWidget.h
/*==================================================================================================================================
Copyright © 2012 Dillon Aumiller <dillonaumiller@gmail.com>

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
#import <atropine/atropine.h>

//==================================================================================================================================
typedef enum
{
  GTKMODIFIER_SHIFT   = 1 <<  0,
  GTKMODIFIER_LOCK    = 1 <<  1,
  GTKMODIFIER_CONTROL = 1 <<  2,
  GTKMODIFIER_MOD1    = 1 <<  3,
  GTKMODIFIER_MOD2    = 1 <<  4,
  GTKMODIFIER_MOD3    = 1 <<  5,
  GTKMODIFIER_MOD4    = 1 <<  6,
  GTKMODIFIER_MOD5    = 1 <<  7,
  GTKMODIFIER_BUTTON1 = 1 <<  8,
  GTKMODIFIER_BUTTON2 = 1 <<  9,
  GTKMODIFIER_BUTTON3 = 1 << 10,
  GTKMODIFIER_BUTTON4 = 1 << 11,
  GTKMODIFIER_BUTTON5 = 1 << 12,
  GTKMODIFIER_SUPER   = 1 << 26,
  GTKMODIFIER_HYPER   = 1 << 27,
  GTKMODIFIER_META    = 1 << 28,
  GTKMODIFIER_RELEASE = 1 << 30
} GtkModifier;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKPOSITION_LEFT,
  GTKPOSITION_TOP,
  GTKPOSITION_RIGHT,
  GTKPOSITION_BOTTOM
} GtkPosition;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKICONSIZE_INVALID,
  GTKICONSIZE_MENU,
  GTKICONSIZE_TOOLBAR_SMALL,
  GTKICONSIZE_TOOLBAR_LARGE,
  GTKICONSIZE_BUTTON,
  GTKICONSIZE_DND,
  GTKICONSIZE_DIALOG
} GtkIconSize;

//==================================================================================================================================
@class GtkWidget;
@protocol GtkWidgetDelegate <OFObject>
@optional
-(BOOL)gtkWidget:(GtkWidget *)widget drawToSurface:(OMSurface *)surface;
-(BOOL)gtkWidget:(GtkWidget *)widget dimensionsChanged:(OMDimension)dimension;
-(BOOL)gtkWidget:(GtkWidget *)widget buttonPressed:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)gtkWidget:(GtkWidget *)widget buttonReleased:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)gtkWidget:(GtkWidget *)widget pointerMovedAt:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
@end

//==================================================================================================================================
@interface GtkWidget : OFObject
{
  void           *_native;
  id              _delegate;
  OFMutableArray *_connections;
}

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void *native;
@property (retain  ) id    delegate;

//----------------------------------------------------------------------------------------------------------------------------------
+ wrapExistingNative:(void *)native;
+ nativeToWrapper:(void *)native;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)installNativeLookup;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)destroy;

//----------------------------------------------------------------------------------------------------------------------------------
- (void) show;
- (void) showAll;
- (void) hide;
- (void) activate;
- (void) grabFocus;
- (void) grabDefault;
- (BOOL) isFocused;
- (OMSize) allocatedSize;
- (void  ) queueDrawDimension:(OMDimension)dimension;
- (void  ) queueDrawAll;
- (void  ) setProperty:(OFString *)property toValue:(void *)value;
- (void *) getProperty:(OFString *)property;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onDrawToSurface:(OMSurface *)surface;
-(BOOL)onDimensionsChanged:(OMDimension)dimension;
-(BOOL)onButtonPressed:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)onButtonReleased:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)onPointerMovedAt:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
