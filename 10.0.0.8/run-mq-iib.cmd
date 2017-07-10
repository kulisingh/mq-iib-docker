docker run ^
  --name mq-iib ^
  --env LICENSE=accept ^
  --env MQ_QMGR_NAME=QM1 ^
  --env NODENAME=NODE1 ^
  --publish 1414:1414 ^
  --publish 9443:9443 ^
  --publish 8090:4414 ^
  --publish 8091:7800 ^
  --volume /var/example:/mnt/mqm ^
  mq-iib-image
