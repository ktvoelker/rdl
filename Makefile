
.PHONY: all clean

all: rdl

rdl: *.hs
	ghc --make -o rdl *.hs

clean:
	-rm *.o *.hi rdl

