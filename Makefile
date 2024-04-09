include services/vmagent-config-updater/Makefile

# k8s namespace for installing the chart
# It can be overriden via NAMESPACE environment variable
NAMESPACE ?= mimir-benchmark

# the deployment prefix
CHART_NAME := mimir-bench

# print resulting manifests to console without applying them
debug:
	helm install --dry-run --debug $(CHART_NAME) -n $(NAMESPACE) -f chart/values.dev.yaml chart/

# install the chart to configured namespace
install:
	helm upgrade -i $(CHART_NAME) -n $(NAMESPACE) -f chart/values.dev.yaml --create-namespace chart/

# delete the chart from configured namespace
delete:
	helm uninstall $(CHART_NAME) -n $(NAMESPACE)

monitor:
	kubectl -n $(NAMESPACE) port-forward deployment/$(CHART_NAME)-prometheus-benchmark-vmsingle 8428

re-install: delete install
