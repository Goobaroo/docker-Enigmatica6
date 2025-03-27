#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]]; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA to install."
	exit 99
fi

if ! [[ -f Enigmatica6Server-1.9.0.zip ]]; then
    rm -fr configs defaultconfigs kubejs libraries mods forge-*.jar server-setup-config.yaml server-start.* serverstarter-*.jar Enigmatica6Server-*.zip
	rm -fr config defaultconfigs global_data_packs global_resource_packs mods packmenu
	curl -Lo Enigmatica6Server-1.9.0.zip 'https://edge.forgecdn.net/files/4915/209/Enigmatica6Server-1.9.0.zip' && unzip -u -o 'Enigmatica6Server-1.9.0.zip' -d /data
	chmod u+x start-server.sh
fi

if [[ -n "$MAX_RAM" ]]; then
	sed -i "s/maxRam:.*/maxRam: $MAX_RAM/" /data/server-setup-config.yaml
fi
if [[ -n "$MOTD" ]]; then
    sed -i "s/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' > ops.txt
fi
if [[ -n "$ALLOWLIST" ]]; then
    echo $ALLOWLIST | awk -v RS=, '{print}' > white-list.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties

curl -Lo log4j2_112-116.xml https://launcher.mojang.com/v1/objects/02937d122c86ce73319ef9975b58896fc1b491d1/log4j2_112-116.xml
if [[ $(grep log4j2_112-116.xml server-setup-config.yaml | wc -l) -eq 0 ]]; then
	sed -i "/javaArgs:/a \        - '-Dlog4j.configurationFile=log4j2_112-116.xml'" server-setup-config.yaml
fi
./start-server.sh