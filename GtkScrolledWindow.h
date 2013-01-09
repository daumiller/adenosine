//==================================================================================================================================
// GtkScrolledWindow.h
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
@interface GtkScrolledWindow : GtkBin
{
  float _scrollScaleX;
  float _scrollScaleY;
  BOOL  _scrollScaled;
  unsigned long _scaleScrollingConnectionId;
}

//----------------------------------------------------------------------------------------------------------------------------------
+scrolledWindow;
-initScrolledWindow;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) GtkBorderShadow  shadow;
@property (assign) GtkCorner        placement;
@property (assign) GtkScrollbarShow horizontalPolicy;
@property (assign) GtkScrollbarShow verticalPolicy;
@property (assign) OMSize           minimumContentSize;
@property (assign) float            scrollScaleX;
@property (assign) float            scrollScaleY;
@property (assign) BOOL             scrollScaled;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)addWithViewport:(GtkWidget *)child;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onScrollModifier:(GtkScrollDirection *)direction by:(OMCoordinate *)deltas at:(OMCoordinate *)local root:(OMCoordinate *)root modifiers:(GtkModifier *)modifiers;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
