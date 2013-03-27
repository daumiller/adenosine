//==================================================================================================================================
// GtkFontChooser.ReferenceImplementation.m
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
#import <atropine/atropine.h>
#include <pango/pango.h>

/*
@interface SomeClass : GtkWidget <GtkFontChooser>
{
  OMFont *_font;
}
...
*/

//==================================================================================================================================
#define NATIVE_CHOOSER ((struct _GtkFontChooser *)_native)

//==================================================================================================================================
// Callback -> Block Proxies
//==================================================================================================================================
static gboolean BlockProxy_FilterCall(const PangoFontFamily *family, const PangoFontFace *face, gpointer data)
{
  //setup
  BOOL (^block)(OMFont *) = (BOOL (^)(OMFont *))data;
  void *fontData = pango_font_face_describe((PangoFontFace *)face);
  OMFont *font = [[OMFont alloc] initWithFontData:fontData];
  //call
  BOOL result = block(font);
  //cleanup
  [font release];
  pango_font_description_free(fontData);
  return result;
}
//----------------------------------------------------------------------------------------------------------------------------------
static void BlockProxy_FilterClean(gpointer data)
{
  [(BOOL (^)(OMFont *))data release];
}


//==================================================================================================================================
@implementation GtkFontChooser

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
-(void)dealloc
{
  [_font release];
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(OFString *)previewText
{
  return [OFString stringWithUTF8String:gtk_font_chooser_get_preview_text(NATIVE_CHOOSER)];
}

-(void)setPreviewText:(OFString *)previewText
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_font_chooser_set_preview_text(NATIVE_CHOOSER, [previewText UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)showPreviewEntry
{
  return gtk_font_chooser_get_show_preview_entry(NATIVE_CHOOSER);
}

-(void)setShowPreviewEntry:(BOOL)showPreviewEntry
{
  gtk_font_chooser_set_show_preview_entry(NATIVE_CHOOSER, showPreviewEntry);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OFString *)fontString
{
  return [OFString stringWithUTF8String:gtk_font_chooser_get_font(NATIVE_CHOOSER)];
}

-(void)setFontString:(OFString *)fontString
{
  self.font = nil;
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_font_chooser_set_font(NATIVE_CHOOSER, [fontString UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OMFont *)font
{
  void *currentNative = gtk_font_chooser_get_font_desc(NATIVE_CHOOSER);
  if(_font)
  {
    if(_font.fontData == currentNative)
      return _font;
    else
      [_font release];
  }
  _font = [[OMFont alloc] initWithFontData:currentNative];
  return _font;
}

-(void)setFont:(OMFont *)font
{
  if(_font == font)
  {
    gtk_font_chooser_set_font_desc(NATIVE_CHOOSER, (PangoFontDescription *)_font.fontData);
    return;
  }
  [_font release];
  _font = [font retain];
  gtk_font_chooser_set_font_desc(NATIVE_CHOOSER, (PangoFontDescription *)_font.fontData);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OFString *)fontFamilyName
{
  return [OFString stringWithUTF8String:pango_font_family_get_name(gtk_font_chooser_get_font_family(NATIVE_CHOOSER))];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(int)fontSize
{
  return gtk_font_chooser_get_font_size(NATIVE_CHOOSER);
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)setFontFilter:(BOOL (^)(OMFont *))block
{
  if(!block) return;
  gtk_font_chooser_set_filter_func(NATIVE_CHOOSER, BlockProxy_FilterCall, (gpointer)[block retain], BlockProxy_FilterClean);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
