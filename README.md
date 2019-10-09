# Analyze TeX log for errors

Only compilation and fatal errors are detected, no warnings or overflow and underflow boxes.

Usage 

    texlogparser filename.log

Result:


    filename	line	message
    ?	?	 LaTeX Error: File `nontxistent.sty' not found.
    ?	4	 Emergency stop.
    ?	?	  ==> Fatal error occurred, no output PDF file produced!
    ***********
    Used files
    /usr/local/texlive/2019/texmf-dist/tex/latex/base/article.cls	377
      /usr/local/texlive/2019/texmf-dist/tex/latex/base/size10.clo	129
    ?	980
