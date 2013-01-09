//==================================================================================================================================
// adenosine.h
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
typedef enum
{
  GTKMODIFIER_SHIFT   = 1 <<  0,
  GTKMODIFIER_LOCK    = 1 <<  1,
  GTKMODIFIER_CONTROL = 1 <<  2,
  GTKMODIFIER_MOD1    = 1 <<  3,
  GTKMODIFIER_MOD2    = 1 <<  4,
  GTKMODIFIER_MOD3    = 1 <<  5,
  GTKMODIFIER_MOD4    = 1 <<  6,
  GTKMODIFIER_MOD5    = 1 <<  7,
  GTKMODIFIER_BUTTON1 = 1 <<  8,
  GTKMODIFIER_BUTTON2 = 1 <<  9,
  GTKMODIFIER_BUTTON3 = 1 << 10,
  GTKMODIFIER_BUTTON4 = 1 << 11,
  GTKMODIFIER_BUTTON5 = 1 << 12,
  GTKMODIFIER_SUPER   = 1 << 26,
  GTKMODIFIER_HYPER   = 1 << 27,
  GTKMODIFIER_META    = 1 << 28,
  GTKMODIFIER_RELEASE = 1 << 30
} GtkModifier;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKPOSITION_LEFT,
  GTKPOSITION_TOP,
  GTKPOSITION_RIGHT,
  GTKPOSITION_BOTTOM
} GtkPosition;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKCORNER_TOPLEFT,
  GTKCORNER_BOTTOMLEFT,
  GTKCORNER_TOPRIGHT,
  GTKCORNER_BOTTOMRIGHT,
  GTKCORNER_UNSET
} GtkCorner;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKALIGN_FILL,
  GTKALIGN_START,
  GTKALIGN_END,
  GTKALIGN_CENTER
} GtkAlign;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKICONSIZE_INVALID,
  GTKICONSIZE_MENU,
  GTKICONSIZE_TOOLBAR_SMALL,
  GTKICONSIZE_TOOLBAR_LARGE,
  GTKICONSIZE_BUTTON,
  GTKICONSIZE_DND,
  GTKICONSIZE_DIALOG
} GtkIconSize;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKBORDERSHADOW_NONE,
  GTKBORDERSHADOW_BEVEL_IN,
  GTKBORDERSHADOW_BEVEL_OUT,
  GTKBORDERSHADOW_SUNKEN,
  GTKBORDERSHADOW_RAISED
} GtkBorderShadow;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKSCROLLBARSHOW_ALWAYS,
  GTKSCROLLBARSHOW_AUTOMATIC,
  GTKSCROLLBARSHOW_NEVER
} GtkScrollbarShow;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKTEXTINPUT_FREE,
  GTKTEXTINPUT_ALPHA,
  GTKTEXTINPUT_DIGITS,
  GTKTEXTINPUT_NUMBER,
  GTKTEXTINPUT_PHONE,
  GTKTEXTINPUT_URL,
  GTKTEXTINPUT_EMAIL,
  GTKTEXTINPUT_NAME,
  GTKTEXTINPUT_PASSWORD,
  GTKTEXTINPUT_PIN
} GtkTextInput;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKTEXTINPUT_HINT_NONE              =    0,
  GTKTEXTINPUT_HINT_SPELLCHECK        = 1<<0,
  GTKTEXTINPUT_HINT_NOSPELLCHECK      = 1<<1,
  GTKTEXTINPUT_HINT_WORDCOMPLETION    = 1<<2,
  GTKTEXTINPUT_HINT_LOWERCASE         = 1<<3,
  GTKTEXTINPUT_HINT_UPPERCASE         = 1<<4,
  GTKTEXTINPUT_HINT_UPPERCASEWORD     = 1<<5,
  GTKTEXTINPUT_HINT_UPPERCASESENTENCE = 1<<6,
  GTKTEXTINPUT_HINT_INHIBITOSK        = 1<<7
} GtkTextInputHint;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKTEXT_DIRECTION_NONE,
  GTKTEXT_DIRECTION_LTR,
  GTKTEXT_DIRECTION_RTL
} GtkTextDirection;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKTEXT_ALIGN_LEFT,
  GTKTEXT_ALIGN_RIGHT,
  GTKTEXT_ALIGN_CENTER,
  GTKTEXT_ALIGN_FILL
} GtkTextAlign;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKTEXT_WRAP_NONE,
  GTKTEXT_WRAP_CHAR,
  GTKTEXT_WRAP_WORD,
  GTKTEXT_WRAP_WORDCHAR
} GtkTextWrap;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKTEXTVIEW_WINDOW_PRIVATE,
  GTKTEXTVIEW_WINDOW_WIDGET,
  GTKTEXTVIEW_WINDOW_TEXT,
  GTKTEXTVIEW_WINDOW_LEFT,
  GTKTEXTVIEW_WINDOW_RIGHT,
  GTKTEXTVIEW_WINDOW_TOP,
  GTKTEXTVIEW_WINDOW_BOTTOM
} GtkTextViewWindow;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKTEXT_SEARCH_VISIBLE_ONLY     = 1<<0,
  GTKTEXT_SEARCH_TEXT_ONLY        = 1<<1,
  GTKTEXT_SEARCH_CASE_INSENSITIVE = 1<<2
} GtkTextSearchFlags;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKSCROLL_DIRECTION_UP,
  GTKSCROLL_DIRECTION_DOWN,
  GTKSCROLL_DIRECTION_LEFT,
  GTKSCROLL_DIRECTION_RIGHT,
  GTKSCROLL_DIRECTION_SMOOTH
} GtkScrollDirection;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKWIDGET_STATE_NORMAL       = 0,
  GTKWIDGET_STATE_ACTIVE       = 1<<0,
  GTKWIDGET_STATE_PRELIGHT     = 1<<1,
  GTKWIDGET_STATE_SELECTED     = 1<<2,
  GTKWIDGET_STATE_INSENSITIVE  = 1<<3,
  GTKWIDGET_STATE_INCONSISTENT = 1<<4,
  GTKWIDGET_STATE_FOCUSED      = 1<<5,
  GTKWIDGET_STATE_BACKDROP     = 1<<6
} GtkWidgetState;
//----------------------------------------------------------------------------------------------------------------------------------
