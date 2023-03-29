# Local Setup

To setup the egov-pdf service in your local system, clone the [works repository](https://github.com/egovernments/DIGIT-Works).

## Dependencies

### Infra Dependency

- [ ] Postgres DB
- [ ] Redis
- [ ] Elasticsearch
- [ ] Kafka
  - [ ] Consumer
  - [ ] Producer

## Running Locally

- To run the ws-services in local system, you need to port forward below services.

```bash
 function kgpt(){kubectl get pods -n egov --selector=app=$1 --no-headers=true | head -n1 | awk '{print $1}'}
 kubectl port-forward -n egov $(kgpt egov-mdms-service) 8083:8080 &
 kubectl port-forward -n egov $(kgpt pdf-service) 8082:8080 &
 kubectl port-forward -n egov $(kgpt works-project_management_system) 8081:8080
``` 

- Update below listed properties in `config.js` before running the project:

```ini
mdms: process.env.EGOV_MDMS_HOST || HOST || "http://localhost:8083/",
pdf: process.env.EGOV_PDF_HOST || HOST || "http://localhost:8082/",
projectDetails:  process.env.EGOV_PROJECT_HOST || HOST || 'http://localhost:8081/'
```
- Open the terminal and run the following command
    - `cd [filepath to egov-pdf service]`
    - `npm install`
    - `npm start`