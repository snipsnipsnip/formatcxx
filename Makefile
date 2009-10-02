OUT = formatcxx.exe
OBJDIR = obj~
DISTDIR = dist~
LIBS =
CFLAGS = $(CFLAGS) /nologo /W4 /WX /MD /wd4100 /wd4127 /wd4505 /wd4210 /wd4142 /wd4530 /wd4204 /wd4819 /wd4355 /D_CRT_SECURE_NO_DEPRECATE
LINKFLAGS = /nologo /manifest /subsystem:console
O = obj
CC_OBJ_OUT_FLAG = -Fo
CC = @cl

!ifdef RELEASE
CFLAGS = $(CFLAGS) /Ot /Ox /GA /DNDEBUG /DRELEASE
!else
CFLAGS = $(CFLAGS) /Ot /Ox /DDEBUG /DGC_DEBUG
!endif

run: all
	$(OUT)

all: $(OUT)

!if exist(makefileincludeme)
include makefileincludeme
!endif

$(OUT): $(OBJDIR) $(OBJS)
	@link /out:$(OUT) $(LINKFLAGS) $(OBJS) $(LIBS)

$(OBJDIR):
	mkdir $(OBJDIR)

$(DISTDIR):
	mkdir $(DISTDIR)

clean:
	for %i in ($(OUT) $(RES)) do if exist %i del %i
	if exist $(OBJDIR) del /q $(OBJDIR) && rmdir $(OBJDIR)

distclean:
	if exist $(DISTDIR) del $(DISTDIR) && rmdir $(DISTDIR)

dist: clean $(DISTDIR)
	nmake all RELEASE=1
	copy /y $(OUT) $(DISTDIR)
	copy /y $(OUT).manifest $(DISTDIR)
	for %i in (README.txt *.dll) do if not exist $(DISTDIR)\%i copy %i $(DISTDIR)
	for %i in (data src) do if not exist $(DISTDIR)\%i svn export %i $(DISTDIR)\%i
