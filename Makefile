RUNNER = ./bin/hostconfig.sh
HOSTCONFIG = .hostconfig.nix
PWD := $(shell pwd)
DIRBASE := $(shell pwd | rev | cut -d/ -f1 | rev)
HOMEMANAGER := $(shell bash -c '\
  [ "$(DIRBASE)" = "nix-darwin" ] \
    && echo "darwin-rebuild" \
    || echo "home-manager" \
')

all: hcdiffok hc switch

hc: $(HOSTCONFIG)
	$(RUNNER) > $(HOSTCONFIG) 2>/dev/null

hcdiff:
	$(RUNNER) 2>/dev/null | diff $(HOSTCONFIG) -

hcdiffok:
	$(RUNNER) 2>/dev/null | diff $(HOSTCONFIG) - ; exit 0

build:
	$(HOMEMANAGER) --flake path:. build

switch:
	$(HOMEMANAGER) --flake path:. switch

# TODO: Clean home-manager as well?
clean:
	rm $(HOSTCONFIG)
