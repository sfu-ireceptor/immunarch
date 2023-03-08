FROM r-base

# Install apt dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential file libcurl4-openssl-dev libcairo2-dev libxml2-dev libssl-dev \
    libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    libnlopt-dev muscle phylip zip python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

# iReceptor requirements
ENV IRECEPTOR_FOLDER="/opt/ireceptor"
COPY ./ireceptor $IRECEPTOR_FOLDER 
RUN python3 -m venv $IRECEPTOR_FOLDER 
ENV PATH="$IRECEPTOR_FOLDER/bin:$PATH"
RUN pip3 install wheel
RUN pip3 install airr
RUN pip3 install anndata

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
