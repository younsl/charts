# karpenter-nodepool

여러 개의 `nodepool`과 `ec2nodeclass`를 한 차트에서 관리하기 위해 만들어진 Karpenter CRD 차트입니다.

&nbsp;

## 준비사항

`karpenter` 차트가 미리 설치되어 있어야 합니다.

&nbsp;

## 사용법

### 설치

`karpenter-nodepool` 차트를 설치합니다.

```bash
helm upgrade \
  --install \
  --namespace kube-system \
  karpenter-nodepool . \
  --values values.yaml \
  --wait
```

&nbsp;

`karpenter-nodepool` 차트에는 NodePool과 EC2NodeClass 커스텀 리소스가 포함되어 있습니다.

```bash
$ kubectl api-resources --categories karpenter
NAME             SHORTNAMES     APIVERSION                  NAMESPACED   KIND
ec2nodeclasses   ec2nc,ec2ncs   karpenter.k8s.aws/v1beta1   false        EC2NodeClass
nodeclaims                      karpenter.sh/v1beta1        false        NodeClaim
nodepools                       karpenter.sh/v1beta1        false        NodePool
```

&nbsp;

## 테스트

테스트 파드 배포

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: inflate
spec:
  replicas: 0
  selector:
    matchLabels:
      app: inflate
  template:
    metadata:
      labels:
        app: inflate
    spec:
      terminationGracePeriodSeconds: 0
      containers:
        - name: inflate
          image: public.ecr.aws/eks-distro/kubernetes/pause:3.7
          resources:
            requests:
              cpu: 1
EOF

kubectl scale deployment inflate --replicas 60
```

&nbsp;

`inflate` Deployment가 스케일 아웃된 이후 karpenter controller pod의 로그를 확인합니다.

Karpenter Controller가 노드 부족으로 인해 Pending에 빠진 파드를 감지한 후 새 Karpenter Node를 할당하는 지 모니터링합니다.

```bash
kubectl logs -f -n kube-system -l app.kubernetes.io/name=karpenter -c controller
```

&nbsp;

Karpenter Controller는 nodeclaim 리소스를 만들고 새 Karpenter Node(EC2)를 provisioning 합니다.

```bash
kubectl get nodeclaim -o wide
```
