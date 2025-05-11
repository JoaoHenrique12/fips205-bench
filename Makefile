.PHONY: install
install:
	sudo apt install docker.io jq git python3-pip python3-venv
	sudo usermod -aG docker $(USER)
	echo "reboot or your machine"
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
	./graph.sh $(lst_algo) $(lst_lang)
