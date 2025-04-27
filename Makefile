.PHONY: install
install:
	sudo apt install docker jq git

.PHONY: add
add:
	./add_implementation.sh $(algo) $(lang) $(branch) $(link)

.PHONY: run
run:
	echo "run tests for one or more implementations"

.PHONY: digest
digest:
	echo "digest all missing files"

.PHONY: graph
graph:
	echo "create a graph for each digest"
