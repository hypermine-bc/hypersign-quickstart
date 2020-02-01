docker-compose -f kc-pg-hs.yml config
docker-compose -f kc-pg-hs.yml down
docker-compose -f kc-pg-hs.yml up -d --remove-orphans

