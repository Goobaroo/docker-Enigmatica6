#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]]; then
	echo "eula=true" > eula.txt
else 
	echo "You must accept the EULA to install."
	exit 99
fi 

if ! [[ -f Enigmatica6Server-0.5.21-fixed2-electric-boogaloo.zip ]]; then
	rm -fr config defaultconfigs global_data_packs global_resource_packs mods packmenu
	curl -o Enigmatica6Server-0.5.21-fixed2-electric-boogaloo.zip https://media.forgecdn.net/files/3539/958/Enigmatica6Server-0.5.21-fixed2-electric-boogaloo.zip && unzip -u Enigmatica6Server-0.5.21-fixed2-electric-boogaloo.zip -d /data
	chmod u+x start-server.sh
fi

if [[ -n "$MAX_RAM" ]]; then
	sed -i "s/maxRam:*/maxRam: $MAX_RAM" /data/server-setup-config.yaml
fi
if [[ -n "$MOTD" ]]; then
    sed -i "s/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' > ops.txt
fi

curl -o log4j2_112-116.xml https://launcher.mojang.com/v1/objects/02937d122c86ce73319ef9975b58896fc1b491d1/log4j2_112-116.xml
if [[ $(grep log4j2_112-116.xml server-setup-config.yaml | wc -l) -eq 0 ]]; then
	sed -i "/javaArgs:/a \        - '-Dlog4j.configurationFile=log4j2_112-116.xml'" server-setup-config.yaml
fi
./start-server.sh