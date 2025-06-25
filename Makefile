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

test:
	helm repo add --force-update ad-app https://raw.githubusercontent.com/sku4/ad-run/refs/heads/master/docs/charts/
	helm repo add --force-update ad-tnt https://raw.githubusercontent.com/sku4/ad-tnt/refs/heads/master/docs/charts/
	helm repo add --force-update ad-parser https://raw.githubusercontent.com/sku4/ad-parser/refs/heads/master/docs/charts/
	helm repo add --force-update ad-notifier https://raw.githubusercontent.com/sku4/ad-notifier/refs/heads/master/docs/charts/
	helm repo add --force-update ad-api https://raw.githubusercontent.com/sku4/ad-api/refs/heads/master/docs/charts/
	helm repo update
	helm upgrade --install "prometheus" ad-app/prometheus --namespace=ad-prod --wait --timeout 300s --atomic --debug
	helm upgrade --install "grafana" ad-app/grafana --namespace=ad-prod --wait --timeout 300s --atomic --debug
	helm upgrade --install "ad-tnt" ad-tnt/ad-tnt --namespace=ad-prod --wait --timeout 300s --atomic --debug
	helm upgrade --install "ad-parser" ad-parser/ad-parser --namespace=ad-prod --wait --timeout 300s --atomic --debug
	helm upgrade --install "ad-notifier" ad-notifier/ad-notifier --namespace=ad-prod --wait --timeout 300s --atomic --debug
	helm upgrade --install "ad-api" ad-api/ad-api --namespace=ad-prod --wait --timeout 300s --atomic --debug
