//==================================================================================================================================
// GtkTextSearchResult.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkEnums.h>
@class GtkTextIterator;

//==================================================================================================================================
@interface GtkTextSearchResult : OFObject
{
  BOOL             _isMatch;
  GtkTextIterator *_matchStart;
  GtkTextIterator *_matchEnd;
}

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) BOOL             isMatch;
@property (retain) GtkTextIterator *matchStart;
@property (retain) GtkTextIterator *matchEnd;

//----------------------------------------------------------------------------------------------------------------------------------
+ textSearchResultWithMatch:(BOOL)match nativeStart:(void *)nativeStart nativeEnd:(void *)nativeEnd;
+ textSearchResultWithMatch:(BOOL)match start:(GtkTextIterator *)start end:(GtkTextIterator *)end;
- initWithMatch:(BOOL)match nativeStart:(void *)nativeStart nativeEnd:(void *)nativeEnd;
- initWithMatch:(BOOL)match start:(GtkTextIterator *)start end:(GtkTextIterator *)end;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
