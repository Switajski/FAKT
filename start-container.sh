# docker build . --tag "harbour-runtime"
docker run -it \
-v "$(pwd)/:/host" \
--entrypoint /bin/bash harbour-runtime 
