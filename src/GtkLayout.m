//==================================================================================================================================
// GtkLayout.m
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
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_LAYOUT ((struct _GtkLayout *)_native)

//==================================================================================================================================
@implementation GtkLayout

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ (GtkLayout *)layout
{
  return [[[self alloc] initLayout] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initLayout
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_layout_new(NULL, NULL);
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(int)scrollHeight
{
  unsigned int height;
  gtk_layout_get_size(NATIVE_LAYOUT, NULL, &height);
  return (int)height;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setScrollHeight:(int)scrollHeight
{
  gtk_layout_set_size(NATIVE_LAYOUT, (unsigned int)[self scrollWidth], (unsigned int)scrollHeight);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(int)scrollWidth
{
  unsigned int width;
  gtk_layout_get_size(NATIVE_LAYOUT, &width, NULL);
  return (int)width;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setScrollWidth:(int)scrollWidth
{
  gtk_layout_set_size(NATIVE_LAYOUT, (unsigned int)scrollWidth, (unsigned int)[self scrollHeight]);
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)putChild:(GtkWidget *)child atX:(int)x andY:(int)y
{
  [_children addObject:child];
  gtk_layout_put(NATIVE_LAYOUT, child.native, x, y);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
