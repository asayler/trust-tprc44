REPORT=report
LATEX=pdflatex
BIBTEX=bibtex
FIG_TMP = tmp.eps

CLS = $(wildcard *.cls)
TEX = $(wildcard *.tex)
REFS = $(wildcard *.bib)
FIGS = $(patsubst %, figs/out/%.pdf, examplefig1)
SRCS = $(CLS) $(TEX) $(REFS) $(FIGS)

all: pdf

figs: $(FIGS)

pdf: $(SRCS)
	$(LATEX) $(REPORT)
	$(BIBTEX) $(REPORT)
	$(LATEX) $(REPORT)
	$(LATEX) $(REPORT)
	$(LATEX) $(REPORT)

figs/out/%.pdf: figs/src/%.svg
	inkscape --export-area-drawing --export-eps="$(FIG_TMP)" --file="$<"
	epstopdf "$(FIG_TMP)" --outfile="$@"
	rm "$(FIG_TMP)"

bibsort: $(REFS)
	$(foreach ref, $(REFS), bibtool -s -o $(ref) -i $(ref))

clean-tex:
	$(RM) *.dvi *.aux *.log *.blg *.bbl *.out *.lof *.lot *.toc

clean-fig:
	$(RM) figs/out/*.pdf *.eps

clean: clean-tex clean-fig
	$(RM) $(REPORT).pdf
	$(RM) *~ .*~
