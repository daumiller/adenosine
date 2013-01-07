//==================================================================================================================================
// GtkTextMark.m
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
#define NATIVE_TEXTMARK ((struct _GtkTextMark *)_native)
#define ADENOSINE_NATIVE_LOOKUP_STRING "_adenosine_wrapper_textmark"

//==================================================================================================================================
@implementation GtkTextMark

//==================================================================================================================================
// Wrapping
//==================================================================================================================================
+ (BOOL) isWrapped:(void *)native
{
  return ([GtkTextMark nativeToWrapper:native] != nil);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ nativeToWrapper:(void *)native
{
  if(!G_IS_OBJECT(native)) return nil;
  return (GtkTextMark *)g_object_get_data((GObject *)native, ADENOSINE_NATIVE_LOOKUP_STRING);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ wrapExistingNative:(void *)native
{
  return [[[self alloc] initWithExistingNative:native] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- initWithExistingNative:(void *)native
{
  self = [super init];
  if(self)
  {
    _native = native;
    g_object_ref(_native);
    [self installNativeLookup];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)installNativeLookup { g_object_set_data((gpointer)_native, ADENOSINE_NATIVE_LOOKUP_STRING, (gpointer)self); }
-(void)destroy             { g_object_unref(_native);                                                              }

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ textMark                                                           { return [[[self alloc] initTextMark                                ] autorelease]; }
+ textMarkWithName:(OFString *)name                                  { return [[[self alloc] initWithName:name                           ] autorelease]; }
+ textMarkWithName:(OFString *)name andLeftGravity:(BOOL)leftGravity { return [[[self alloc] initWithName:name andLeftGravity:leftGravity] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initTextMark
{
  self = [super init];
  if(self)
  {
    _native = gtk_text_mark_new(NULL, NO);
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithName:(OFString *)name
{
  self = [super init];
  if(self)
  {
    if(name == nil)
      _native = gtk_text_mark_new(NULL, NO);
    else
    {
      OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
      _native = gtk_text_mark_new([name UTF8String], NO);
      [pool drain];
    }
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithName:(OFString *)name andLeftGravity:(BOOL)leftGravity
{
  self = [super init];
  if(self)
  {
    if(name == nil)
      _native = gtk_text_mark_new(NULL, leftGravity);
    else
    {
      OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
      _native = gtk_text_mark_new([name UTF8String], leftGravity);
      [pool drain];
    }
    [self installNativeLookup];
  }
  return self;
}

//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  [self destroy];
  [super dealloc]; 
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(void *)native                 { return _native;                                                                 }
-(OFString *)name               { return [OFString stringWithUTF8String:gtk_text_mark_get_name(NATIVE_TEXTMARK)]; }
-(BOOL)leftGravity              { return gtk_text_mark_get_left_gravity(NATIVE_TEXTMARK);                         }
-(BOOL)wasDeleted               { return gtk_text_mark_get_deleted(NATIVE_TEXTMARK);                              }
-(BOOL)visible                  { return gtk_text_mark_get_visible(NATIVE_TEXTMARK);                              }
-(void)setVisible:(BOOL)visible { gtk_text_mark_set_visible(NATIVE_TEXTMARK, visible);                            }
/*
-(GtkTextBuffer *)buffer
{
  void *nativeBuffer = gtk_text_mark_get_buffer(NATIVE_TEXTMARK);
  if(!nativeBuffer) return nil;
  GtkTextBuffer *wrap = [GtkTextBuffer nativeToWrapper:nativeBuffer];
  if(!wrap) wrap = [GtkTextBuffer wrapExistingNative:nativeBuffer]; //this shouldn't ever actually be reached
  return wrap;
}
*/

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
