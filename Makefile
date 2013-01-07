#===================================================================================================================================
all : tests libgtk libwebkit

#===================================================================================================================================
tests : test0 test1 test2 test3 test4 test5 test6 test7 test8 test9

test0 : test0.o libgtk
	clang test0.o Gtk*.o -o test0.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test1 : test1.o libgtk
	clang test1.o Gtk*.o -o test1.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test2 : test2.o libgtk
	clang test2.o Gtk*.o -o test2.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test3 : test3.o libgtk
	clang test3.o Gtk*.o -o test3.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test4 : test4.o libgtk
	clang test4.o Gtk*.o -o test4.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test5 : test5.o libgtk
	clang test5.o Gtk*.o -o test5.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test6 : test6.o libgtk
	clang test6.o Gtk*.o -o test6.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test7 : test7.o libgtk libwebkit
	clang test7.o Gtk*.o WebKit*.o -o test7.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0 webkitgtk-3.0` `objfw-config --libs`	

test8 : test8.o libgtk
	clang test8.o Gtk*.o -o test8.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test9 : test9.o libgtk
	clang test9.o Gtk*.o -o test9.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

#===================================================================================================================================
libgtk : objgtk

objgtk : GtkBin.o            \
         GtkBox.o            \
         GtkBuilder.o        \
         GtkButton.o         \
         GtkComboBox.o       \
         GtkComboBoxText.o   \
         GtkContainer.o      \
         GtkDialog.o         \
         GtkDialogMessage.o  \
         GtkDrawingArea.o    \
         GtkEntry.o          \
         GtkEntryBuffer.o    \
         GtkFrame.o          \
         GtkGrid.o           \
         GtkImage.o          \
         GtkLabel.o          \
         GtkMenu.o           \
         GtkMenuBar.o        \
         GtkMenuCheck.o      \
         GtkMenuImage.o      \
         GtkMenuItem.o       \
         GtkMenuRadio.o      \
         GtkMenuSeparator.o  \
         GtkMenuShell.o      \
         GtkMisc.o           \
         GtkNotebook.o       \
         GtkProgressBar.o    \
         GtkRuntime.o        \
         GtkScrolledWindow.o \
         GtkTextIterator.o   \
         GtkTextTag.o        \
         GtkTextTagTable.o   \
         GtkWidget.o         \
         GtkWindow.o

#===================================================================================================================================
libwebkit : objwebkit

objwebkit : WebKitWebView.o

WebKitWebView.o : WebKitWebView.m
	clang -c WebKitWebView.m -o WebKitWebView.o -I ../ `objfw-config --cflags --objcflags` `pkg-config --cflags gtk+-3.0 webkitgtk-3.0`

#===================================================================================================================================
%.o : %.m
	clang -c $^ -o $@ -I../ `objfw-config --cflags --objcflags` `pkg-config --cflags gtk+-3.0`

#===================================================================================================================================
clean :
	rm -f *.a
	rm -f *.bin
	rm -f *.o
	rm -f dump.png
