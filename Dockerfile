FROM mwaeckerlin/very-base as build
ENV BUILD_PKGS "alpine-sdk bash libstdc++ libc6-compat npm python3 krb5-pkinit krb5-dev krb5"
ENV RUN_PKGS "git ssh"
RUN $PKG_INSTALL $BUILD_PKGS $RUN_PKGS
RUN FORCE_NODE_VERSION=false npm install --global code-server --unsafe-perm

FROM mwaeckerlin/scratch as vscode
ENV CONTAINER "vscode"
COPY --from=build / /
CMD [code-server --auth none --bind-addr 0.0.0.0:8080]
EXPOSE 8080