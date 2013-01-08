//==================================================================================================================================
// GtkTextSearchResult.h
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
