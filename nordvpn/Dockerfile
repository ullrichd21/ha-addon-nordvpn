FROM debian:bookworm-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#Debug...
RUN apt-get update && apt-get install -y --no-install-recommends libcap2-bin && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates curl iproute2 iptables iputils-ping procps jq \
	&& rm -rf /var/lib/apt/lists/*

# Install NordVPN
RUN curl -fsSL -o /tmp/nordvpn-release.deb https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/n/nordvpn-release/nordvpn-release_1.0.0_all.deb \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends /tmp/nordvpn-release.deb \
	&& rm -f /tmp/nordvpn-release.deb \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends nordvpn \
	&& rm -rf /var/lib/apt/lists/*

COPY run.sh /usr/bin/run.sh
RUN chmod 755 /usr/bin/run.sh

CMD ["/bin/bash", "/usr/bin/run.sh"]