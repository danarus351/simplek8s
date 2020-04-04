docker build -t danarus/multi_client:latest -t danarus/multi_client:$git_SHA -f ./client/Dockerfile ./client
docker build -t danarus/multi_server:latest -t danarus/multi_server:$git_SHA -f ./server/Dockerfile ./server
docker build -t danarus/multi_worker:latest -t danarus/multi_worker:$git_SHA -f ./multi_worker/Dockerfile ./client

docker push danarus/multi_client:latest
docker push danarus/multi_server:latest
docker push danarus/multi_worker:latest

docker push danarus/multi_client:$git_SHA
docker push danarus/multi_server:$git_SHA
docker push danarus/multi_worker:$git_SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=danarus/multi_server:$git_SHA
kubectl set image deployments/client-deployment client=danarus/multi_client:$git_SHA
kubectl set image deployments/worker-deployment worker=danarus/multi_worker:$git_SHA