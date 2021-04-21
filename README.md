# bulk-edit-ec2

**Author:** Phil Salem
Date: 04/20/2021

**Function:**
Custom script that bulk edits EC2 instance tags using aws-tagger

**Reference Links:**
**AWS-tagger:** https://github.com/washingtonpost/aws-tagger

**AWS CLI:** https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html

**Usage:**


1. Ensure aws-tagger is installed. Reference the link above on how to download and install on your Linux system.
2. The aws-tagger will default to the region that is configured for your AWS profile. (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
3. Edit the filters on line 10 of the script. This will determine which EC2 instances will be tagged when the aws-tagger command is called in the script. 
4. When the script is executed, the user will be prompted to enter in the tag key and value that will be added as tags to EC2 instances.
5. Follow the prompts when the script is executed. 
