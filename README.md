adenosine
=========

ObjFW GTK+ wrapper

adenosine is an ObjFW specific, Objective-C wrapper for GTK+ 3. It's more than a binding, in that the normal gobject/GTK+ model is made more ObjC/ObjFW/Cocoa friendly, and many methods and types are altered/added/removed/renamed.

##Status
adenosine is not yet complete, but can currently build some very basic applications.

##Dependencies
[GTK+3](http://www.gtk.org) of course; for windows, there's a great precompile of v3 available [here](http://www.tarnyko.net/en/?q=node/20)<br/>
[atropine](https://github.com/daumiller/atropine) required (Cairo + Pango)<br/>
[WebKitGTK+](http://webkitgtk.org) if you want WebKit controls<br/>
[OFExtensions](https://github.com/daumiller/ofextensions) (which depends on PCRE) for example applications

##Screenshots
Linux:<br/>
<img src="https://raw.github.com/daumiller/adenosine/master/screenshots/screenshot00.png" /><br/>
Windows:<br/>
<img src="https://raw.github.com/daumiller/adenosine/master/screenshots/screenshot01.png" />

##License
BSD
