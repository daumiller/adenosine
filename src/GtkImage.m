//==================================================================================================================================
// GtkImage.m
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
#import <adenosine/GtkImage.h>

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_IMAGE  ((struct _GtkImage  *)_native)

//==================================================================================================================================
@implementation GtkImage

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ image                                                   { return [[[self alloc] initImage                    ] autorelease]; }
+ imageWithFile:(OFString *)filename                      { return [[[self alloc] initWithFile:filename        ] autorelease]; }
+ imageFromStock:(OFString *)stock size:(GtkIconSize)size { return [[[self alloc] initFromStock:stock size:size] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initImage
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
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initFromStock:(OFString *)stock size:(GtkIconSize)size
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = (void *)gtk_image_new_from_stock([stock UTF8String], (Native_GtkIconSize)size);
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
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setImageFromStock:(OFString *)stock size:(GtkIconSize)size
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_image_set_from_stock(NATIVE_IMAGE, [stock UTF8String], (Native_GtkIconSize)size);
  [pool drain];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
