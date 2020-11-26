FROM rocker/r-ver:3.5.3

RUN apt-get update --fix-missing -qq && \
    apt-get install -y -q \
    vim \
    git \
    python3 \
    python3-pip \
    python \
    python-pip \
    libz-dev \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libssl-dev \
    libpng-dev \
    libjpeg-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libgl-dev \
    libgsl-dev \
    && apt-get clean \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD software /home/software
ADD data /home/data
ADD scripts /home/scripts

RUN cd /home/software && git clone --branch 2.7.6a https://github.com/alexdobin/STAR.git
RUN cd /tmp && git clone --branch 1.11.0 https://github.com/samtools/htslib.git && cd htslib && make && make install
RUN cd /tmp && git clone --branch 1.11 https://github.com/samtools/samtools.git && cd samtools && make && make install
RUN cd /tmp && git clone --branch 1.11 https://github.com/samtools/bcftools.git && cd bcftools && make && make install
