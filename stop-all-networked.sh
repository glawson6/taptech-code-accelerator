cd ./backend/alpha-omega-cc-parent/offices-postgresql/src/test/docker
./stop-services.sh 
cd ../../../../../../
echo ${PWD}

cd ./backend/alpha-omega-cc-parent/offices-postgresql/src/test/docker
./stop-offices-postgres.sh 
cd ../../../../../../
echo ${PWD}
cd ./backend/alpha-omega-cc-parent/authentication/src/test/docker
./stop-authentication.sh 