//==================================================================================================================================
// GtkScrolledWindow.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkBin.h>

//==================================================================================================================================
@interface GtkScrolledWindow : GtkBin
{
  GtkAdjustment *_horizontalAdjustment;
  GtkAdjustment *_verticalAdjustment;
  float _scrollScaleX;
  float _scrollScaleY;
  BOOL  _scrollScaled;
  unsigned long _scaleScrollingConnectionId;
}

//----------------------------------------------------------------------------------------------------------------------------------
+scrolledWindow;
-initScrolledWindow;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) GtkAdjustment   *horizontalAdjustment;
@property (readonly) GtkAdjustment   *verticalAdjustment;
@property (assign)   GtkBorderShadow  shadow;
@property (assign)   GtkCorner        placement;
@property (assign)   GtkScrollbarShow horizontalPolicy;
@property (assign)   GtkScrollbarShow verticalPolicy;
@property (assign)   OMSize           minimumContentSize;
@property (assign)   float            scrollScaleX;
@property (assign)   float            scrollScaleY;
@property (assign)   BOOL             scrollScaled;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)addWithViewport:(GtkWidget *)child;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onScrollModifier:(GtkScrollDirection *)direction by:(OMCoordinate *)deltas at:(OMCoordinate *)local root:(OMCoordinate *)root modifiers:(GtkModifier *)modifiers;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
