//==================================================================================================================================
// GtkContainer.m
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
#import <adenosine/GtkContainer.h>

//==================================================================================================================================
#define NATIVE_WIDGET    ((struct _GtkWidget    *)_native)
#define NATIVE_CONTAINER ((struct _GtkContainer *)_native)

//==================================================================================================================================
static void WrapAllChildren_Proxy(Native_GtkWidget *child, gpointer gp)
{
  GtkContainer *me = (GtkContainer *)gp;
  GtkWidget *wrap = [GtkWidget nativeToWrapper:child];
  if(wrap != nil) if([me contains:wrap]) return;
  if(wrap == nil) wrap = [GtkWidget wrapExistingNative:child];
  [(OFMutableArray *)(me.children) addObject:wrap];
}

//==================================================================================================================================
@implementation GtkContainer

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
- init
{
  self = [super init];
  if(self)
    _children = [[OFMutableArray alloc] init];
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
- initWithExistingNative:(void *)native
{
  self = [super initWithExistingNative:native];
  if(self)
    _children = [[OFMutableArray alloc] init];
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  [_children release];
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize children = _children;
//----------------------------------------------------------------------------------------------------------------------------------
- (unsigned int) borderWidth { return (unsigned int)gtk_container_get_border_width(NATIVE_CONTAINER); }
- (void) setBorderWidth:(unsigned int)border { gtk_container_set_border_width(NATIVE_CONTAINER, (guint)border); }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)add:(GtkWidget *)widget
{
  [_children addObject:widget];
  gtk_container_add(NATIVE_CONTAINER, widget.native);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)remove:(GtkWidget *)widget
{
  [_children removeObjectIdenticalTo:widget];
  if(GTK_IS_WIDGET(widget.native)) gtk_container_remove(NATIVE_CONTAINER, widget.native);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)contains:(GtkWidget *)widget
{
  for(GtkWidget *child in _children)
    if(child == widget)
      return YES;
  return NO;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkWidget *)wrapNativeChild:(void *)native
{
  GtkWidget *wrap = [GtkWidget nativeToWrapper:native];
  if(wrap == nil) wrap = [GtkWidget wrapExistingNative:native];
  [_children addObject:wrap];
  return wrap;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)wrapAllChildren
{
  //iterate native children:
  gtk_container_foreach(NATIVE_CONTAINER, WrapAllChildren_Proxy, self);
  //recurse:
  for(GtkWidget *child in _children)
    if(native_is_gtk_type_named(child.native, "GtkContainer"))
      [(GtkContainer *)child wrapAllChildren];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
