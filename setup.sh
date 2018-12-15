# Create bin path
echo "${bold}Creating local ~/bin folder...${normal}"
cd $HOME
mkdir bin
PATH=$PATH:$HOME/bin/

# Install terraform
echo "${bold}Installing terraform...${normal}"
cd $HOME
mkdir terraform11
cd terraform11
sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform_0.11.7_linux_amd64.zip
mv terraform $HOME/bin/.
cd $HOME
rm -rf terraform11
echo "********************************************************************************"
#  Don't need from here to 38 in cloudshell, can just using native provider
# Create Terraform service account
echo "${bold}Creating GCP service account for Terraform...${normal}"
gcloud iam service-accounts create terraform-sa --display-name terraform-sa #need to add -sa to sa name or else command hangs. Reserved word?
export TERRAFORM_SA_EMAIL=$(gcloud iam service-accounts list --filter="displayName:terraform-sa"  --format='value(email)')
echo "********************************************************************************"
# Create project
export PROJECT=$(gcloud info --format='value(config.project)')
# Give Terraform SA  roles/owner IAM permissions
echo "${bold}Creating GCP IAM role bindings for terraform and spinnaker service accounts...${normal}"
gcloud projects add-iam-policy-binding $PROJECT --role roles/owner --member serviceAccount:$TERRAFORM_SA_EMAIL
gcloud projects add-iam-policy-binding $PROJECT --role roles/owner --member user:$(gcloud config list account --format "value(core.account)")
echo "********************************************************************************"

# Get creds for Terraform SA
echo "${bold}Creating credentials for terraform service account...${normal}"
gcloud iam service-accounts keys create $HOME/terraforming_gke/modules/networking/credentials.json --iam-account $TERRAFORM_SA_EMAIL
# sed -i -e s/PROJECTID/$PROJECT/g $HOME/advanced-kubernetes-workshop/terraform/main.tf
echo "********************************************************************************"
