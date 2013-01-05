//==================================================================================================================================
// GtkWidget.h
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
  GTKCORNER_TOPLEFT,
  GTKCORNER_BOTTOMLEFT,
  GTKCORNER_TOPRIGHT,
  GTKCORNER_BOTTOMRIGHT,
  GTKCORNER_UNSET
} GtkCorner;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKALIGN_FILL,
  GTKALIGN_START,
  GTKALIGN_END,
  GTKALIGN_CENTER
} GtkAlign;
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
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKBORDERSHADOW_NONE,
  GTKBORDERSHADOW_BEVEL_IN,
  GTKBORDERSHADOW_BEVEL_OUT,
  GTKBORDERSHADOW_SUNKEN,
  GTKBORDERSHADOW_RAISED
} GtkBorderShadow;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKSCROLLBARSHOW_ALWAYS,
  GTKSCROLLBARSHOW_AUTOMATIC,
  GTKSCROLLBARSHOW_NEVER
} GtkScrollbarShow;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKTEXTINPUT_FREE,
  GTKTEXTINPUT_ALPHA,
  GTKTEXTINPUT_DIGITS,
  GTKTEXTINPUT_NUMBER,
  GTKTEXTINPUT_PHONE,
  GTKTEXTINPUT_URL,
  GTKTEXTINPUT_EMAIL,
  GTKTEXTINPUT_NAME,
  GTKTEXTINPUT_PASSWORD,
  GTKTEXTINPUT_PIN
} GtkTextInput;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKTEXTINPUT_HINT_NONE              =    0,
  GTKTEXTINPUT_HINT_SPELLCHECK        = 1<<0,
  GTKTEXTINPUT_HINT_NOSPELLCHECK      = 1<<1,
  GTKTEXTINPUT_HINT_WORDCOMPLETION    = 1<<2,
  GTKTEXTINPUT_HINT_LOWERCASE         = 1<<3,
  GTKTEXTINPUT_HINT_UPPERCASE         = 1<<4,
  GTKTEXTINPUT_HINT_UPPERCASEWORD     = 1<<5,
  GTKTEXTINPUT_HINT_UPPERCASESENTENCE = 1<<6,
  GTKTEXTINPUT_HINT_INHIBITOSK        = 1<<7
} GtkTextInputHint;

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
@property (readonly) void     *native;
@property (retain)   id        delegate;
@property (assign)   OMSize    minimumSize;
@property (assign)   GtkAlign  horizontalAlign;
@property (assign)   BOOL      horizontalExpand;
@property (assign)   GtkAlign  verticalAlign;
@property (assign)   BOOL      verticalExpand;
@property (assign)   OFString *tooltipText;
@property (assign)   BOOL      canGrabDefault;

//----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) isWrapped:(void *)native;
+ (id) wrapExistingNative:(void *)native;
+ nativeToWrapper:(void *)native;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithExistingNative:(void *)native;
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
