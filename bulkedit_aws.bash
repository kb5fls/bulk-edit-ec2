#!/bin/bash

echo Enter tag key
read tag
echo Enter tag value
read value

# USER INPUT - Edit filters here 
# reference: https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html
filters="Name=tag:Name,Values=*Salem*"

echo -e '\n'
echo "EC2 instances will be included based on following filters (edit script to update):"
echo $filters

echo "Please wait while script checks each AWS region"

# This FOR loop searches for EC2 instances in each region by ID an prompts user to confirm
for region in `aws ec2 describe-regions --output text | cut -f4`
do
        echo "  ...checking $region..."
        aws ec2 describe-instances --region $region --filters $filters --query 'Reservations[*].Instances[*].[InstanceId]' --output text >> tmp-output.csv

        # Each region must be scanned individually
        export AWS_REGION=$region

        # If instances are detected in the region, prompt user to confirm adding tags
        if [ -s tmp-output.csv ]
        then
                echo "The following instances will be tagged in $region with tag '$tag:$value': "
                cat tmp-output.csv
                read -r -p "Proceed ($region)? (y/N) " response
                case "$response" in
                    [yY][eE][sS]|[yY]) 
                                # if confirmed, loop through each individual instance in given region and apply tags using aws-tagger
                                # for reference, see: https://github.com/washingtonpost/aws-tagger
                        cat tmp-output.csv | while read line || [[ -n $line ]];
                                        do
                                                echo "  tagging $line - tag:'$tag:$value'"
                                                aws-tagger --resource $line --tag "$tag:$value" 
                                                #> /dev/null 2>&1
                                        done
                                echo "$region done"
                        ;;
                    *)
                        echo "ignoring $region..."
                        ;;
                esac
        else
                :
        fi   
        # clean up region tmp file
        rm tmp-output.csv
done

# optional: resetting AWS region
export AWS_REGION="us-east-2"
