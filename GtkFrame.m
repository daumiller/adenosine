//==================================================================================================================================
// GtkFrame.m
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
#import "GtkNative.h"
#import "GtkFrame.h"

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_FRAME  ((struct _GtkFrame  *)_native)

//==================================================================================================================================
@implementation GtkFrame

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ frame
{
  return [[[self alloc] init] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ frameWithText:(OFString *)text;
{
  return [[[self alloc] initWithText:text] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_frame_new(NULL);
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithText:(OFString *)text
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_frame_new(NULL);
    [self installNativeLookup];
    self.text = text;
  }
  return self;
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(OFString *)text { return [OFString stringWithUTF8String:gtk_frame_get_label(NATIVE_FRAME)];}
-(void)setText:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_frame_set_label(NATIVE_FRAME, [text UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkFrameShadow)shadow                 { return (GtkFrameShadow)gtk_frame_get_shadow_type(NATIVE_FRAME); }
-(void)setShadow:(GtkFrameShadow)shadow { gtk_frame_set_shadow_type(NATIVE_FRAME, (GtkShadowType)shadow); }

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
