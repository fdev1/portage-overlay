
USE_KDE=0
USE_KDE4=1
DESTDIR=/
PREFIX=/usr/local
ICONS_DIR=$(PREFIX)/share/icons

CC=gcc
CXX=g++
CFLAGS=-O2
LDFLAGS=-lc -lm -lGL -lGLU -lX11 -lpthread -ldl -lrt
EXECUTABLE=qb64
SOURCES=libqb.cpp qbx.cpp
CSOURCES=parts/video/font/ttf/src/freetypeamalgam.c \
	parts/core/src/freeglut_callbacks.c \
	parts/core/src/freeglut_cursor.c \
	parts/core/src/freeglut_display.c \
	parts/core/src/freeglut_ext.c \
	parts/core/src/freeglut_font.c \
	parts/core/src/freeglut_font_data.c \
	parts/core/src/freeglut_gamemode.c \
	parts/core/src/freeglut_geometry.c \
	parts/core/src/freeglut_glutfont_definitions.c \
	parts/core/src/freeglut_init.c \
	parts/core/src/freeglut_input_devices.c \
	parts/core/src/freeglut_joystick.c \
	parts/core/src/freeglut_main.c \
	parts/core/src/freeglut_menu.c \
	parts/core/src/freeglut_misc.c \
	parts/core/src/freeglut_overlay.c \
	parts/core/src/freeglut_spaceball.c \
	parts/core/src/freeglut_state.c \
	parts/core/src/freeglut_stroke_mono_roman.c \
	parts/core/src/freeglut_stroke_roman.c \
	parts/core/src/freeglut_structure.c \
	parts/core/src/freeglut_teapot.c \
	parts/core/src/freeglut_videoresize.c \
	parts/core/src/freeglut_window.c \
	parts/core/src/freeglut_xinput.c


OBJECTS=$(CSOURCES:.c=.o) $(SOURCES:.cpp=.o)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE):  $(OBJECTS)
	$(CXX) $(LDFLAGS) -o $@ $(OBJECTS)

.cpp.o:
	$(CXX) $(CFLAGS) -DFREEGLUT_STATIC -D DEPENDENCY_LOADFONT -c -w $< -o $@
.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

	
clean:
	rm -f $(OBJECTS) $(EXECUTABLE)
	
install:
	mkdir -p $(DESTDIR)/$(PREFIX)/bin
	mkdir -p $(DESTDIR)/$(ICONS_DIR)/lock-keys
	cp tray_on.png $(DESTDIR)/$(ICONS_DIR)/lock-keys/tray_on.png
	cp tray_off.png $(DESTDIR)/$(ICONS_DIR)/lock-keys/tray_off.png
	rm -f $(DESTDIR)/$(PREFIX)/bin/$(EXECUTABLE)
	cp $(EXECUTABLE) $(DESTDIR)/$(PREFIX)/bin
	
uninstall:
	rm -rf $(DESTDIR)/$(ICONS_DIR)/lock-keys
	rm -f $(DESTDIR)/$(PREFIX)/bin/$(EXECUTABLE)

