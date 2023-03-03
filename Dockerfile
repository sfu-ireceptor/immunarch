FROM r-base

# Install apt dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential file libcurl4-openssl-dev libcairo2-dev libxml2-dev libssl-dev \
    libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    libnlopt-dev muscle phylip \
    && rm -rf /var/lib/apt/lists/*

# iReceptor requirements
RUN apt-get install -y python3 && apt-get install -y python3-pip
RUN apt-get install -y zip

# Install R dependencies
RUN R -e "install.packages(c('remotes', 'svglite'))"

# Copy source files to the image
COPY . /immunarch-src/

# Install Immunarch from source
RUN R -e "remotes::install_local('/immunarch-src', dependencies=TRUE)"

# Delete Immunarch source from the image
RUN rm -rf /immunarch-src

# Check the image for Immunarch existence; fail if Immunarch not found
RUN R -e 'library("immunarch")'
