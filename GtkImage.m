//==================================================================================================================================
// GtkImage.m
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
#import "GtkImage.h"

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_IMAGE  ((struct _GtkImage  *)_native)

//==================================================================================================================================
@implementation GtkImage

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ image
{
  return [[[self alloc] init] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ imageWithFile:(OFString *)filename
{
  return [[[self alloc] initWithFile:filename] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_image_new();
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithFile:(OFString *)filename
{
 self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = (void *)gtk_image_new_from_file([filename UTF8String]);
    [pool drain];
    [self installNativeLookup];
  }
  return self; 
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)clearImage
{
  gtk_image_clear(NATIVE_IMAGE);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setImageFromFile:(OFString *)file
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_image_set_from_file(NATIVE_IMAGE, [file UTF8String]);
  [pool drain];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
