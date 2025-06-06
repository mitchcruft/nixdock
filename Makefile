RUNNER = ./bin/hostconfig.sh
HOSTCONFIG = .hostconfig.nix
PWD := $(shell pwd)
DIRBASE := $(shell pwd | rev | cut -d/ -f1 | rev)
HOMEMANAGER := $(shell bash -c '\
  [ "$(DIRBASE)" = "nix-darwin" ] \
    && echo "sudo darwin-rebuild" \
    || echo "home-manager" \
')

all: hc switch

hc: hcdiffok hcnodiff

dry: hcdiffok switchdry

hcdiff:
	$(RUNNER) 2>/dev/null | diff $(HOSTCONFIG) -

hcdiffok:
	$(RUNNER) 2>/dev/null | diff $(HOSTCONFIG) - ; exit 0

hcnodiff: $(HOSTCONFIG)
	$(RUNNER) > $(HOSTCONFIG) 2>/dev/null

build:
	$(HOMEMANAGER) --flake path:$(PWD) build

switch:
	$(HOMEMANAGER) --flake path:$(PWD) switch

switchdry:
	$(HOMEMANAGER) --flake path:$(PWD) switch --dry-run

# TODO: Clean home-manager as well?
clean:
	rm $(HOSTCONFIG)
