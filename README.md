# Make Docker Image

$ docker build -t litd/docker-cellranger .
$ docker run -it --rm -p 8087:80 litd/docker-cellranger

# Dockerfile Overview

10X Genomics Cell Ranger Suite

CentOS 7

bcl2fastq2 v2.19 (06/13/2017)

cellranger v2.0.1 (07/18/2017)

# Local Directory Structure
- `cellranger-2.1.0.tar.gz`
- `Dockerfile`
- `GRCh38` (downloaded from Minerva via the following command: `scp -r davilm04@minerva.hpc.mssm.edu:/hpc/packages/minerva-common/cellranger/2.1.0/refdata-cellranger-1.2.0/GRCh38 .`)
- `README.md`
- `s3_large_file_upload.py`
- `tiny-bcl` (downloaded from 10X website)

# Steps After Running the Docker Container

1. `mkdir fastqs`
2. `cd fastqs`
3. `cellranger mkfastq --id=test_sample --run=/tiny-bcl/cellranger-tiny-bcl-1.2.0/ --csv=/tiny-bcl/cellranger-tiny-bcl-samplesheet-1.2.0.csv --localmem=6`
4. `cd ..`
5. `mkdir cellranger_count_output`
5. `cd cellranger_count_ouput`
6. `cellranger count --id=test_sample --fastqs=/fastqs/test_sample/outs/fastq_path/p1/s1 --sample=test_sample --expect-cells=100 --transcriptome=/GRCh38 --chemistry=SC3Pv2 --localmem=6`

# Command to Run

  ### `cellranger mkfastq`
  cellranger mkfastq --id=tiny-bcl --run=/tiny-bcl/cellranger-tiny-bcl-1.2.0/ --csv=/tiny-bcl/cellranger-tiny-bcl-samplesheet-1.2.0.csv


  ### `cellranger count`

  Example input
  $ cellranger count --id=sample345 \
                      --transcriptome=/opt/refdata-cellranger-GRCh38-1.2.0 \
                      --fastqs=/home/jdoe/runs/HAW../outs/fastq_path \
                      --sample=mysample \
                      --expect-cells=1000

  I had run the following on Minerva

    >> cellranger count --id=tiny-bcl2 --fastqs=H35KCBCXY/outs/fastq_path --sample=test_sample --cells=1000 --transcriptome=/hpc/packages/minerva-common/cellranger/1.3.1/refdata-cellranger-1.2.0/hg19

  on the tiny-bcl2 example.


# System Requirements (from [10X Genomics](https://support.10xgenomics.com/single-cell-gene-expression/software/overview/system-requirements))

System Requirements
Cell Ranger
Cell Ranger pipelines run on Linux systems that meet these minimum requirements:

8-core Intel or AMD processor (16 recommended)
64GB RAM (128GB recommended)
1TB free disk space
64-bit CentOS/RedHat 5.5 or Ubuntu 10.04
The pipelines also run on clusters that meet these minimum requirements:

8-core Intel or AMD processor per node
6GB RAM per core
Shared filesystem (e.g. NFS)
SGE or LSF
In addition, Cell Ranger must be run on a system with the following software pre-installed:

Illumina bcl2fastq
bcl2fastq 2.17 or higher is preferred and supports most sequencers running RTA version 1.18.54 or higher. If you are using a NovaSeq, please use version 2.20 or higher. If your sequencer is running an older version of RTA, then bcl2fastq 1.8.4 is required by Illumina.

All other software dependencies come bundled in the Cell Ranger package.