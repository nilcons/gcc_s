all: clean check_param run

# Debian default
CC_system=/usr/bin/gcc
HS_system=/usr/bin/ghc

# My patched glibc + ghc
CC_patched=/nix/store/3218srxz8av43qmjaxzj4w7x6yfx7vw9-gcc-wrapper-4.8.3/bin/gcc
HS_patched=/nix/store/zi4fzsd70jy8l5jafj6sq9xpjimb3z14-ghc-7.8.3-wrapper/bin/ghc

# Nix's default glibc + ghc right now
CC_nix=/nix/store/12a0cqxj5gzbacsz3awwaid567ig19cq-gcc-wrapper-4.8.3/bin/gcc
HS_nix=/nix/store/1kr7qi2vdvb0r2lz9ghazp56g0dsx27c-ghc-7.8.3-wrapper/bin/ghc

check_param:
	@case "$(FLAVOR)" in \
	  system) \
	    ;; \
	  patched) \
	    ;; \
	  nix) \
	    ;; \
	  *) \
	    echo "Have to specify FLAVOR={system|patched|nix}"; \
	    false \
	  ;; \
	esac

clean:
	rm -f *.so *.o *.hi ctest hstest

ctest.o: ctest.c
	$(CC_${FLAVOR}) -fpic -Wall -c ctest.c -o ctest.o

libctest.so: ctest.o
	$(CC_${FLAVOR}) -shared -o libctest.so ctest.o

ctest: libctest.so cmain.c
	$(CC_${FLAVOR}) -L. -Wall -lpthread -lctest -o ctest cmain.c

hstest: ctest.o test.hs
	$(HS_${FLAVOR}) --make -L. -lctest -o hstest test.hs

run: ctest hstest
	@echo running
	@LD_LIBRARY_PATH=. ./ctest || true
	@LD_LIBRARY_PATH=. ./hstest || true
