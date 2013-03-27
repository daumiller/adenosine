//==================================================================================================================================
// GtkImage.m
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
// Properties
//==================================================================================================================================
-(void *)nativePixbuf { return gtk_image_get_pixbuf(NATIVE_IMAGE); }

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
