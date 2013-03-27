//==================================================================================================================================
// GtkTextSearchResult.m
//==================================================================================================================================
#import "GtkNative.h"
#import <adenosine/adenosine.h>

//==================================================================================================================================
@implementation GtkTextSearchResult

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ textSearchResultWithMatch:(BOOL)match nativeStart:(void *)nativeStart nativeEnd:(void *)nativeEnd
{
  return [[[self alloc] initWithMatch:match nativeStart:nativeStart nativeEnd:nativeEnd] autorelease];
}

+ textSearchResultWithMatch:(BOOL)match start:(GtkTextIterator *)start end:(GtkTextIterator *)end
{
  return [[[self alloc] initWithMatch:match start:start end:end] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithMatch:(BOOL)match nativeStart:(void *)nativeStart nativeEnd:(void *)nativeEnd
{
  self = [super init];
  if(self)
  {
    _isMatch = match;
    if(nativeStart) _matchStart = [[GtkTextIterator alloc] initWithExistingNative:nativeStart];
    if(nativeEnd  ) _matchEnd   = [[GtkTextIterator alloc] initWithExistingNative:nativeEnd  ];
  }
  return self;
}

- initWithMatch:(BOOL)match start:(GtkTextIterator *)start end:(GtkTextIterator *)end
{
  self = [super init];
  if(self)
  {
    _isMatch = match;
    _matchStart = [start retain];
    _matchEnd   = [end   retain];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  [_matchStart release];
  [_matchEnd   release];
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize isMatch    = _isMatch;
@synthesize matchStart = _matchStart;
@synthesize matchEnd   = _matchEnd;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
