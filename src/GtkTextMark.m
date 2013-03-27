//==================================================================================================================================
// GtkTextMark.m
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
-(GtkTextBuffer *)buffer
{
  void *nativeBuffer = gtk_text_mark_get_buffer(NATIVE_TEXTMARK);
  if(!nativeBuffer) return nil;
  GtkTextBuffer *wrap = [GtkTextBuffer nativeToWrapper:nativeBuffer];
  if(!wrap) wrap = [GtkTextBuffer wrapExistingNative:nativeBuffer]; //this shouldn't ever actually be reached
  return wrap;
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
