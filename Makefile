all: test

.PHONY: test

test: 
	pushd test && \
	pdflatex -interaction=batchmode  test.tex ;\
	popd ;\
	busted test/test.lua;

	
