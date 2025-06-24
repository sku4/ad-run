.PHONY:

init-project-k8s:
	@./scripts/init-project-k8s.sh ad prod

helm-install:
	helm upgrade --install "ad-run" .helm --namespace=ad-prod

helm-install-local:
	helm upgrade --install "ad-run" .helm \
		--namespace=ad-prod \
		-f ./.helm/values-local.yaml \
		--wait \
		--timeout 300s \
		--atomic \
		--debug

helm-template:
	helm template --name-template="ad-run" \
		--namespace=ad-prod \
		-f .helm/values-local.yaml .helm \
		> .helm/helm.txt
