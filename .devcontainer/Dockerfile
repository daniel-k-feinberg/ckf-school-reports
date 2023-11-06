# Pre-built Dev Container Image for R. More info: https://github.com/rocker-org/devcontainer-images/pkgs/container/devcontainer%2Ftidyverse
# Available R version: 4, 4.1, 4.0
ARG VARIANT="4.2"
FROM ghcr.io/rocker-org/devcontainer/geospatial:${VARIANT}

RUN install2.r --error --skipinstalled -n -1 \
        languageserver \
        httpgd \
        patchwork \
        paletteer \
        here \
        janitor \
        plotly \
        tidyverse \
        googledrive \
        trackdown \
        ottr \
        stargazer \
        haven \
        corrplot \
        kableExtra \
        reshape2 \
        gtsummary \
        broom \
        DT \
        readr \
        gptstudio \
    && rm -rf /tmp/downloaded_packages \
    && R -q -e 'remotes::install_github("https://github.com/dcomtois/summarytools/tree/0-8-9")'

# Install Python packages
COPY requirements.txt /tmp/pip-tmp/
RUN python3 -m pip --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt