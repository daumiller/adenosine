//==================================================================================================================================
// GtkEventBox.m
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
#define NATIVE_WIDGET   ((struct _GtkWidget   *)_native)
#define NATIVE_EVENTBOX ((struct _GtkEventBox *)_native)

//==================================================================================================================================
@implementation GtkEventBox

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ (GtkEventBox *)eventBox
{
  return [[[self alloc] initEventBox] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initEventBox
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_event_box_new();
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(BOOL)aboveChild                           { return gtk_event_box_get_above_child(NATIVE_EVENTBOX);                   }
-(void)setAboveChild:(BOOL)aboveChild       {        gtk_event_box_set_above_child(NATIVE_EVENTBOX, aboveChild);       }
-(BOOL)visibleWindow                        { return gtk_event_box_get_visible_window(NATIVE_EVENTBOX);                }
-(void)setVisibleWindow:(BOOL)visibleWindow {        gtk_event_box_set_visible_window(NATIVE_EVENTBOX, visibleWindow); }

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
