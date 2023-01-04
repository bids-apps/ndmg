FROM bids/base_fsl:5.0.9-3

# MAINTAINER Greg Kiar <gkiar@jhu.edu>

RUN apt-get update -qq && \
    apt-get install -qq -y --no-install-recommends \
        ca-certificates \
        python-dev \
        python-setuptools \
        python-numpy \
        python-scipy \
        zlib1g-dev \
        python-matplotlib \
        python-nose \
        fsl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN easy_install pip
RUN apt-get update -qq && \
    apt-get install -qq -y --no-install-recommends \
        libpng-dev \
        libfreetype6-dev \
        pkg-config zip \
        python-vtk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN pip install \
            cython \
            numpy \
            coveralls \
            wget \
            scipy==0.14 \
            nibabel \
            dipy \
            networkx \
            awscli \
            boto3 \
            plotly==1.12.9 \
            python-dateutil==2.5 \
            requests==2.5.3 \
            pyvtk matplotlib==1.5.1 \
            scikit-learn \
            scikit-image \
            nilearn \
            ndmg==0.1.0

# Get atlases
RUN mkdir /ndmg_atlases && \
    aws s3 cp s3://mrneurodata/data/resources/ndmg_atlases.zip /ndmg_atlases/ --no-sign-request && \
    cd /ndmg_atlases && unzip /ndmg_atlases/ndmg_atlases.zip && \
    rm /ndmg_atlases/ndmg_atlases.zip

COPY version /version
ENV MPLCONFIGDIR /tmp/matplotlib
ENV PYTHONWARNINGS ignore

RUN mkdir /data &&\
    chmod -R 777 /data
RUN ldconfig
RUN chmod -R 777 /usr/local/bin/ndmg_bids

ENTRYPOINT ["ndmg_bids"]
