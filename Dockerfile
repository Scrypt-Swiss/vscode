FROM mwaeckerlin/very-base as build
ENV BUILD_PKGS "alpine-sdk bash libstdc++ libc6-compat npm python3 krb5-pkinit krb5-dev krb5"
ENV RUN_PKGS "git openssh"
RUN $PKG_INSTALL $BUILD_PKGS $RUN_PKGS
RUN FORCE_NODE_VERSION=false npm install --global code-server --unsafe-perm
RUN sed -i 's,^\(somebody:.*:\)'"${RUN_HOME}"':/sbin/nologin$,\1/code:/bin/bash,' /etc/passwd
RUN sed -i 's,^\(root:.*:\)/bin/[^.]*sh$,\1/sbin/nologin,' /etc/passwd

#COPY --chown=${RUN_USER}:${RUN_GROUP} /root/.npm ${RUN_HOME}/.npm

FROM mwaeckerlin/scratch as vscode
ENV CONTAINERNAME "vscode"
ENV PROMPT_COMMAND ''
COPY --from=build / /
ENTRYPOINT [ "/usr/local/bin/code-server",  "--bind-addr", "0.0.0.0:8080" ]
CMD ["--auth", "none"]
EXPOSE 8080