//==================================================================================================================================
// GtkFontButton.m
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
#import <atropine/atropine.h>

//==================================================================================================================================
#define NATIVE_WIDGET     ((struct _GtkWidget      *)_native)
#define NATIVE_BUTTON     ((struct _GtkButton      *)_native)
#define NATIVE_CHOOSER    ((struct _GtkFontChooser *)_native)
#define NATIVE_FONTBUTTON ((struct _GtkFontButton  *)_native)

//==================================================================================================================================
// Proxies
//==================================================================================================================================
static void ConnectionProxy_FontSet(struct _GtkFontButton *fontButton, void *data)
{
  GtkFontButton *obj = (GtkFontButton *)[GtkWidget nativeToWrapper:(void *)fontButton];
  [obj onFontSet:obj.font];
}

//==================================================================================================================================
// GtkFontChooser Proxies
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
@implementation GtkFontButton

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ fontButton                                      { return [[[self alloc] init                         ] autorelease]; }
+ fontButtonWithFont:(OMFont *)font               { return [[[self alloc] initWithFont      :font      ] autorelease]; }
+ fontButtonWithFontString:(OFString *)fontString { return [[[self alloc] initWithFontString:fontString] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initFontButton
{
  self = [super init];
  if(self)
  {
    _native = gtk_font_button_new();
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithFont:(OMFont *)font
{
  self = [super init];
  if(self)
  {
    _native = gtk_font_button_new();
    [self installNativeLookup];
    self.font = font;
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithFontString:(OFString *)fontString
{
  self = [super init];
  if(self)
  {
    _native = gtk_font_button_new();
    [self installNativeLookup];
    self.fontString = fontString;
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  [_font release];
  [super dealloc];
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(BOOL)showStyle                    { return gtk_font_button_get_show_style(NATIVE_FONTBUTTON);            }
-(void)setShowStyle:(BOOL)showStyle {        gtk_font_button_set_show_style(NATIVE_FONTBUTTON, showStyle); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)showSize                     { return gtk_font_button_get_show_size(NATIVE_FONTBUTTON);             }
-(void)setShowSize:(BOOL)showSize   {        gtk_font_button_set_show_size(NATIVE_FONTBUTTON, showSize);   }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)useFont                      { return gtk_font_button_get_use_font(NATIVE_FONTBUTTON);              }
-(void)setUseFont:(BOOL)useFont     {        gtk_font_button_set_use_font(NATIVE_FONTBUTTON, useFont);     }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)useSize                      { return gtk_font_button_get_use_size(NATIVE_FONTBUTTON);              }
-(void)setUseSize:(BOOL)useSize     {        gtk_font_button_set_use_size(NATIVE_FONTBUTTON, useSize);     }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFString *)dialogTitle { return [OFString stringWithUTF8String:gtk_font_button_get_title(NATIVE_FONTBUTTON)]; }
-(void)setDialogTitle:(OFString *)dialogTitle
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_font_button_set_title(NATIVE_FONTBUTTON, [dialogTitle UTF8String]);
  [pool drain];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setDelegate:(id)delegate
{
  [super setDelegate:delegate];
  
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkFontButton:fontSet:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "font-set", G_CALLBACK(ConnectionProxy_FontSet),NULL)]];
  }
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onFontSet:(OMFont *)font
{
  [_delegate gtkFontButton:self fontSet:font];
}

//==================================================================================================================================
// GtkFontChooser Properites
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
// GtkFontChooser Utilities
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
