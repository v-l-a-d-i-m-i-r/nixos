# Docker
alias d='docker'
alias docker-stop='docker stop $(docker ps -a -q)'
alias docker-rm='docker rm -f $(docker ps -a -q)'
alias docker-rmi='docker rmi -f $(docker images -q)'
alias docker-rmio='docker rmi $(docker images -f dangling=true -q)'
alias docker-image='docker run -v /var/run/docker.sock:/var/run/docker.sock --rm hub.docker.com/r/chenzj/dfimage'
alias docker-stats='watch --interval 1 docker stats --no-stream'
function docker-tags () { curl -L -s https://registry.hub.docker.com/v1/repositories/$1/tags | jq -r '.[].name' }

# Docker Compose
alias dc='docker compose '
alias dcd='docker compose down'
alias dcub='docker compose up --build'