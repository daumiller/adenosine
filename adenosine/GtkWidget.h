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
#import <adenosine/GtkEnums.h>

//==================================================================================================================================
@class GtkWidget;
@protocol GtkWidgetDelegate <OFObject>
@optional
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Big TODO:
// this protocol, signal handlers, and proxies are currently only implemented for events i've needed so far
// the actual list of widget events conatins many, many more catchable signals...
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-(BOOL)gtkWidget:(GtkWidget *)widget drawToSurface:(OMSurface *)surface;
-(BOOL)gtkWidget:(GtkWidget *)widget dimensionsChanged:(OMDimension)dimension;
-(BOOL)gtkWidget:(GtkWidget *)widget buttonPressed:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)gtkWidget:(GtkWidget *)widget buttonReleased:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)gtkWidget:(GtkWidget *)widget pointerMovedAt:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)gtkWidget:(GtkWidget *)widget scrolled:(GtkScrollDirection)direction by:(OMCoordinate)deltas at:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
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
- (void)overrideBackgroundColor:(OMColor)color forState:(GtkWidgetState)state;
- (void)resetBackgroundColorForState:(GtkWidgetState)state;
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
-(BOOL)onScrolled:(GtkScrollDirection)direction by:(OMCoordinate)deltas at:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -