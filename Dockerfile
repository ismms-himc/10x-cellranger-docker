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
# COPY refdata-cellranger/refdata-cellranger-GRCh38-1.2.0 refdata-cellranger-GRCh38-1.2.0/

# Install cellranger
RUN cd /tmp/ && \
	mv cellranger-2.1.0.tar.gz /opt/ && \
	cd /opt/ && \
	tar -xzvf cellranger-2.1.0.tar.gz && \
	rm -f cellranger-2.1.0.tar.gz


# Install s3fs fuse
RUN cd /tmp/ && \
	yum install automake fuse fuse-devel gcc-c++ git libcurl-devel libxml2-devel make openssl-devel

# git clone https://github.com/s3fs-fuse/s3fs-fuse.git
# cd s3fs-fuse
# ./autogen.sh
# ./configure
# make
# sudo make install

# path
ENV PATH /opt/cellranger-2.1.0:$PATH

# Adding entrypoint, allows us to pass our AWS
# batch job `mkfastq` instead of `cellranger mkfastq`
ENTRYPOINT ["cellranger"]