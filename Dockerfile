FROM bids/base_fsl:5.0.9-3
MAINTAINER Greg Kiar <gkiar@jhu.edu>
RUN apt-get update && apt-get install -y python-dev python-setuptools python-numpy python-scipy zlib1g-dev python-matplotlib python-nose fsl
RUN easy_install pip
RUN apt-get install -y libpng-dev libfreetype6-dev pkg-config zip python-vtk
RUN pip install cython numpy coveralls wget scipy nibabel dipy networkx awscli boto3 plotly==1.12.9 python-dateutil==2.5 requests==2.5.3 pyvtk matplotlib==1.5.1 scikit-learn scikit-image nilearn
RUN pip install ndmg==0.0.51-dev1

# Get atlases
RUN mkdir /ndmg_atlases && wget -rnH --cut-dirs=3 --no-parent -P /ndmg_atlases http://openconnecto.me/mrdata/share/atlases/

COPY version /version
ENV MPLCONFIGDIR /tmp/matplotlib

RUN mkdir /data &&\
    chmod -R 777 /data
RUN ldconfig

ENTRYPOINT ["ndmg_bids"]
