all: test

.PHONY: test

test: 
	pushd test && \
	pdflatex -interaction=nonstopmode  test.tex ;\
	popd ;\
	busted test/test.lua;

	
