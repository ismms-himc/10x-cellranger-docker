#!/usr/bin/env python3

# Attempts to transfer the GRCh38 reference transcriptome and raw data via GUI
# and AWS CLI failed. We use boto3 instead.

# https://stackoverflow.com/questions/34303775/complete-a-multipart-upload-with-boto3

import boto3
import argparse

def upload_file( filename, destination_bucket, destination_path ):
    session = boto3.Session()
    s3_client = session.client( 's3' )

    try:
        print("Uploading file:", filename)

        transfer_config = boto3.s3.transfer.TransferConfig()
        s3_transfer = boto3.s3.transfer.S3Transfer( client=s3_client, 
                                         config=transfer_config )

        s3_transfer.upload_file( filename, destination_bucket, 
        	destination_path )

    except Exception as e:
        print("Error uploading: %s" % ( e ))

def main():
	parser = argparse.ArgumentParser()
	parser.add_argument("filename")
	parser.add_argument("destination_bucket")
	parser.add_argument("destination_path")

	args = parser.parse_args()
	print(args)
	upload_file(args.filename, args.destination_bucket, args.destination_path)

if __name__ == "__main__":
	main()