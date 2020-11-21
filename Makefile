SHELL := /bin/bash

all: plan
.PHONY: all

unlock:
	@test -f settings-secret.sh && source settings-secret.sh ; \
	rm -f terraform.plan ; \
	echo -n "LOCK ID: " ; read LOCK_ID ; terraform force-unlock -force $$LOCK_ID
.PHONY: unlock

both:
	@test -f settings-secret.sh && source settings-secret.sh ; \
	rm -f terraform.plan ; \
	terraform apply -auto-approve
.PHONY: both

qboth:
	@test -f settings-secret.sh && source settings-secret.sh ; \
	rm -f terraform.plan ; \
	terraform apply -refresh=false -auto-approve
.PHONY: qboth

clean-tf:
	-rm *.plan *.zip 2>/dev/null; true
.PHONY: clean-tf

refresh:
	@test -f settings-secret.sh && source settings-secret.sh ; \
	terraform refresh
.PHONY: refresh

quick:
	test -f settings-secret.sh && source settings-secret.sh ; \
	terraform plan -out=terraform.plan -refresh=false
.PHONY: quick

quick-plan: quick
.PHONY: quick-plan

plan-quick: quick
.PHONY: plan-quick

plan:
	test -f settings-secret.sh && source settings-secret.sh ; \
	terraform plan -out=terraform.plan
	@echo -e "\n\nDone. Run 'make apply' to apply changes.\n"
.PHONY: plan

test: plan
.PHONY: test

apply:
	@test -f settings-secret.sh && source settings-secret.sh ; \
	terraform apply terraform.plan && rm -f terraform.plan
.PHONY: apply

do: apply
.PHONY: do

destroy:
	terraform destroy
.PHONY: destroy

ashes: destroy
.PHONY: ashes

get:
	terraform get
.PHONY: get

output:
	terraform output
.PHONY: output

push:
	git push
.PHONY: push

clean-whitespace:
	Makefile-scripts/whitespace-clean.sh
.PHONY: clean-whitespace

init:
	test -f settings-secret.sh && source settings-secret.sh ; \
	set -x ; \
	terraform init --backend-config=./backend-config ; \

.PHONY: init



#
# combined targets
#

clean: clean-tf clean-whitespace
.PHONY: clean
