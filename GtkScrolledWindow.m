//==================================================================================================================================
// GtkScrolledWindow.m
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
#import "GtkNative.h"
#import <adenosine/adenosine.h>

//==================================================================================================================================
#define NATIVE_WIDGET   ((struct _GtkWidget         *)_native)
#define NATIVE_SCROLLED ((struct _GtkScrolledWindow *)_native)

//==================================================================================================================================
@implementation GtkScrolledWindow

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ scrolledWindow { return [[[self alloc] initScrolledWindow] autorelease]; }
- initScrolledWindow
{
  self = [super init];
  if(self)
  {
    _native = gtk_scrolled_window_new(NULL,NULL);
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(GtkBorderShadow)shadow                 { return (GtkBorderShadow)gtk_scrolled_window_get_shadow_type(NATIVE_SCROLLED); }
-(void)setShadow:(GtkBorderShadow)shadow { gtk_scrolled_window_set_shadow_type(NATIVE_SCROLLED, (GtkShadowType)shadow);  }
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkCorner)placement                    { return (GtkCorner)gtk_scrolled_window_get_placement(NATIVE_SCROLLED);         }
-(void)setPlacement:(GtkCorner)placement
{
  if(placement == GTKCORNER_UNSET)
    gtk_scrolled_window_unset_placement(NATIVE_SCROLLED);
  else
    gtk_scrolled_window_set_placement(NATIVE_SCROLLED, (GtkCornerType)placement);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkScrollbarShow)horizontalPolicy
{
  GtkPolicyType horz;
  gtk_scrolled_window_get_policy(NATIVE_SCROLLED, &horz, NULL);
  return (GtkScrollbarShow)horz;
}
-(void)setHorizontalPolicy:(GtkScrollbarShow)horizontalPolicy
{
  gtk_scrolled_window_set_policy(NATIVE_SCROLLED, (GtkPolicyType)horizontalPolicy, (GtkPolicyType)self.verticalPolicy);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkScrollbarShow)verticalPolicy
{
  GtkPolicyType vert;
  gtk_scrolled_window_get_policy(NATIVE_SCROLLED, NULL, &vert);
  return (GtkScrollbarShow)vert;
}
-(void)setVerticalPolicy:(GtkScrollbarShow)verticalPolicy
{
  gtk_scrolled_window_set_policy(NATIVE_SCROLLED, (GtkPolicyType)self.horizontalPolicy, (GtkPolicyType)verticalPolicy);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OMSize)minimumContentSize
{
  return OMMakeSize((float)gtk_scrolled_window_get_min_content_width (NATIVE_SCROLLED),
                    (float)gtk_scrolled_window_get_min_content_height(NATIVE_SCROLLED));
}
-(void)setMinimumContentSize:(OMSize)minimumContentSize
{
  gtk_scrolled_window_set_min_content_width (NATIVE_SCROLLED, (int)minimumContentSize.width );
  gtk_scrolled_window_set_min_content_height(NATIVE_SCROLLED, (int)minimumContentSize.height);
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)addWithViewport:(GtkWidget *)child
{
  gtk_scrolled_window_add_with_viewport(NATIVE_SCROLLED, (struct _GtkWidget *)child.native);
}

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
