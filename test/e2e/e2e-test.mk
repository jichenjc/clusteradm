export HUB_NAME := ${PROJECT_NAME}-e2e-test-hub
export MANAGED_CLUSTER1_NAME := ${PROJECT_NAME}-e2e-test-c1
export MANAGED_CLUSTER2_NAME := ${PROJECT_NAME}-e2e-test-c2

export HUB_CTX := kind-${HUB_NAME}
export MANAGED_CLUSTER1_CTX := kind-${MANAGED_CLUSTER1_NAME}
export MANAGED_CLUSTER2_CTX := kind-${MANAGED_CLUSTER2_NAME}


clean-e2e: 
	kind delete cluster --name ${HUB_NAME}
	kind delete cluster --name ${MANAGED_CLUSTER1_NAME}
	kind delete cluster --name ${MANAGED_CLUSTER2_NAME}
.PHONY: clean-e2e

# start clusters and set context variables
start-cluster: 
	kind create cluster --name ${MANAGED_CLUSTER1_NAME}
	kind create cluster --name ${MANAGED_CLUSTER2_NAME}
	kind create cluster --name ${HUB_NAME} --image kindest/node:v1.19.7@sha256:a70639454e97a4b733f9d9b67e12c01f6b0297449d5b9cbbef87473458e26dca
.PHONY: start-cluster 

test-e2e: clean-e2e start-cluster deps install
	go test -v ./test/e2e/clusteradm --timeout 1800s
.PHONY: test-e2e
