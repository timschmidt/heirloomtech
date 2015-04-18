#!/bin/sh
python ThingDoc/thingdoc --graph | dot -Tpng > docs/assembly-graph.png
python ThingDoc/thingdoc;
cd docs;
pdflatex documentation.tex;
rm documentation.aux;
rm documentation.log;
rm documentation.out;
rm documentation.toc;
cd ..;
