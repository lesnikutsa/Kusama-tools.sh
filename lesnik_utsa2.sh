#!/bin/bash
# Default variables
function="install"

# Options
. <(wget -qO- https://raw.githubusercontent.com/letsnode/Utils/main/bashbuilder/colors.sh) --
option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/lesnikutsa/lesnik_utsa/refs/heads/main/scripts/logo_old)
		echo
		echo -e "${C_LGn}Functionality${RES}: the script performs many actions related to a Kusama node"
		echo
		echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -h,  --help    show the help page"
		echo -e "  -u,  --update  update the node"
		echo
		echo -e "${C_LGn}Useful URLs${RES}:"
		echo -e "https://raw.githubusercontent.com/letsnode/Utils/main/installers/golang.sh - script URL"
		echo -e "https://utsa.gitbook.io/services — guides and articles"
		echo
		return 0 2>/dev/null; exit 0
		;;
	-u|--update)
		function="update"
		shift
		;;
	*|--)
		break
		;;
	esac
done

# Functions
printf_n(){ printf "$1\n" "${@:2}"; }
install() {
	printf_n "${C_R}I don't want.${RES}"
}
update() {
	printf_n "${C_LGn}Checking for update...${RES}"
	status=`docker pull parity/polkadot`
	if ! grep -q "Image is up to date for" <<< "$status"; then
		printf_n "${C_LGn}Updating...${RES}"
		docker stop kusama_lesnik
		docker rm kusama_lesnik
		docker run -dit --name kusama_lesnik --restart always --network host -v $HOME/.kusama:/data -u $(id -u ${USER}):$(id -g ${USER}) parity/polkadot:latest --base-path /data --chain kusama --validator --name "lesnik_utsa2" --state-pruning 16 --blocks-pruning 16 --insecure-validator-i-know-what-i-do --public-addr /ip4/$(wget -qO- eth0.me)/tcp/30333 --port 30333 --rpc-port 9933 --prometheus-port 9615 --in-peers 12 --out-peers 8 --telemetry-url "wss://telemetry-backend.w3f.community/submit/ 1" --telemetry-url "wss://telemetry.polkadot.io/submit/ 0"
	else
		printf_n "${C_LGn}Node version is current!${RES}"
	fi
}

# Actions
. <(wget -qO- https://raw.githubusercontent.com/lesnikutsa/lesnik_utsa/refs/heads/main/scripts/logo_old)
cd
$function
