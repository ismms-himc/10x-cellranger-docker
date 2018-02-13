###############################################
### Dockerfile for 10X Genomics Cell Ranger ###
###############################################

# Based on
FROM centos:7

# File Author / Maintainer
MAINTAINER Tiandao Li <litd99@gmail.com>

# Install some utilities
RUN yum install -y \
	file \
	git \
	sssd-client \
	which \
	wget \
	unzip

# Install bcl2fastq
RUN cd /tmp/ && \
	wget https://support.illumina.com/content/dam/illumina-support/documents/downloads/software/bcl2fastq/bcl2fastq2-v2-19-1-linux.zip && \
	unzip bcl2fastq2-v2-19-1-linux.zip && \
	yum -y --nogpgcheck localinstall bcl2fastq2-v2.19.1.403-Linux-x86_64.rpm && \
	rm -rf bcl2fastq2-v2-19-1-linux.zip

COPY cellranger-2.1.0.tar.gz /tmp
COPY tiny-bcl /tiny-bcl/

# Note: Reference transcriptome was scp transferred from minerva:
# /hpc/packages/minerva-common/cellranger/2.1.0/refdata-cellranger-1.2.0/GRCh38
# Reference transcriptome downloaded via wget command from 10x website did not
# work: https://support.10xgenomics.com/genome-exome/software/downloads/latest

COPY GRCh38 GRCh38/

# Sanity check below (we have these files locally but re-download them while
# building our image to be able to double check)
RUN wget http://cf.10xgenomics.com/supp/genome/refdata-GRCh38-2.1.0.tar.gz
RUN tar -xvzf refdata-GRCh38-2.1.0.tar.gz

# Install cellranger
RUN cd /tmp/ && \
	mv cellranger-2.1.0.tar.gz /opt/ && \
	cd /opt/ && \
	tar -xzvf cellranger-2.1.0.tar.gz && \
	rm -f cellranger-2.1.0.tar.gz



# path
ENV PATH /opt/cellranger-2.1.0:$PATH

# Adding entrypoint, allows us to pass our AWS
# batch job `mkfastq` instead of `cellranger mkfastq`
# ENTRYPOINT ["cellranger"]
