//==================================================================================================================================
// GtkTextSearchResult.m
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
