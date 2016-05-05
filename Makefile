
default: all

.PHONY: clean install

tex2web = tex2web

TexFiles = \
	index \
	selfstabiliz/index \
	tut/encrypt \
	tut/index \
	tut/git \
	tut/ssh \
	tut/spin \
	tut/prelim \
	tut/qemu \
	tut/pdfscan \
	tut/gentoo-install \
	tut/install \


HtmlPaths = \
	selfstabiliz tut

HtmlFiles = \
	$(addsuffix .html,$(addprefix html/,$(TexFiles)))

HtmlPaths := $(addsuffix /,html $(addprefix html/,$(HtmlPaths)))

all: $(HtmlFiles)

define ensurepath
html/$(1).html: tex/$(1).tex
	$(tex2web) -x $$< -o $$@
	chmod 0644 $$@

html/$(1).html: | $(dir html/$(1))

endef

$(eval \
	$(foreach f,$(TexFiles),$(call ensurepath,$(f))))

$(HtmlPaths):
	mkdir -p $@
	chmod 0755 $@

clean:
	rm -fr html

install: all
	rsync -prt html/ grencez.net:./public_html/

