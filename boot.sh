kind create cluster --config=kind/config.yaml

helm upgrade --install lightpanda charts/lightpanda --namespace lightpanda --create-namespace