
cd offices/src/test/docker
./start-services.sh &
cd ../../../../

echo ${PWD}

sleep 5
cd offices/src/test/docker
./start-offices-postgres.sh &