//==================================================================================================================================
// GtkBuilder.m
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
//NOTE: it's important to call wrapExistingNative for the highest level class needed, in case it needs to initialize extra data
-(GtkWidget      *)widgetByName     :(OFString *)name { return [GtkWidget      wrapExistingNative:[self nativeByName:name]]; }
-(GtkLabel       *)labelByName      :(OFString *)name { return [GtkLabel       wrapExistingNative:[self nativeByName:name]]; }
-(GtkButton      *)buttonByName     :(OFString *)name { return [GtkButton      wrapExistingNative:[self nativeByName:name]]; }
-(GtkImage       *)imageByName      :(OFString *)name { return [GtkImage       wrapExistingNative:[self nativeByName:name]]; }
-(GtkProgressBar *)progressBarByName:(OFString *)name { return [GtkProgressBar wrapExistingNative:[self nativeByName:name]]; }
-(GtkWindow      *)windowByName     :(OFString *)name { return [GtkWindow      wrapExistingNative:[self nativeByName:name]]; }

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
