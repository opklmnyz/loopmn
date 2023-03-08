#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2ray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

uuidone=3458de5e-2deb-4377-bc6b-6cbfe2ec825a
uuidtwo=2fadaa36-b92d-4bbe-8f3d-23fe40e4fc79
uuidthree=987f69d7-165f-45c3-afa1-363db01be7a7
uuidfour=f7b721bf-74df-49d6-a822-4778a3e0f8c8
uuidfive=85b26fd7-f273-4932-a20c-e2b280c9fe17
mypath=/hgkuh-yutgyf
myport=8080


# Write V2Ray configuration
cat << EOF > ${DIR_TMP}/myconfig.pb
{
	"inbounds": [
		{
			"listen": "0.0.0.0",
			"port": $myport,
			"protocol": "vless",
			"settings": {
				"decryption": "none",
				"clients": [
					{
						"id": "$uuidone"
					},
					{
						"id": "$uuidtwo"
					},
					{
						"id": "$uuidthree"
					},
					{
						"id": "$uuidfour"
					},
					{
						"id": "$uuidfive"
					}
				]
			
		},
		"streamSettings": {
			"network": "ws",
			"wsSettings": {
					"path": "$mypath"
				}
			}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom"
		}
	]
}
EOF

# Get V2Ray executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o ${DIR_TMP}/v2ray_dist.zip
unzip ${DIR_TMP}/v2ray_dist.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
mv -f ${DIR_TMP}/myconfig.pb ${DIR_CONFIG}/myconfig.json

# Install V2Ray
install -m 755 ${DIR_TMP}/v2ray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run V2Ray
${DIR_RUNTIME}/v2ray run -config=${DIR_CONFIG}/myconfig.json
