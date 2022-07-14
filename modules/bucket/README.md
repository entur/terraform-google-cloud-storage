# Cloud Storage Terraform Module #

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=4.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >=4.26.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [kubernetes_config_map.main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_init"></a> [init](#input\_init) | Entur init module output. https://github.com/entur/terraform-gcp-init. Used to determine application name, application project, labels, and resource names. | <pre>object({<br>    app = object({<br>      id         = string<br>      name       = string<br>      owner      = string<br>      project_id = string<br>    })<br>    environment   = string<br>    labels        = map(string)<br>    is_production = bool<br>  })</pre> | n/a | yes |
| <a name="input_disable_offsite_backup"></a> [disable\_offsite\_backup](#input\_disable\_offsite\_backup) | Disable offsite backup of the bucket. Offsite backup is only applied to production environments. | `bool` | `false` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to allow terraform to delete the bucket if it contains objects. | `bool` | `false` | no |
| <a name="input_generation"></a> [generation](#input\_generation) | Generation of the Cloud Storage bucket. Starts at 1, ends at 999. Will be padded with leading zeros. | `number` | `1` | no |
| <a name="input_lifecycle_rules_override"></a> [lifecycle\_rules\_override](#input\_lifecycle\_rules\_override) | Object lifecycle rules used to operate on objects based on conditions. | <pre>map(object({<br>    action = object({<br>      type = string<br>    })<br>    condition = map(string)<br>  }))</pre> | `null` | no |
| <a name="input_name_override"></a> [name\_override](#input\_name\_override) | A name override for Cloud Storage buckets resulting in a name on the form 'ent-gcs-<name\_override>-<env>-<generation>'. Using the name\_override will also add the name to the generated Kubernetes configmap. | `string` | `null` | no |
| <a name="input_storage_purpose"></a> [storage\_purpose](#input\_storage\_purpose) | The purpose of the Cloud Storage storage class. Determines storage class and geo redundancy. Supported values: 'standard'. | `string` | `"standard"` | no |
| <a name="input_versioned_object_retention_days"></a> [versioned\_object\_retention\_days](#input\_versioned\_object\_retention\_days) | The number of days to keep old versions of changed or deleted files. Only takes effect if lifecycle\_rule\_override is not used. NOTE: This parameter might have a large impact on cost depending bucket usage. | `number` | `2` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Set to true to enable object versioning. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_storage_bucket"></a> [cloud\_storage\_bucket](#output\_cloud\_storage\_bucket) | The cloud storage bucket output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket. |
| <a name="output_init"></a> [init](#output\_init) | The init module used in the module. |
<!-- END_TF_DOCS -->