EXTENSION = mvtbl
EXTVERSION = $(shell grep default_version $(EXTENSION).control | \
                sed -e "s/default_version[[:space:]]*=[[:space:]]*'\([^']*\)'/\1/")
PG_CONFIG ?= pg_config
DATA = $(wildcard *--*.sql)
PGXS := $(shell $(PG_CONFIG) --pgxs)
TESTS        = $(wildcard test/sql/*.sql)
REGRESS      = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test \
			   --load-language=plpgsql \
			   --load-extension=$(EXTENSION) \
			   --temp-instance=$$PWD/tmp 
REGRESS_PREP = mktblspace
SQLSRC = $(wildcard sql/*.sql)
include $(PGXS)

all: $(EXTENSION)--$(EXTVERSION).sql

$(EXTENSION)--$(EXTVERSION).sql: $(SQLSRC)
	echo "-- complain if script is sourced in psql, rather than via CREATE EXTENSION" > $@
	echo "\echo Use \"CREATE EXTENSION ${EXTENSION}\" to load this file. \quit" >> $@
	echo "" >> $@
	cat $^ >> $@

mktblspace:
	mkdir -p /tmp/tsttblsp	