# Oracle Cloud Infrastructure (OCI) Free Tier Compute Setup

This Terraform configuration sets up a compute instance in Oracle Cloud Infrastructure's free tier with a 100GB block volume for persistent storage.

## Prerequisites

1. [Oracle Cloud Infrastructure](https://www.oracle.com/cloud/) Account
2. [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0+)
3. OpenSSL for key generation

## Setup Steps

### 1. Generate API Keys

Create a directory for your keys and generate the API key pair:

```bash
# Create keys directory
mkdir -p keys

# Generate private key
openssl genrsa -out keys/oci_api_key.pem 2048

# Set correct permissions
chmod 600 keys/oci_api_key.pem

# Generate public key
openssl rsa -pubout -in keys/oci_api_key.pem -out keys/oci_api_key_public.pem

# Get the key's fingerprint (you'll need this later)
openssl rsa -pubout -outform DER -in keys/oci_api_key.pem | openssl md5 -c
```

### 2. Configure OCI

1. Log in to the [OCI Console](https://cloud.oracle.com)
2. Click on your Profile icon (top right) → User Settings
3. Under "Resources", click "API Keys"
4. Click "Add API Key"
5. Choose "Paste Public Key" and paste the contents of `keys/oci_api_key_public.pem`
6. Click "Add"

### 3. Gather Required Information

You'll need the following information from OCI:

1. Tenancy OCID:
   - Menu → Identity & Security → Tenancy Details
   - Copy the OCID under "Tenancy Information"

2. User OCID:
   - Profile icon → User Settings
   - Copy the OCID under "User Information"

3. Region:
   - This configuration uses `ca-toronto-1` (Toronto)
   - Change in terraform.tfvars if you prefer a different region

4. SSH Public Key:
   - Your SSH public key for instance access (typically `~/.ssh/id_rsa.pub`)

### 4. Configure Terraform Variables

1. Copy the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edit `terraform.tfvars` with your information:
```hcl
tenancy_ocid     = "ocid1.tenancy.oc1..example"    # Your tenancy OCID
user_ocid        = "ocid1.user.oc1..example"       # Your user OCID
fingerprint      = "xx:xx:xx:xx:xx:xx"            # Your API key fingerprint
private_key_path = "keys/oci_api_key.pem"         # Path to your private key
region           = "ca-toronto-1"                 # Toronto region
ssh_public_key   = "ssh-rsa AAAA..."             # Your SSH public key
```

### 5. Initialize and Apply Terraform

```bash
# Initialize Terraform
terraform init

# Review the planned changes
terraform plan

# Apply the configuration
terraform apply
```

## What Gets Created

This Terraform configuration creates:

1. Virtual Cloud Network (VCN)
2. Private subnet
3. Security list with basic rules
4. Route table
5. Oracle Linux 9 compute instance using VM.Standard.A1.Flex shape (Free Tier eligible)
   - 4 OCPUs
   - 24GB RAM
6. 100GB block volume for persistent storage

## Post-Creation Steps

After the instance is created:

1. The block volume will be attached but needs to be formatted and mounted:
```bash
# Format the volume (typically /dev/sdb)
sudo mkfs.xfs /dev/sdb

# Create mount point
sudo mkdir /data

# Mount the volume
sudo mount /dev/sdb /data

# Add to fstab for persistent mounting
echo '/dev/sdb /data xfs defaults 0 0' | sudo tee -a /etc/fstab
```

## Accessing Your Instance

Since the instance is created in a private subnet without a public IP, access is provided through Oracle Cloud's Bastion Service. The free tier includes:
- 5 bastion sessions per month
- Maximum session duration of 3 hours
- Managed by Oracle (no maintenance required)

### Using the Bastion Service

1. After applying the Terraform configuration, go to the OCI Console:
   - Navigate to Identity & Security → Bastion
   - Click on your bastion (named "private-subnet-bastion")
   - Click "Create Session"

2. Configure the session:
   - Choose "SSH Port Forwarding Session"
   - Enter your instance's private IP (available in Terraform outputs)
   - Enter port 22
   - Choose session TTL (up to 3 hours)
   - Click "Create Session"

3. Use the provided SSH command:
   - The console will provide a command that looks like:
     ```bash
     ssh -i <private_key_path> -o ProxyCommand='ssh -i <private_key_path> -W %h:%p ocid1.bastionsession.oc1...' <username>@<private_ip>
     ```
   - Replace `<private_key_path>` with your SSH private key path
   - The username for Oracle Linux is `opc`

### Session Limitations
- Free tier includes 5 sessions per month
- Each session can last up to 3 hours
- Additional sessions cost $0.01 per session per hour
- After session expiry, you'll need to create a new session

## Cleanup

To destroy all created resources:

```bash
terraform destroy
```

## Security Notes

- The instance is created in a private subnet without a public IP
- Sensitive values should be stored in `terraform.tfvars` (not in version control)
- The API private key should be kept secure and not shared
- The SSH private key should be kept secure and not shared

## Files Description

- `main.tf`: Compute instance and block volume configuration
- `network.tf`: VCN and networking components
- `provider.tf`: OCI provider configuration
- `variables.tf`: Input variable definitions
- `outputs.tf`: Output value definitions
- `terraform.tfvars`: Your personal configuration values (not in version control)
- `.gitignore`: Prevents sensitive files from being committed