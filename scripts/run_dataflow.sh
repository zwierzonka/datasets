#!/usr/bin/env bash

DATASET_NAME=wikipedia/20191101.pl
GCP_PROJECT=sc-8395-kraken-prod
GCP_BUCKET=gs://polish_language_model_data
GCP_REGION=europe-west1

JOB_NAME="${DATASET_NAME//[_\.\/]/-}"

#echo "tensorflow_datasets[$DATASET_NAME]" > /tmp/beam_requirements.txt

python -m tensorflow_datasets.scripts.download_and_prepare \
  --datasets=$DATASET_NAME \
  --data_dir=$GCP_BUCKET/tensorflow_datasets \
  --register_checksums \
  --beam_pipeline_options=\
"runner=DataflowRunner,project=$GCP_PROJECT,job_name=$JOB_NAME,region=$GCP_REGION,"\
"staging_location=$GCP_BUCKET/binaries,temp_location=$GCP_BUCKET/temp,"\
"requirements_file=/tmp/beam_requirements.txt"