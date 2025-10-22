# 🧑‍💻 BÀI KIỂM TRA CUỐI KHÓA - DEVOPS FUNDAMENTAL
## **DEADLINE:** 07/11/2025  
**Dự án sử dụng:** [Spring PetClinic Microservices](https://github.com/spring-petclinic/spring-petclinic-microservices)

**Thời gian thực hiện:** 14 ngày

**Hình thức nộp bài:**  
- Toàn bộ bài làm được đẩy lên repository GitHub cá nhân hoặc public organization.  
- Có file hướng dẫn, sơ đồ, và kết quả kiểm thử.  
- Đảm bảo có thể clone và chạy lại được.

---

## 🎯 MỤC TIÊU ĐÁNH GIÁ
Bài kiểm tra nhằm đánh giá:
1. **Khả năng tư duy DevOps tổng thể** – hiểu quy trình vận hành, thiết kế workflow CI/CD.
2. **Khả năng thực hành (Hands-on)** – triển khai và quản lý hạ tầng, pipeline, monitoring, logging.

---

## 🧩 CẤU TRÚC BÀI KIỂM TRA

### 🧠 PHẦN 1: TƯ DUY DEVOPS (Thiết kế & Trình bày Workflow)

#### 🎯 Mục tiêu
Đánh giá khả năng hiểu và thiết kế quy trình vận hành DevOps end-to-end cho dự án microservice, bao gồm **hai môi trường riêng biệt: Development và Production**.

#### 📋 Yêu cầu
1. Đọc và hiểu cấu trúc dự án [spring-petclinic-microservices](https://github.com/spring-petclinic/spring-petclinic-microservices).
2. Thiết kế **workflow DevOps tổng thể** cho dự án:
   - Gồm các stage: `Source → Build → Test → Dockerize → Deploy → Monitor`.
   - Cho biết công cụ dùng tại mỗi stage (VD: GitHub Action, Docker, Ansible, Helm, Prometheus, Grafana…).
   - Mô tả cách CI/CD hoạt động: trigger, artifact, environment.
   - Trình bày chiến lược rollback, versioning, secret management.
3. **Vẽ sơ đồ kiến trúc DevOps** thể hiện:
   - Workflow từ Developer → Repository → CI/CD → Infrastructure.
   - Các thành phần liên quan: GitHub, Ansible, Kubernetes, Prometheus, Grafana, ELK.
   - Có thể dùng draw.io, Lucidchart, Excalidraw hoặc Markdown (Mermaid).

#### 📦 Kết quả cần nộp
- File `workflow-diagram.png` hoặc `workflow.mmd`.
- File mô tả quy trình `workflow-explanation.md` gồm:
  - Mục tiêu từng giai đoạn.
  - Tool được sử dụng và lý do chọn.
  - Cách theo dõi, logging, alerting, rollback.

---

### 🧰 PHẦN 2: THỰC HÀNH TRIỂN KHAI (Hands-on Lab)

#### 🎯 Mục tiêu
Kiểm tra khả năng vận dụng kỹ năng DevOps đã học để triển khai ứng dụng microservice thực tế.

#### 📋 Yêu cầu chính

Triển khai dự án **Spring PetClinic Microservices** theo quy trình DevOps sau:


## 🧱 1️⃣ Chuẩn bị môi trường (Vagrant + Linux)

### 🎯 Mục tiêu
Tạo môi trường ảo hóa phục vụ triển khai hệ thống DevOps end-to-end.  
Học viên sẽ sử dụng **Vagrant** để định nghĩa và tự động dựng các máy ảo Linux phục vụ pipeline và cluster.


### 🧩 Lựa chọn mô hình triển khai

Học viên **chọn 1 trong 3 mô hình triển khai dưới đây** để thực hiện phần lab.  
Việc lựa chọn mô hình phù hợp sẽ thể hiện khả năng tư duy thiết kế hệ thống DevOps của bạn.

---

#### **🅰️ Mô hình A – 2 Virtual Machines**
> Mức độ: Cơ bản – phù hợp học viên muốn triển khai nhanh.

**Cấu trúc:**
- **VM1** – `dev-node`: Cài đặt **GitHub Runner** để pull code, build và deploy.  
- **VM2** – `deploy-node`: Cài đặt **Minikube hoặc Kind cluster**, làm môi trường triển khai ứng dụng.

**Luồng hoạt động:**
1. GitHub → Trigger workflow (GitHub Actions job).  
2. VM1 pull code, build Docker image.  
3. VM1 deploy ứng dụng lên VM2 (Minikube/k3s).

**Yêu cầu kỹ thuật:**
- OS: Ubuntu 22.04 LTS.  
- Network: cả hai VM nằm trong cùng mạng nội bộ (private network Vagrant).  
- Có thể SSH giữa các VM không cần mật khẩu.

**Kết quả cần có:**
- File `Vagrantfile` định nghĩa 2 VM (`dev-node`, `deploy-node`).  
- File `README.md` mô tả IP, role, và cách truy cập từng VM.  
- Ảnh chụp lệnh `vagrant status` và `vagrant ssh-config`.

---

#### **🅱️ Mô hình B – 4 Virtual Machines**
> Mức độ: Trung cấp – mô phỏng môi trường cluster Kubernetes thật.

**Cấu trúc:**
- **VM1** – `ci-node`: GitHub Runner, dùng để build & deploy.  
- **VM2** – `master-node`: Master node của cụm Kubernetes.  
- **VM3**, **VM4** – Worker nodes.

**Luồng hoạt động:**
1. GitHub → Trigger CI/CD workflow.  
2. VM1 pull code, build Docker images, push lên Docker Hub.  
3. VM1 deploy lên cụm Kubernetes (VM2–4).  
4. Monitoring & logging triển khai trên cụm K8S.

**Yêu cầu kỹ thuật:**
- OS: Ubuntu 22.04 LTS trên cả 4 VM.  
- Cài đặt cụm Kubernetes (bằng kubeadm hoặc Vagrant provisioning).  
- Cấu hình private network giữa các node.  
- Thiết lập SSH từ VM1 đến VM2–4.

**Kết quả cần có:**
- File `Vagrantfile` dựng cụm 4 máy.  
- Script cài cụm Kubernetes (VD: `scripts/setup_k8s_cluster.sh`).  
- Ảnh chụp `kubectl get nodes` và `vagrant status`.  
- File `ansible/inventory.ini` hoặc tài liệu mô tả IP, vai trò node.

---

#### **🅾️ Mô hình C – 3 Virtual Machines (All-in Kubernetes Cluster)**
> Mức độ: Nâng cao – triển khai toàn bộ DevOps stack trên một cụm K8S thực thụ.

**Cấu trúc:**
- **VM1** – `master-node`: Node điều phối cụm.  
- **VM2** – `worker-ci`: Worker node chứa GitHub Runner + Observability stack (Prometheus, Grafana, ELK).  
- **VM3** – `worker-app`: Worker node để deploy ứng dụng PetClinic.

**Luồng hoạt động:**
1. GitHub → Pull code trực tiếp vào Runner trên `worker-ci`.  
2. Runner build & push Docker image.  
3. Runner deploy ứng dụng vào namespace trên cluster K8S.  
4. Monitoring & Logging stack hoạt động trực tiếp trong cụm Kubernetes.

**Yêu cầu kỹ thuật:**
- OS: Ubuntu 22.04 LTS trên 3 VM.  
- Cài đặt cụm Kubernetes (bằng kubeadm hoặc Vagrant provisioning).  
- Tạo namespace riêng cho:
  - `ci` (GitHub Runner)
  - `monitoring` (Prometheus, Grafana, ELK)
  - `application` (PetClinic)
- Có thể truy cập Grafana và ứng dụng qua Ingress.

**Kết quả cần có:**
- File `Vagrantfile` dựng 3 VM.  
- Script cài cụm K8S và join node.  
- Ảnh chụp `kubectl get nodes -o wide` và dashboard Grafana.  
- File `report.md` mô tả cách tích hợp toàn bộ DevOps stack trong cụm.

---

### 📦 Yêu cầu chung cho tất cả mô hình

| Thành phần | Yêu cầu |
|-------------|----------|
| **OS** | Ubuntu 22.04 LTS |
| **RAM/CPU** | Tối thiểu 2 vCPU, 2GB RAM mỗi VM |
| **Network** | Cấu hình private network (VD: `192.168.56.x`) |
| **Provisioning** | Có thể dùng `shell provisioner` hoặc `Ansible` trong Vagrant |
| **Kiểm tra hoạt động** | Ảnh chụp `vagrant status`, `ip a`, và ping giữa các node |


### ✅ Kết quả cần nộp
- **File:** `Vagrantfile` đầy đủ (đặt ở thư mục `infra/vagrant` của repo).  
- **Thư mục:** `scripts/` chứa các script cài đặt (nếu có).  
- **Ảnh chụp:** minh chứng:
  - `vagrant status`
  - `kubectl get nodes`
  - `ping` giữa các node  
- **File mô tả:** `environment-setup.md` gồm:
  - Mô hình chọn (A, B, hoặc C).  
  - Vai trò từng VM.  
  - Thông tin IP, hostname, network.  
  - Cách khởi động và truy cập cụm.

> 💡 **Gợi ý:**  
> Nếu bạn chọn mô hình B hoặc C, có thể dùng `Vagrant + kubeadm` để tự động hóa dựng cluster.  

---

## 🧭 2️⃣ QUẢN LÝ MÃ NGUỒN VỚI GITHUB

### 🎯 Mục tiêu
Đánh giá khả năng tổ chức, quản lý và chuẩn hóa workflow làm việc với GitHub – bao gồm phân tách repository, kiểm soát commit, bảo vệ nhánh và tự động hóa kiểm tra code.

---

### 🧩 Yêu cầu chi tiết

#### **Tạo Workspace GitHub**
Bạn có thể chọn **một trong hai cách sau**:

- **Cách 1:** Tạo **Organization công khai (public)**.
  - Dành cho học viên muốn quy hoạch nhiều repository rõ ràng.  
  - Có thể tạo các repo con như:  
    - `infra-provision` → Ansible  
    - `ci-cd-pipeline` → GitHub Action  
    - `monitoring-stack` → Prometheus / Grafana / ELK  
    - `petclinic-app` → source code ứng dụng chính  
  - Tạo 1 repository **workflow-template** để dùng chung cho các repo khác (sử dụng GitHub Actions reusable workflow).

- **Cách 2:** Tạo **repository cá nhân (public)** duy nhất. Trong repo, chia thành các thư mục:
    - `infra/` → Ansible
    - `ci-cd/` → GitHub Action
    - `app/` → source code PetClinic
    - `monitoring/` → cấu hình Prometheus, Grafana
    - `logging/` → cấu hình ELK

--- 

#### **Quản lý branch và commit**
- Tạo nhánh riêng cho bài kiểm tra: `devops-final`
- Thiết lập **Branch Protection Rule** cho `main`: Không cho phép push trực tiếp (chỉ merge qua Pull Request).
- Bắt buộc **PR review ≥ 1 người** (nếu làm nhóm).
- Bật tùy chọn “Require status checks to pass before merging”.
- Tạo ít nhất **3 Pull Request** trong quá trình làm:
    1. Setup môi trường và pipeline  
    2. Deploy và cấu hình Kubernetes  
    3. Cấu hình Monitoring & Logging  

- Mỗi commit cần có message rõ ràng, tuân theo chuẩn **Conventional Commit**, ví dụ:
    - feat: add ansible playbook for docker installation
    - fix: update workflow yaml path
    - chore: refactor vagrantfile structure

---

#### **Thiết lập kiểm tra tự động (Pre-commit hooks)**
- Cài đặt **pre-commit hook** để đảm bảo code và YAML hợp lệ trước khi commit.
- Yêu cầu tối thiểu:
- Kiểm tra cú pháp YAML (`yamllint`)
- Kiểm tra lỗi shell script (`shellcheck`)
- Kiểm tra khoảng trắng thừa, end-of-file (`trailing-whitespace`, `end-of-file-fixer`)

Ví dụ file `.pre-commit-config.yaml`:
```yaml
repos:
- repo: https://github.com/pre-commit/pre-commit-hooks
  rev: v4.5.0
  hooks:
    - id: trailing-whitespace
    - id: end-of-file-fixer
- repo: https://github.com/adrienverge/yamllint
  rev: v1.32.0
  hooks:
    - id: yamllint
```

---

#### **README & Tài liệu**

- Ở mỗi repository (hoặc thư mục chính), cần có file README.md với nội dung:
    - Mục tiêu repo hoặc module.
    - Cấu trúc thư mục và mô tả chức năng.
    - Hướng dẫn setup, chạy thử, kiểm tra.
    - Workflow CI/CD liên quan (nếu có).
    - Cách kiểm thử / rollback.

---

### ✅ Kết quả cần có

| Hạng mục | Mô tả | Bắt buộc |
|-----------|--------|----------|
| 🔗 Link Organization hoặc Repository | Công khai (public) | ✅ |
| 🌳 Branch `devops-final` | Có rule protection và PR merge | ✅ |
| 🧾 Lịch sử commit | Rõ ràng, thể hiện quá trình làm | ✅ |
| 🧰 File `.pre-commit-config.yaml` | Kiểm tra tự động trước khi commit | ✅ |
| 📘 README.md | Có mô tả, hướng dẫn và workflow | ✅ |
| 🧩 Template workflow (optional) | Dùng lại cho các repo khác | ⭐ Bonus |

---

## ⚙️ 3️⃣ THIẾT LẬP CI/CD VỚI GITHUB ACTIONS

### 🎯 Mục tiêu
Thiết lập **pipeline CI/CD tự động hóa** trên GitHub Actions cho dự án PetClinic Microservices, bao gồm:
- Tự động build và test mã nguồn.  
- Đóng gói và push Docker image lên Docker Hub cá nhân.  
- Triển khai image mới lên cluster Kubernetes (Minikube, Kind, hoặc k3s tùy mô hình đã chọn).  
- Gửi thông báo kết quả deploy qua Slack.

---

### **Tổng quan yêu cầu**
Pipeline CI/CD cần có đầy đủ các stage sau:

| Stage | Mục tiêu | Mô tả chi tiết |
|--------|-----------|----------------|
| **Checkout Code** | Lấy mã nguồn mới nhất từ branch `devops-final`. | Sử dụng action `actions/checkout@v4`. |
| **Build Code** | Biên dịch project Java với Maven Wrapper. | `./mvnw clean package -DskipTests` hoặc `./mvnw package`. |
| **Test (Optional)** | Kiểm tra logic cơ bản trước khi build Docker. | `./mvnw test` – có thể bỏ qua nếu chưa có test. |
| **Build Docker Image** | Đóng gói ứng dụng thành Docker image. | Sử dụng `docker build` cho từng service. |
| **Push Docker Image** | Đưa image lên Docker Hub cá nhân. | Dùng `docker login` và `docker push`. |
| **Deploy lên Kubernetes** | Cập nhật image mới trên cluster. | Dùng `kubectl set image`, `kubectl patch`, `helm upgrade` hoặc `Ansible playbook`. |
| **Notify Result** | Thông báo trạng thái deploy. | Gửi thông báo Slack qua webhook hoặc ghi log. |

---

### Cấu trúc pipeline đề xuất
File pipeline đặt tại: `.github/workflows/deploy.yml`

---

### **Thiết lập Secrets cần thiết**
| Secret Name         | Mô tả                                                                 | Bắt buộc      |
| ------------------- | --------------------------------------------------------------------- | ------------- |
| `DOCKER_USERNAME`   | Tên tài khoản Docker Hub                                              | ✅             |
| `DOCKER_PASSWORD`   | Mật khẩu hoặc token Docker Hub                                        | ✅             |
| `KUBE_CONFIG`       | Nội dung file kubeconfig để GitHub Actions có thể kết nối đến cluster | ✅             |
| `SLACK_WEBHOOK_URL` | Webhook Slack để gửi thông báo                                        | ⚙️ (tùy chọn) |

> ⚠️ Lưu ý:
> Học viên cần encode file ~/.kube/config thành base64 trước khi lưu vào secret KUBE_CONFIG.
> Có thể generate webhook Slack tại https://api.slack.com/apps

---

### **Quy định về Tag và Version**

- Image tag nên theo một trong hai chuẩn sau:
- Theo commit SHA: `petclinic-api:<github.sha>`
- Theo versioning: `petclinic-api:v1.0.<run_number>`
- Cập nhật tag đồng nhất giữa build và deploy stage.
- Ghi lại tag hiện tại vào file deploy-log.md trong repo.
- Các image của môi trường Dev nên có prefix dev- hoặc snapshot-, để tránh nhầm lẫn với bản release.

---

### **Báo cáo bắt buộc**
Học viên cần bổ sung trong file report.md:
- Mô hình triển khai (A, B hoặc C).
- Pipeline workflow và giải thích từng stage.
- Ảnh chụp pipeline chạy thành công (build → push → deploy).
- Ảnh chụp kubectl get pods -n workload hoặc kubectl rollout status.
- Ảnh chụp Slack notification (nếu có).

---

### **Kết quả cần nộp**
| Hạng mục                        | Mô tả                           | Bắt buộc |
| ------------------------------- | ------------------------------- | -------- |
| `.github/workflows/deploy.yml`  | Pipeline đầy đủ                 | ✅        |
| `report.md`                     | Mô tả pipeline + ảnh minh chứng | ✅        |
| Ảnh chụp pipeline thành công    | Build + push + deploy           | ✅        |
| Link Docker Hub image           | Có image tag mới nhất           | ✅        |
| Ảnh chụp Slack message (nếu có) | Thông báo kết quả               | ⚙️       |

---

## ☸️ 4️⃣ TRIỂN KHAI ỨNG DỤNG LÊN KUBERNETES

### 🎯 Mục tiêu
Triển khai ứng dụng **Spring PetClinic Microservices** lên Kubernetes cluster theo mô hình DevOps thực tế, với cấu trúc namespace rõ ràng, khả năng cập nhật image linh hoạt và hỗ trợ quan sát hệ thống.

---

### **Cấu trúc Kubernetes và Namespace**

Toàn bộ cluster cần được chia thành **các namespace** tương ứng với chức năng:

| Namespace | Mục đích | Thành phần |
|------------|-----------|-------------|
| `workload` | Chạy các microservice chính của PetClinic | Config Server, Discovery, API Gateway, Customers, Vets, Visits... |
| `observability` | Giám sát hệ thống | Prometheus, Grafana |
| `logging` | Thu thập và lưu trữ log | Elasticsearch, Fluent Bit, Kibana (hoặc EFK stack) |
| `operation` | Chạy các công cụ DevOps hỗ trợ | GitHub Runner, Image Updater, hoặc các CronJob vận hành |

> 💡 **Gợi ý:**  
> - Các namespace nên được tạo qua manifest YAML hoặc Ansible để đảm bảo reproducible.  

---

### **Tổ chức repository triển khai**

Để thuận tiện cho việc quản lý image tag và CI/CD update, học viên nên tách triển khai Kubernetes ra một repository riêng (hoặc thư mục riêng biệt).

Cấu trúc đề xuất:
```
petclinic-deploy/
├── k8s/
│   ├── namespaces.yaml
│   ├── workload/
│   │   ├── config-server-deployment.yaml
│   │   ├── discovery-deployment.yaml
│   │   ├── api-gateway-deployment.yaml
│   │   ├── customers-deployment.yaml
│   │   └── vets-deployment.yaml
│   ├── observability/
│   │   ├── prometheus-values.yaml
│   │   ├── grafana-values.yaml
│   └── logging/
│       ├── elasticsearch-values.yaml
│       ├── kibana-values.yaml
│       └── fluentbit-daemonset.yaml
├── helm/
│   ├── Chart.yaml
│   ├── templates/
│   └── values.yaml
└── README.md
```

> - ✅ Nếu bạn dùng Helm, nên gom từng service vào 1 Helm chart riêng hoặc 1 chart tổng.
> - ✅ Nếu dùng manifest thuần, có thể chia theo namespace như trên.
> - ✅ Khi CI/CD cập nhật image tag, pipeline chỉ cần update chart/manifest trong repo này.

---

### **Yêu cầu triển khai ứng dụng (Namespace workload)**

1. Viết manifest hoặc Helm chart cho từng service của PetClinic:
    - Config Server
    - Discovery Server (Eureka)
    - API Gateway
    - Customers Service
    - Vets Service
    - Visits Service
2. Mỗi service cần có các resource sau:
    - Deployment
    - Service
    - ConfigMap hoặc Secret (nếu cần cấu hình môi trường)
    - Ingress (hoặc IngressRoute) để truy cập qua HTTP.
3. Các service phải chạy trong namespace workload.

---

### **Yêu cầu triển khai namespace Observability & Logging**

**Observability (`observability` namespace)**
- Dùng Helm chart kube-prometheus-stack hoặc tách riêng prometheus và grafana.
- Expose Grafana qua NodePort hoặc Ingress để truy cập dashboard.
- Import dashboard Spring Boot (ID 4701 hoặc 6756 trên Grafana).

**Logging (`logging` namespace)**
- Dùng EFK (Elasticsearch, Fluent Bit, Kibana) hoặc ELK stack.
- Fluent Bit chạy DaemonSet để thu log từ pod trong namespace workload.
- Kibana có thể truy cập qua Ingress kibana.local.

**Operation (`operation` namespace)**
- Deploy GitHub Runner (self-hosted runner cho pipeline).
- Có thể thêm các CronJob kiểm tra health hoặc cleanup.

---

### **✅ Kết quả cần có**
| Hạng mục                              | Mô tả                                       | Bắt buộc |
| ------------------------------------- | ------------------------------------------- | -------- |
| 📂 Thư mục `k8s/` hoặc `helm/`        | Chứa toàn bộ manifest hoặc chart triển khai | ✅        |
| 🗂️ File `namespaces.yaml`            | Tạo đủ 4 namespace                          | ✅        |
| 🧩 File `ingress.yaml`                | Cấu hình ingress để truy cập HTTP           | ✅        |
| 🚀 Ảnh chụp `kubectl get pods -A`     | Tất cả pod ở trạng thái `Running`           | ✅        |
| 🌐 Ảnh chụp `kubectl get svc -A`      | Có service expose ra cluster                | ✅        |
| 📸 Ảnh chụp Grafana & Kibana (nếu có) | Chứng minh observability hoạt động          | ⚙️       |

---

### 5️⃣ Thiết lập Observability
#### 🧭 Monitoring:
- Namespace sử dụng: `observability`
- Cài **Prometheus + Grafana** bằng Helm chart.
- Import dashboard sẵn có hoặc tạo dashboard hiển thị CPU, Memory, và status của các service.

#### 🧾 Logging:
- Namespace sử dụng: `logging`
- Cài **ELK Stack (Elasticsearch, Logstash, Kibana)** hoặc dùng EFK (Fluentd/Fluent Bit).
- Cấu hình log collection từ container của PetClinic ở namespace `workload`.
- Có thể tạo visualization trên Kibana.

✅ Kết quả cần có:
| Hạng mục                              | Mô tả                                 | Bắt buộc |
| ------------------------------------- | ------------------------------------- | -------- |
| 📦 Elasticsearch, Kibana chạy ổn định | Pod `logging-*` Running               | ✅        |
| 🧩 Fluent Bit thu log container       | Có index `petclinic-logs` trên Kibana | ✅        |
| 📊 Dashboard log hoạt động            | Có thể lọc log theo service           | ✅        |
| 📸 Ảnh chụp Kibana                    | Hiển thị log ứng dụng                 | ✅        |

---

### 6️⃣ Báo cáo tổng hợp
Tạo file `report.md` gồm các phần:
1. **Mô tả kiến trúc triển khai**
2. **Công cụ đã sử dụng và lý do chọn**
3. **CI/CD pipeline chi tiết**
4. **Ảnh chụp kết quả thực tế**
5. **Các khó khăn và hướng khắc phục**

---

### 🧮 Thang điểm (70 điểm)

| Thành phần | Điểm |
|-------------|------|
| Vagrant + môi trường cơ bản | 10 |
| CI/CD pipeline hoạt động | 15 |
| Ansible setup môi trường | 10 |
| Kubernetes deploy thành công | 15 |
| Observability (Prometheus + Grafana) | 10 |
| Logging (ELK/EFK) hoạt động | 5 |
| Báo cáo & trình bày | 5 |

---

## 📦 KẾT QUẢ NỘP BÀI
1. Repository GitHub hoặc Organiztion chứa toàn bộ code và tài liệu.
2. File báo cáo `report.md` và sơ đồ workflow.
3. Screenshots minh chứng pipeline, deployment, monitoring.
4. (Tùy chọn) Video demo ngắn (3–5 phút) trình bày kết quả.

---

## 🏁 TIÊU CHÍ ĐÁNH GIÁ CUỐI CÙNG

| Năng lực | Mô tả | Tỷ trọng |
|----------|-------|----------|
| Kỹ thuật triển khai (IaC, CI/CD, Monitoring) | Vận dụng công cụ thực tế | 50% |
| Tư duy hệ thống (Workflow, Pipeline Design) | Thiết kế hợp lý, hiểu luồng DevOps | 30% |
| Tổ chức repo, báo cáo, teamwork | Tài liệu, commit, rõ ràng | 20% |

---

**Chúc các bạn hoàn thành tốt bài kiểm tra cuối khóa! 💪**
