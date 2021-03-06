//==================================================================================================================================
// GtkFontChooser.ReferenceImplementation.m
//==================================================================================================================================
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
