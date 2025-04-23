.PHONY: install
install:
	sudo apt install docker jq git

.PHONY: add
add:
	./add_implementation.sh $(algo) $(lang) $(branch) $(link)
