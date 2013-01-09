//==================================================================================================================================
// GtkTextTag.m
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
#define NATIVE_TEXTTAG ((struct _GtkTextTag *)_native)
#define ADENOSINE_NATIVE_LOOKUP_STRING "_adenosine_wrapper_texttag"

//==================================================================================================================================
@implementation GtkTextTag

//==================================================================================================================================
// Wrapping
//==================================================================================================================================
+ (BOOL) isWrapped:(void *)native
{
  return ([GtkTextTag nativeToWrapper:native] != nil);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ nativeToWrapper:(void *)native
{
  if(!G_IS_OBJECT(native)) return nil;
  return (GtkTextTag *)g_object_get_data((GObject *)native, ADENOSINE_NATIVE_LOOKUP_STRING);
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
+ textTagWithName:(OFString *)name { return [[[self alloc] initWithName:name] autorelease]; }
- initWithName:(OFString *)name
{
  self = [super init];
  if(self)
  {
    if(!name)
      _native = gtk_text_tag_new(NULL);
    else
    {
      OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
      _native = gtk_text_tag_new([name UTF8String]);
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
#define PROP_GET_STRING(prop, name)       -(OFString *)prop {gchar *a; g_object_get(_native,name,&a,NULL); OFString *b=[OFString stringWithUTF8String:a]; g_free(a); return b;}
#define PROP_SET_STRING(prop, name, setr) -(void)setr:(OFString *)prop { OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init]; g_object_set(_native,name,[prop UTF8String],NULL); [pool drain]; }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#define PROP_GET_BOOL(prop, name)       -(BOOL)prop { gboolean a; g_object_get(_native,name,&a,NULL); return (BOOL)a; }
#define PROP_SET_BOOL(prop, name, setr) -(void)setr:(BOOL)prop { g_object_set(_native,name,prop,NULL); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#define PROP_GET_INT(prop, name)       -(int)prop { gint a; g_object_get(_native,name,&a,NULL); return a; }
#define PROP_SET_INT(prop, name, setr) -(void)setr:(int)prop { g_object_set(_native,name,prop,NULL); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#define PROP_GET_COLOR(prop, name)       -(OMColor)prop { GdkRGBA *a; g_object_get(_native,name,&a,NULL); OMColor c = OMMakeColorRGBA((float)a->red, (float)a->green, (float)a->blue, (float)a->alpha); gdk_rgba_free(a); return c; }
#define PROP_SET_COLOR(prop, name, setr) -(void)setr:(OMColor)prop { GdkRGBA a; a.red=(double)prop.r; a.green=(double)prop.g; a.blue=(double)prop.b; a.alpha=(double)prop.a; g_object_set(_native,name,&a,NULL); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#define PROP_GET_ENUM(prop, name, enum)       -(enum)prop { gint a; g_object_get(_native,name,&a,NULL); return (enum)a; }
#define PROP_SET_ENUM(prop, name, enum, setr) -(void)setr:(enum)prop { g_object_set(_native,name,(int)prop,NULL); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#define PROP_GET_CASTVAL(prop, name, wrap, gtk)       -(wrap)prop { gtk a; g_object_get(_native,name,&a,NULL); return (wrap)a; }
#define PROP_SET_CASTVAL(prop, name, wrap, gtk, setr) -(void)setr:(wrap)prop { g_object_set(_native,name,(gtk)prop,NULL); }
//----------------------------------------------------------------------------------------------------------------------------------
-(void *)native { return _native; }
//----------------------------------------------------------------------------------------------------------------------------------
-(OMFont *)font { return _font; }
-(void)setFont:(OMFont *)font
{
  [_font release];
  _font = [font retain];
  g_object_set(_native, "font-desc", _font.fontData, NULL);
  //maybe atropine classes properties should be renamed to "native" (instead of "fontData"/...) for consistency?
}
//----------------------------------------------------------------------------------------------------------------------------------
-(int)priority                   { return gtk_text_tag_get_priority(NATIVE_TEXTTAG);    }
-(void)setPriority:(int)priority { gtk_text_tag_set_priority(NATIVE_TEXTTAG, priority); }
//----------------------------------------------------------------------------------------------------------------------------------
PROP_GET_STRING(name, "name")
//----------------------------------------------------------------------------------------------------------------------------------
PROP_GET_BOOL(accumulativeMargin, "accumulative-margin")
PROP_SET_BOOL(accumulativeMargin, "accumulative-margin", setAccumulativeMargin)
PROP_GET_BOOL(backgroundFullHeight, "background-full-height")
PROP_SET_BOOL(backgroundFullHeight, "background-full-height", setBackgroundFullHeight)
PROP_GET_BOOL(backgroundFullHeightSet, "background-full-height-set")
PROP_SET_BOOL(backgroundFullHeightSet, "background-full-height-set", setBackgroundFullHeightSet)
PROP_GET_COLOR(background, "background-rgba")
PROP_SET_COLOR(background, "background-rgba", setBackground)
PROP_GET_BOOL(backgroundSet, "background-set")
PROP_SET_BOOL(backgroundSet, "background-set", setBackgroundSet)
PROP_GET_ENUM(direction, "direction", GtkTextDirection)
PROP_SET_ENUM(direction, "direction", GtkTextDirection, setDirection)
PROP_GET_BOOL(editable, "editable")
PROP_SET_BOOL(editable, "editable", setEditable)
PROP_GET_BOOL(editableSet, "editable-set")
PROP_SET_BOOL(editableSet, "editable-set", setEditableSet)
PROP_GET_STRING(family, "family")
PROP_SET_STRING(family, "family", setFamily)
PROP_GET_BOOL(familySet, "family-set")
PROP_SET_BOOL(familySet, "family-set", setFamilySet)
PROP_GET_STRING(fontString, "font")
PROP_SET_STRING(fontString, "font", setFontString)
PROP_GET_COLOR(foreground, "foreground-rgba")
PROP_SET_COLOR(foreground, "foreground-rgba", setForeground)
PROP_GET_BOOL(foregroundSet, "foreground-set")
PROP_SET_BOOL(foregroundSet, "foreground-set", setForegroundSet)
PROP_GET_INT(indent, "indent")
PROP_SET_INT(indent, "indent", setIndent)
PROP_GET_BOOL(indentSet, "indent-set")
PROP_SET_BOOL(indentSet, "indent-set", setIndentSet)
PROP_GET_BOOL(invisible, "invisible")
PROP_SET_BOOL(invisible, "invisible", setInvisible)
PROP_GET_BOOL(invisibleSet, "invisible-set")
PROP_SET_BOOL(invisibleSet, "invisible-set", setInvisibleSet)
PROP_GET_STRING(language, "language")
PROP_SET_STRING(language, "language", setLanguage)
PROP_GET_BOOL(languageSet, "language-set")
PROP_SET_BOOL(languageSet, "language-set", setLanguageSet)
PROP_GET_INT(marginLeft, "left-margin")
PROP_SET_INT(marginLeft, "left-margin", setMarginLeft)
PROP_GET_BOOL(marginLeftSet, "left-margin-set")
PROP_SET_BOOL(marginLeftSet, "left-margin-set", setMarginLeftSet)
PROP_GET_INT(marginRight, "right-margin")
PROP_SET_INT(marginRight, "right-margin", setMarginRight)
PROP_GET_BOOL(marginRightSet, "right-margin-set")
PROP_SET_BOOL(marginRightSet, "right-margin-set", setMarginRightSet)
PROP_GET_COLOR(paragraphBackground, "paragraph-background-rgba")
PROP_SET_COLOR(paragraphBackground, "paragraph-background-rgba", setParagraphBackground)
PROP_GET_BOOL(paragraphBackgroundSet, "paragraph-background-set")
PROP_SET_BOOL(paragraphBackgroundSet, "paragraph-background-set", setParagraphBackgroundSet)
PROP_GET_INT(pixelsAboveLines, "pixels-above-lines")
PROP_SET_INT(pixelsAboveLines, "pixels-above-lines", setPixelsAboveLines)
PROP_GET_BOOL(pixelsAboveLinesSet, "pixels-above-lines-set")
PROP_SET_BOOL(pixelsAboveLinesSet, "pixels-above-lines-set", setPixelsAboveLinesSet)
PROP_GET_INT(pixelsBelowLines, "pixels-below-lines")
PROP_SET_INT(pixelsBelowLines, "pixels-below-lines", setPixelsBelowLines)
PROP_GET_BOOL(pixelsBelowLinesSet, "pixels-below-lines-set")
PROP_SET_BOOL(pixelsBelowLinesSet, "pixels-below-lines-set", setPixelsBelowLinesSet)
PROP_GET_INT(pixelsInsideWrap, "pixels-inside-wrap")
PROP_SET_INT(pixelsInsideWrap, "pixels-inside-wrap", setPixelsInsideWrap)
PROP_GET_BOOL(pixelsInsideWrapSet, "pixles-inside-wrap-set")
PROP_SET_BOOL(pixelsInsideWrapSet, "pixles-inside-wrap-set", setPixelsInsideWrapSet)
PROP_GET_INT(rise, "rise")
PROP_SET_INT(rise, "rise", setRise)
PROP_GET_BOOL(riseSet, "rise-set")
PROP_SET_BOOL(riseSet, "rise-set", setRiseSet)
PROP_GET_CASTVAL(scale, "scale", float, double)
PROP_SET_CASTVAL(scale, "scale", float, double, setScale)
PROP_GET_BOOL(scaleSet, "scale-set")
PROP_SET_BOOL(scaleSet, "scale-set", setScaleSet)
PROP_GET_INT(size, "size")
PROP_SET_INT(size, "size", setSize)
PROP_GET_CASTVAL(sizePoints, "size-points", float, double)
PROP_SET_CASTVAL(sizePoints, "size-points", float, double, setSizePoints)
PROP_GET_BOOL(sizeSet, "size-set")
PROP_SET_BOOL(sizeSet, "size-set", setSizeSet)
PROP_GET_ENUM(stretch, "stretch", OMFontStretch)
PROP_SET_ENUM(stretch, "stretch", OMFontStretch, setStretch)
PROP_GET_BOOL(stretchSet, "stretch-set")
PROP_SET_BOOL(stretchSet, "stretch-set", setStretchSet)
PROP_GET_BOOL(strikethrough, "strikethrough")
PROP_SET_BOOL(strikethrough, "strikethrough", setStrikethrough)
PROP_GET_BOOL(strikethroughSet, "strikethrough-set")
PROP_SET_BOOL(strikethroughSet, "strikethrough-set", setStrikethroughSet)
PROP_GET_ENUM(style, "style", OMFontStyle)
PROP_SET_ENUM(style, "style", OMFontStyle, setStyle)
PROP_GET_BOOL(styleSet, "style-set")
PROP_SET_BOOL(styleSet, "style-set", setStyleSet)
PROP_GET_ENUM(textAlign, "justification", GtkTextAlign)
PROP_SET_ENUM(textAlign, "justification", GtkTextAlign, setTextAlign)
PROP_GET_BOOL(textAlignSet, "justification-set")
PROP_SET_BOOL(textAlignSet, "justification-set", setTextAlignSet)
PROP_GET_ENUM(variant, "variant", OMFontVariant)
PROP_SET_ENUM(variant, "variant", OMFontVariant, setVariant)
PROP_GET_BOOL(variantSet, "variant-set")
PROP_SET_BOOL(variantSet, "variant-set", setVariantSet)
PROP_GET_ENUM(weight, "weight", OMFontWeight)
PROP_SET_ENUM(weight, "weight", OMFontWeight, setWeight)
PROP_GET_BOOL(weightSet, "weight-set")
PROP_SET_BOOL(weightSet, "weight-set", setWeightSet)
PROP_GET_ENUM(wrapMode, "wrap-mode", GtkTextWrap)
PROP_SET_ENUM(wrapMode, "wrap-mode", GtkTextWrap, setWrapMode)
PROP_GET_BOOL(wrapModeSet, "wrap-mode-set")
PROP_SET_BOOL(wrapModeSet, "wrap-mode-set", setWrapModeSet)

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
