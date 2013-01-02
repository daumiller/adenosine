#===================================================================================================================================
all : tests library

#===================================================================================================================================
tests : test0 test1 test2 test3 test4 test5

test0 : test0.o library
	clang test0.o Gtk*.o -o test0.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test1 : test1.o library
	clang test1.o Gtk*.o -o test1.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test2 : test2.o library
	clang test2.o Gtk*.o -o test2.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test3 : test3.o library
	clang test3.o Gtk*.o -o test3.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test4 : test4.o library
	clang test4.o Gtk*.o -o test4.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test5 : test5.o library
	clang test5.o Gtk*.o -o test5.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

#===================================================================================================================================
library : objects

objects : GtkBin.o          \
          GtkBox.o          \
          GtkBuilder.o      \
          GtkButton.o       \
          GtkComboBox.o     \
          GtkComboBoxText.o \
          GtkContainer.o    \
          GtkDrawingArea.o  \
          GtkFrame.o        \
          GtkGrid.o         \
          GtkImage.o        \
          GtkLabel.o        \
          GtkMisc.o         \
          GtkNotebook.o     \
          GtkProgressBar.o  \
          GtkRuntime.o      \
          GtkWidget.o       \
          GtkWindow.o

#===================================================================================================================================
%.o : %.m
	clang -c $^ -o $@ -I../ `objfw-config --cflags --objcflags` `pkg-config --cflags gtk+-3.0`

#===================================================================================================================================
clean :
	rm -f *.a
	rm -f *.bin
	rm -f *.o
	rm -f dump.png
