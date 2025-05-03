.PHONY: install
install:
	sudo apt install docker jq git python3-pip python3-venv

.PHONY: add
add:
	./add_implementation.sh $(algo) $(lang) $(branch) $(link)

.PHONY: run
run:
	./run_tests.sh $(lst_algo) $(lst_impl)

.PHONY: digest
digest:
	./digest.sh $(lst_algo) $(lst_lang)

.PHONY: graph
graph:
	echo ./graph.sh $(lst_algo) $(lst_lang)
