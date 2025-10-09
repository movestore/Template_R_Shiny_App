########################################################################################################################
# MoveApps R-SHINY SDK
########################################################################################################################

FROM rocker/geospatial:4.5.1

LABEL org.opencontainers.image.authors="us@couchbits.com"
LABEL org.opencontainers.image.vendor="couchbits GmbH"

# Security Aspects
# Create a non-root user
ARG username=moveapps
ARG uid=1001
# group `staff` b/c of:
# When running rocker with a non-root user the docker user is still able to install packages.
# The user docker is member of the group staff and could write to /usr/local/lib/R/site-library.
# https://github.com/rocker-org/rocker/wiki/managing-users-in-docker
ARG gid=staff
ENV USER=$username
ENV UID=$uid
ENV GID=$gid
ENV HOME=/home/$USER

RUN adduser --disabled-password \
    --gecos "Non-root user" \
    --uid $UID \
    --ingroup $GID \
    --home $HOME \
    $USER
# create working dir with correct ownership
RUN install -d -o moveapps -g staff $HOME/co-pilot-r
# create cache-directory for renv with correct ownership
RUN install -d -o moveapps -g staff $HOME/.cache/R
USER $USER
WORKDIR $HOME/co-pilot-r

# Set renv environment variables
ENV RENV_PATHS_CACHE=$HOME/.cache/R/renv
ENV RENV_CONFIG_REPOS_OVERRIDE=https://cloud.r-project.org
ENV RENV_CONFIG_SANDBOX_ENABLED=FALSE

# Install renv if not available
RUN R -e "if (!requireNamespace('renv', quietly = TRUE)) install.packages('renv')"

# Copy renv files first (for better Docker layer caching)
COPY --chown=$UID:$GID renv.lock .Rprofile ./
COPY --chown=$UID:$GID renv/activate.R renv/settings.dcf ./renv/
# Restore packages
RUN R -e 'renv::restore(confirm = FALSE)'

# copy the SDK
# glob patterns to use conditional copy
COPY --chown=$UID:$GID sr[c]/ap[p]/* ./src/
COPY --chown=$UID:$GID data/ ./data/
COPY --chown=$UID:$GID sdk.R ShinyModule.R .env start-process.sh ./

# shiny port
EXPOSE 3838

ENTRYPOINT ["/bin/bash"]