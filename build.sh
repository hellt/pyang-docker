PYANG_VER="$1"

sed -i -E "s/pyang==[[:digit:]]\.[[:digit:]]\.?[[:digit:]]?/pyang==$PYANG_VER/g" Dockerfile

docker build -t hellt/pyang:$PYANG_VER .

docker push hellt/pyang:$PYANG_VER

if [ "$2" == "latest" ]; then
    docker tag hellt/pyang:$PYANG_VER hellt/pyang:latest
    docker push hellt/pyang:latest
fi
