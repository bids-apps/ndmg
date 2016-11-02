FROM bids/base_fsl
MAINTAINER Greg Kiar <gkiar@jhu.edu>
RUN apt-get update && apt-get install -y python-dev python-setuptools python-numpy python-scipy zlib1g-dev python-matplotlib python-nose fsl
RUN easy_install pip
RUN apt-get install -y libpng-dev libfreetype6-dev pkg-config
RUN pip install cython numpy coveralls wget nibabel nilearn dipy sklearn networkx awscli boto3 matplotlib==1.5.1
RUN pip install ndmg==0.0.34

# Get atlases
RUN mkdir /ndmg_atlases && wget -rnH --cut-dirs=3 --no-parent -P /ndmg_atlases http://openconnecto.me/mrdata/share/atlases/

#S3
RUN mkdir /.aws && printf "[default]\nregion = us-east-1" > /.aws/config
ADD credentials.csv /credentials.csv
RUN printf "[default]\naws_access_key_id = `tail -n 1 /credentials.csv | cut -d',' -f2`\naws_secret_access_key = `tail -n 1 /credentials.csv | cut -d',' -f3`" > /.aws/credentials && mv /.aws/  ${HOME} && rm /credentials.csv

COPY version /version

ENTRYPOINT ["ndmg_bids"]
