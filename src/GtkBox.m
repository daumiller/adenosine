//==================================================================================================================================
// GtkBox.m
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
#import <adenosine/GtkBox.h>

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_BOX    ((struct _GtkBox    *)_native)

//==================================================================================================================================
@implementation GtkBox

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ boxWithOrientation:(GtkBoxOrientation)orientation
{
  return [[[self alloc] initWithOrientation:orientation] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- initWithOrientation:(GtkBoxOrientation)orientation
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_box_new((GtkOrientation)orientation, 0);
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(BOOL)forceEqual                     { return gtk_box_get_homogeneous(NATIVE_BOX);      }
-(void)setForceEqual:(BOOL)forceEqual { gtk_box_set_homogeneous(NATIVE_BOX, forceEqual); }
//----------------------------------------------------------------------------------------------------------------------------------
-(int)spacing                         { return gtk_box_get_spacing(NATIVE_BOX);          }
-(void)setSpacing:(int)spacing        { gtk_box_set_spacing(NATIVE_BOX, spacing);        }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)addFromStart:(GtkWidget *)widget expand:(BOOL)expand fill:(BOOL)fill padding:(unsigned int)padding
{
  gtk_box_pack_start(NATIVE_BOX, widget.native, expand, fill, padding);
  [_children addObject:widget];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)addFromEnd  :(GtkWidget *)widget expand:(BOOL)expand fill:(BOOL)fill padding:(unsigned int)padding
{
  gtk_box_pack_end(NATIVE_BOX, widget.native, expand, fill, padding);
  [_children addObject:widget];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)queryChild:(GtkWidget *)child expand:(BOOL *)expand fill:(BOOL *)fill padding:(unsigned int *)padding
{
  gtk_box_query_child_packing(NATIVE_BOX, child.native, (gboolean *)expand, (gboolean *)fill, padding, NULL);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)alterChild:(GtkWidget *)child expand:(BOOL)expand fill:(BOOL)fill padding:(unsigned int)padding
{
  GtkPackType packType;
  gtk_box_query_child_packing(NATIVE_BOX, child.native, NULL, NULL, NULL, &packType);
  gtk_box_set_child_packing(NATIVE_BOX, child.native, expand, fill, padding, packType);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
