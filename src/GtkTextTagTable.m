//==================================================================================================================================
// GtkTextTagTable.m
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
#define NATIVE_TAGTABLE ((struct _GtkTextTagTable *)_native)
#define ADENOSINE_NATIVE_LOOKUP_STRING "_adenosine_wrapper_texttagtable"

//==================================================================================================================================
// Iterator Proxy
//==================================================================================================================================
static void IterateTagsWrappingChildren(struct _GtkTextTag *tag, gpointer data)
{
  GtkTextTagTable *me = (GtkTextTagTable *)data;
  GtkTextTag *child = [GtkTextTag nativeToWrapper:tag];
  if(!child)  child = [GtkTextTag wrapExistingNative:tag];
  OFMutableArray *tagArray = (OFMutableArray *)me.tags;
  [tagArray addObject:child];
}
//----------------------------------------------------------------------------------------------------------------------------------
static void IterateTagsWithBlock(struct _GtkTextTag *tag, gpointer data)
{
  void (^block)(GtkTextTag *) = (void (^)(GtkTextTag *))data;
  GtkTextTag *wrap = [GtkTextTag nativeToWrapper:tag]; //we shouldn't be able to get here without this tag being wrapped
  block(wrap);
}

//==================================================================================================================================
@implementation GtkTextTagTable

//==================================================================================================================================
// Wrapping
//==================================================================================================================================
+ (BOOL) isWrapped:(void *)native
{
  return ([GtkTextTagTable nativeToWrapper:native] != nil);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ nativeToWrapper:(void *)native
{
  if(!G_IS_OBJECT(native)) return nil;
  return (GtkTextTagTable *)g_object_get_data((GObject *)native, ADENOSINE_NATIVE_LOOKUP_STRING);
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
    _tags   = [[OFMutableArray alloc] init];
    gtk_text_tag_table_foreach(NATIVE_TAGTABLE, IterateTagsWrappingChildren, self); //wrap all TextTag children
    g_object_ref(_native);
    [self installNativeLookup];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)installNativeLookup
{
  g_object_set_data((gpointer)_native, ADENOSINE_NATIVE_LOOKUP_STRING, (gpointer)self);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)destroy
{
  [_tags release];
  g_object_unref(_native);
}

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ textTagTable { return [[[self alloc] initTextTagTable] autorelease]; }
- initTextTagTable
{
  self = [super init];
  if(self)
  {
    _native = gtk_text_tag_table_new();
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
-(void *)native  { return _native;                                      }
-(int)size       { return gtk_text_tag_table_get_size(NATIVE_TAGTABLE); }
-(OFArray *)tags { return (OFArray *)_tags;                             }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)add:(GtkTextTag *)textTag
{
  gtk_text_tag_table_add(NATIVE_TAGTABLE, textTag.native);
  [_tags addObject:textTag];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)remove:(GtkTextTag *)textTag
{
  gtk_text_tag_table_remove(NATIVE_TAGTABLE, textTag.native);
  [_tags removeObjectIdenticalTo:textTag];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkTextTag *)findByName:(OFString *)name
{
  __block OFString   *findName = name;
  __block GtkTextTag *findHit  = nil;
  void (^findBlock)(GtkTextTag *) = ^(GtkTextTag *tag)
  {
    if(!findHit)
    {
      OFString *tagName = tag.name;
      if(tagName != nil)
        if([tagName compare:findName] == OF_ORDERED_SAME)
          findHit = tag;
    }
  };
  [self forEachTag:findBlock];
  return findHit;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)forEachTag:(void (^)(GtkTextTag *))block
{
  gtk_text_tag_table_foreach(NATIVE_TAGTABLE, IterateTagsWithBlock, block);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
