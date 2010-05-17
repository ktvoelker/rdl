
.PHONY: all clean

all: rdl

rdl:
	ghc --make -o rdl *.hs

clean:
	-rm *.o *.hi rdl

