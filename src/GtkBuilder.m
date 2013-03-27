//==================================================================================================================================
// GtkBuilder.m
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
#define NATIVE_BUILDER ((struct _GtkBuilder *)_native)

//==================================================================================================================================
@implementation GtkBuilder

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ builder                               { return [[[self alloc] init                 ] autorelease]; }
+ builderWithFile:(OFString *)filename  { return [[[self alloc] initWithFile:filename] autorelease]; }
+ builderWithString:(OFString *)string  { return [[[self alloc] initWithString:string] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  if(self)
  {
    _native = gtk_builder_new();
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithFile:(OFString *)filename
{
  self = [super init];
  if(self)
  {
    _native = gtk_builder_new();
    [self addFromFile:filename];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithString:(OFString *)string
{
  self = [super init];
  if(self)
  {
    _native = gtk_builder_new();
    [self addFromString:string];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  if(_native) g_object_unref(G_OBJECT(_native));
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize native = _native;

//==================================================================================================================================
// Lookups
//==================================================================================================================================
-(void *)nativeByName:(OFString *)name
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  void *result = gtk_builder_get_object(NATIVE_BUILDER, [name UTF8String]);
  [pool drain];
  return result;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(id)widgetByName:(OFString *)name
{
  void *native = [self nativeByName:name];
  //this object may already have been wrapped; double check before creating a new one
  GtkWidget *wrap = [GtkWidget nativeToWrapper:native];
  if(wrap == nil) wrap = [GtkWidget wrapExistingNative:native];
  return wrap;
}

//==================================================================================================================================
// Loaders
//==================================================================================================================================
-(BOOL)addFromFile:(OFString *)filename
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  unsigned int result = gtk_builder_add_from_file(NATIVE_BUILDER, [filename UTF8String], NULL); 
  [pool drain];
  return (result != 0);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)addFromString:(OFString *)string
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  unsigned int result = gtk_builder_add_from_string(NATIVE_BUILDER, [string UTF8String], -1, NULL); 
  [pool drain];
  return (result != 0);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
