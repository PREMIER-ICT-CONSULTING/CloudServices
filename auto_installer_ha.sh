
sudo microk8s kubectl create namespace argocd
sudo microk8s kubectl apply -n argocd -f ./installer/install_ha.yaml

# sudo microk8s kubectl apply -f ./control_plane/00-role.yml -f ./control_plane/00-account.yml -f ./control_plane/01-role-binding.yml -f ./control_plane/02-traefik.yml -f ./control_plane/02-traefik-services.yml


sudo microk8s kubectl create namespace whoami
sudo microk8s kubectl apply -f ./control_plane/03-whoami.yml -f ./control_plane/03-whoami-services.yml -f ./control_plane/04-whoami-ingress.yml