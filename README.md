# Nick Docker image

  Pull the image from dockerhub using

    $ docker pull cornhundred/dockerized-cellranger-nick

  Run the docker image using

    $ docker run -it --rm -p 8087:80 cornhundred/dockerized-cellranger-nick

# Running Cellranger in the Docker Container

  ### `cellranger mkfastq`

  Cellranger mkfastq is pre-run in the Dockerfile

  RUN cellranger mkfastq --id=tiny-bcl-fastqs --run=/tiny-bcl/cellranger-tiny-bcl-1.2.0/ --csv=/tiny-bcl/cellranger-tiny-bcl-samplesheet-1.2.0.csv --localmem=6

  and does not need to be run in the docker container.

  ### `cellranger count`

  Use the following command in the docker container

  $ cellranger count --id=test_sample --fastqs=/tiny-bcl-fastqs/outs/fastq_path/p1/s1 --sample=test_sample --chemistry=SC3Pv2 --expect-cells=100  --localmem=6 --transcriptome=/refdata-cellranger-GRCh38-1.2.0

  On mac docker this is failing at STAR load SA.
