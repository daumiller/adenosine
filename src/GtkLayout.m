//==================================================================================================================================
// GtkLayout.m
/*==================================================================================================================================
Copyright © 2013, Dillon Aumiller <dillonaumiller@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
