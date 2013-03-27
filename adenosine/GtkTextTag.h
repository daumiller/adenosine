//==================================================================================================================================
// GtkTextTag.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkEnums.h>
#import <atropine/OMFont.h>

//==================================================================================================================================
@interface GtkTextTag : OFObject
{
  void   *_native;
  OMFont *_font;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ textTagWithName:(OFString *)name;
- initWithName:(OFString *)name;

//----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) isWrapped:(void *)native;
+ nativeToWrapper:(void *)native;
+ wrapExistingNative:(void *)native;
- initWithExistingNative:(void *)native;
-(void)installNativeLookup;
-(void)destroy;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void *native;
@property (assign)   int priority;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@property (readonly) OFString      *name;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@property (assign) BOOL             accumulativeMargin;
@property (assign) BOOL             backgroundFullHeight;
@property (assign) BOOL             backgroundFullHeightSet;
@property (assign) OMColor          background;
@property (assign) BOOL             backgroundSet;
@property (assign) GtkTextDirection direction;
@property (assign) BOOL             editable;
@property (assign) BOOL             editableSet;
@property (assign) OFString        *family;
@property (assign) BOOL             familySet;
@property (assign) OFString        *fontString;
@property (retain) OMFont          *font;
@property (assign) OMColor          foreground;
@property (assign) BOOL             foregroundSet;
@property (assign) int              indent;
@property (assign) BOOL             indentSet;
@property (assign) BOOL             invisible;
@property (assign) BOOL             invisibleSet;
@property (assign) OFString        *language;
@property (assign) BOOL             languageSet;
@property (assign) int              marginLeft;  //leftMargin
@property (assign) BOOL             marginLeftSet;
@property (assign) int              marginRight; //rightMargin
@property (assign) BOOL             marginRightSet;
@property (assign) OMColor          paragraphBackground;
@property (assign) BOOL             paragraphBackgroundSet;
@property (assign) int              pixelsAboveLines;
@property (assign) BOOL             pixelsAboveLinesSet;
@property (assign) int              pixelsBelowLines;
@property (assign) BOOL             pixelsBelowLinesSet;
@property (assign) int              pixelsInsideWrap;
@property (assign) BOOL             pixelsInsideWrapSet;
@property (assign) int              rise;
@property (assign) BOOL             riseSet;
@property (assign) float            scale;
@property (assign) BOOL             scaleSet;
@property (assign) int              size;
@property (assign) float            sizePoints;
@property (assign) BOOL             sizeSet;
@property (assign) OMFontStretch    stretch;
@property (assign) BOOL             stretchSet;
@property (assign) BOOL             strikethrough;
@property (assign) BOOL             strikethroughSet;
@property (assign) OMFontStyle      style;
@property (assign) BOOL             styleSet;
//@property (assign) tabs...
@property (assign) GtkTextAlign     textAlign;   //justification
@property (assign) BOOL             textAlignSet;
//@property (assign) underline...
@property (assign) OMFontVariant    variant;
@property (assign) BOOL             variantSet;
@property (assign) OMFontWeight     weight;
@property (assign) BOOL             weightSet;
@property (assign) GtkTextWrap      wrapMode;
@property (assign) BOOL             wrapModeSet;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
