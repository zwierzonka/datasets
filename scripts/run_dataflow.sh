#!/usr/bin/env bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: scripts/run_dataflow.sh dataset_config"
    echo "Example: scripts/run_dataflow.sh wikipedia/20191101.pl"
    echo "Example: scripts/run_dataflow.sh c4/pl"
    exit 0
fi

DATASET_NAME=$1
GCP_PROJECT=sc-8395-kraken-prod
GCP_BUCKET=gs://polish_language_model_data
GCP_REGION=europe-west1

DT=`date +%Y-%m-%d-%H-%M-%S`
JOB_NAME="${DATASET_NAME//[_\.\/]/-}-$DT"

#echo "tensorflow_datasets[$DATASET_NAME]" > /tmp/beam_requirements.txt

python -m tensorflow_datasets.scripts.download_and_prepare \
  --datasets=$DATASET_NAME \
  --data_dir=$GCP_BUCKET/tensorflow_datasets \
  --register_checksums \
  --beam_pipeline_options=\
"runner=DataflowRunner,project=$GCP_PROJECT,job_name=$JOB_NAME,region=$GCP_REGION,"\
"staging_location=$GCP_BUCKET/binaries,temp_location=$GCP_BUCKET/temp,"\
"requirements_file=/tmp/beam_requirements.txt"