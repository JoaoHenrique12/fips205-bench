.PHONY: install
install:
	sudo apt install docker jq git

.PHONY: add
add:
	./add_implementation.sh $(algo) $(lang) $(branch) $(link)

.PHONY: run
run:
	./run_tests.sh $(lst_algo) $(lst_impl)

.PHONY: digest
digest:
	echo "digest all missing files"

.PHONY: graph
graph:
	echo "create a graph for each digest"
