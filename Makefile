
default: all

.PHONY: clean install

tex2web = tex2web

SrcHtmlFiles = \
	tut/gentoo-install \
	tut/install \
	tut/pdfscan \
	tut/ssh \

SrcTexFiles = \
	index \
	selfstabiliz/index \
	tut/encrypt \
	tut/git \
	tut/ssl \
	tut/spin \
	tut/prelim \
	tut/qemu \
	tut/z3 \


HtmlPaths = \
	selfstabiliz tut

HtmlFiles = \
	$(addsuffix .html,$(addprefix html/,$(SrcTexFiles) $(SrcHtmlFiles)))

HtmlPaths := $(addsuffix /,html $(addprefix html/,$(HtmlPaths)))

all: $(HtmlFiles)

define copysrchtml
html/$(1).html: src/$(1).html
	install -m 0644 $$< $$@

html/$(1).html: | $(dir html/$(1))

endef

$(eval \
	$(foreach f,$(SrcHtmlFiles),$(call copysrchtml,$(f))))


define ensurepath
html/$(1).html: src/$(1).tex
	$(tex2web) -x $$< -o $$@
	chmod 0644 $$@

html/$(1).html: | $(dir html/$(1))

endef

$(eval \
	$(foreach f,$(SrcTexFiles),$(call ensurepath,$(f))))

$(HtmlPaths):
	mkdir -p $@
	chmod 0755 $@

clean:
	rm -fr html

install: all
	rsync -prt html/ grencez.net:/srv/grencez.net/http/

