.PHONY:

init-project-k8s:
	@./scripts/init-project-k8s.sh ad prod

helm-install:
	helm upgrade --install "prometheus" .helm/prometheus --namespace=ad-prod
	helm upgrade --install "grafana" .helm/grafana --namespace=ad-prod

helm-install-local:
	helm upgrade --install "prometheus" .helm/prometheus --namespace=ad-prod \
		-f ./.helm/prometheus/values-local.yaml \
		--wait --timeout 300s --atomic --debug
	helm upgrade --install "grafana" .helm/grafana --namespace=ad-prod \
		-f ./.helm/grafana/values-local.yaml \
		--wait --timeout 300s --atomic --debug

helm-template:
	helm template --name-template="prometheus" .helm/prometheus --namespace=ad-prod \
		-f .helm/prometheus/values-local.yaml \
		> .helm/prometheus/helm.txt
	helm template --name-template="grafana" .helm/grafana --namespace=ad-prod \
		-f .helm/grafana/values-local.yaml \
		> .helm/grafana/helm.txt

helm-package:
	helm package .helm/prometheus
	helm package .helm/grafana
	mv prometheus*.tgz docs/charts
	mv grafana*.tgz docs/charts
	helm repo index docs/charts --url https://raw.githubusercontent.com/sku4/ad-run/refs/heads/master/docs/charts/
