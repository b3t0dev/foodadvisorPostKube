## FoodAdvisor/Kubernetes/HelmChart

Neste projeto será implementado o FoodAdvisor/Strapi usando Postgres
Será utilizado o HelmChart para as configurações do Kubernetes

## 1. Clonar o Repositório do foodadvisor
```
git clone https://github.com/strapi/foodadvisor.git
```

## 2. Configurar as variaveis ambiente na API e no Cliente do foodadvisor:

- Strapi (example in `./api/.env.example`):
  - `STRAPI_ADMIN_CLIENT_URL=http://foodadvisor.client`
  - `STRAPI_ADMIN_CLIENT_PREVIEW_SECRET=<seuToken>`

- Next.js (already in `./client/.env.development`):
  - `NEXT_PUBLIC_API_URL=http://foodadvisor.backend`
  - `PREVIEW_SECRET=<seuToken>`
    
- Obs: O token deve ser o mesmo para o Client e API


## 3. Criar as imagens Docker do Backend e do Frontend

- Dockerfile da API: (deve ser colocado dentro do diretorio: `./api/Dockerfile`
```
    FROM node:16
    
    WORKDIR /app
    
    ADD ./package.json /app
    
    ADD ./yarn.lock /app
    
    RUN yarn install --frozen-lockfile
    
    ADD . /app
    
    RUN yarn seed
    
    EXPOSE 1337
    
    CMD ["yarn", "develop"]
```

- Dockerfile do Client: (deve ser colocado dentro do diretorio: `./client/Dockerfile`
```
    FROM node:16
    
    WORKDIR /app
    
    ADD ./package.json /app
    
    ADD ./yarn.lock /app
    
    ADD ./.env.development /app
    
    RUN yarn install --frozen-lockfile
    
    ADD . /app
    
    EXPOSE 3000
    
    CMD ["yarn", "dev"]
```

## 4. Iniciar Minikube e configurar o runtime do docker (evitar que seja necessario o push das imagens para o DockerHub)

- Iniciando minikube:
```
minikube start
```
- Configurando runtime do Docker:
```
eval $(minikube docker-env)
```
  
## 5. Fazer o build das imagens docker

- Build da API (`./api`):

```
docker build -t foodadvisor-api .
```

- Build do Client (`./client`):

```
docker build -t foodadvisor-client .
```

## 6. Clonando o Repositorio, Instalando a dependencia, e Iniciando Helm:

- Clonando o repositorio:
```
git clone https://github.com/b3t0dev/foodadvisorPostKube.git
```

- Instalando a dependencia do Postgres:
```
cd ./foodadvisor-chart
helm dependency update
```

- Iniciand o Helm:
```
cd ../
helm install foodadvisor-chart ./foodadvisor-chart/ -f ./foodadvisor-chart/.secret-values.yaml
```


