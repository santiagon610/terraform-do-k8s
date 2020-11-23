# Example Terraform Configuration

## Building a DigitalOcean Terraform Cluster

### Required Environment Variables

| Variable Name           | Description                                               | Example                                     |
| ----------------------- | --------------------------------------------------------- | ------------------------------------------- |
| `AWS_S3_ENDPOINT`       | Regional endpoint of DigitalOcean Spaces server, S3, etc. | `nyc3.digitaloceanspaces.com`               |
| `AWS_DEFAULT_REGION`    | Must be an AWS region, due to Terraform limitation        | `us-east-1`                                 |
| `AWS_ACCESS_KEY_ID`     | Access Key for Spaces, S3, etc.                           | `ABCD1234ABCD1234ABCD1234`                  |
| `AWS_SECRET_ACCESS_KEY` | Secret Key for Spaces, S3, etc.                           | `A1B/CDEFGHIJKLMN2O3Qr4St/uvwXYza5BCDEF67g` |

### Building the Infrastructure

Trigger from a pipeline, or run `local.sh`.
