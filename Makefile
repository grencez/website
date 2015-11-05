
default: all

.PHONY: clean

tex2web = tex2web

TexFiles = \
	index \
	tut/pdfscan \
	tut/gentoo-install \


HtmlPaths = \
	tut

HtmlFiles = \
	$(addsuffix .html,$(addprefix html/,$(TexFiles)))

HtmlPaths := $(addsuffix /,html $(addprefix html/,$(HtmlPaths)))

all: $(HtmlFiles)

define ensurepath
html/$(1).html: tex/$(1).tex
	$(tex2web) -x $$< -o $$@

html/$(1).html: | $(dir html/$(1))

endef

$(eval \
	$(foreach f,$(TexFiles),$(call ensurepath,$(f))))

$(HtmlPaths):
	mkdir -p $@

clean:
	rm -fr html

