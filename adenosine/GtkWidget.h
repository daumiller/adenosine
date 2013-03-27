//==================================================================================================================================
// GtkWidget.h
//==================================================================================================================================
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
-(BOOL)gtkWidget:(GtkWidget *)widget buttonPressed:(int)button clickCount:(int)clickCount local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)gtkWidget:(GtkWidget *)widget buttonReleased:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)gtkWidget:(GtkWidget *)widget pointerMovedAt:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)gtkWidget:(GtkWidget *)widget scrolled:(GtkScrollDirection)direction by:(OMCoordinate)deltas at:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)gtkWidget:(GtkWidget *)widget keyPressed:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers;
-(BOOL)gtkWidget:(GtkWidget *)widget keyReleased:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers;
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
@property (assign)   BOOL      isSensitive;
@property (assign)   BOOL      canGrabFocus;
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
- (OMCoordinate) translateCoordinate:(OMCoordinate)local toFamily:(GtkWidget *)relative;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onDrawToSurface:(OMSurface *)surface;
-(BOOL)onDimensionsChanged:(OMDimension)dimension;
-(BOOL)onButtonPressed:(int)button clickCount:(int)clickCount local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)onButtonReleased:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)onPointerMovedAt:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)onScrolled:(GtkScrollDirection)direction by:(OMCoordinate)deltas at:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifier)modifiers;
-(BOOL)onKeyPressed:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers;
-(BOOL)onKeyReleased:(unsigned int)keyCode raw:(uint16_t)rawCode group:(uint8_t)group isModifier:(BOOL)isModifier modifiers:(GtkModifier)modifiers;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
