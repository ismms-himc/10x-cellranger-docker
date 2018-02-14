###############################################
### Dockerfile for 10X Genomics Cell Ranger ###
###############################################

# Based on
FROM python:3.5

# File Author / Maintainer
MAINTAINER Nicolas Fernandez <nickfloresfernandez@gmail.com>

# Install bcl2fastq. mkfastq requires it.
RUN apt-get update \
 && apt-get install -y alien unzip wget \
 && wget https://support.illumina.com/content/dam/illumina-support/documents/downloads/software/bcl2fastq/bcl2fastq2-v2-19-1-linux.zip \
 && unzip bcl2fastq2*.zip \
 && alien bcl2fastq2*.rpm \
 && dpkg -i bcl2fastq2*.deb \
 && rm bcl2fastq2*.deb bcl2fastq2*.rpm bcl2fastq2*.zip

# copy files into image
COPY cellranger-2.1.0.tar.gz /tmp
COPY tiny-bcl /tiny-bcl/
COPY refdata-cellranger/refdata-cellranger-GRCh38-1.2.0 refdata-cellranger-GRCh38-1.2.0/

# Install cellranger
RUN cd /tmp/ && \
	mv cellranger-2.1.0.tar.gz /opt/ && \
	cd /opt/ && \
	tar -xzvf cellranger-2.1.0.tar.gz && \
	rm -f cellranger-2.1.0.tar.gz

# Python requirements
RUN pip3 install boto3 awscli
RUN pip3 install botocore==1.7.13
RUN pip3 install awscli --upgrade
RUN pip3 install pandas

COPY common_utils /common_utils
# COPY run_cellranger_pipeline.py /

# path
ENV PATH /opt/cellranger-2.1.0:$PATH

RUN cellranger mkfastq --id=tiny-bcl-fastqs --run=/tiny-bcl/cellranger-tiny-bcl-1.2.0/ --csv=/tiny-bcl/cellranger-tiny-bcl-samplesheet-1.2.0.csv --localmem=6

# CMD cellranger count --id=test_sample --fastqs=/tiny-bcl-fastqs/outs/fastq_path/p1/s1 --sample=test_sample --chemistry=SC3Pv2 --expect-cells=100  --localmem=6 --transcriptome=/refdata-cellranger-GRCh38-1.2.0