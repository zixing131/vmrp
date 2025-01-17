CC := gcc

ifeq ($(DEBUG),1)
	CFLAGS := -g -Wall -DDEBUG
	OBJS := debug.o
	CAPSTONE := ./windows/capstone-4.0.1-win32/capstone.dll
else
	CFLAGS := -Wall
	OBJS := 
	CAPSTONE := 
endif

OBJS += network.o fileLib.o font16_st.o gb2unicode.o vmrp.o tsf_font.o utils.o \
	rbtree.o bridge.o memory.o baseLib_cfunction.ext.o

UNICORN = ./windows/unicorn-1.0.2-win32/unicorn.lib

SDL2 = ./windows/SDL2-2.0.10/i686-w64-mingw32

# -Wl,-subsystem,windows gets rid of the console window
# gcc  -o main.exe main.c -lmingw32 -Wl,-subsystem,windows -L./lib -lSDL2main -lSDL2
main: $(OBJS) main.o
	$(CC) $(CFLAGS) -m32 -o ./bin/$@ $^ $(UNICORN) $(CAPSTONE) -lpthread -lm -lz \
		-lws2_32 -lmingw32  -L$(SDL2)/lib/ -lSDL2main -lSDL2

dll: $(OBJS)
	$(CC) $(CFLAGS) -m32 -shared -o ./bin/vmrp.dll $^ $(UNICORN) $(CAPSTONE) -lpthread -lm -lz -lws2_32 -lmingw32

ifeq (,$(wildcard ./bin/capstone.dll))
ifeq ($(DEBUG),1)
	cp $(CAPSTONE) ./bin/
endif
endif

ifeq (,$(wildcard ./bin/SDL2.dll))
	cp $(SDL2)/bin/SDL2.dll ./bin/
	cp ./windows/unicorn-1.0.2-win32/unicorn.dll ./bin/
endif

%.o:%.c
	$(CC) $(CFLAGS) -m32 -c $^

.PHONY: clean
clean:
	-rm *.o



