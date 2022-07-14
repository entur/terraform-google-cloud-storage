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
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to allow Terraform to delete the bucket even if it contains objects. | `bool` | `false` | no |
| <a name="input_generation"></a> [generation](#input\_generation) | The generation (aka serial no.) of the instance. Starts at 1, ends at 999. Will be padded with leading zeros. | `number` | `1` | no |
| <a name="input_lifecycle_rules_override"></a> [lifecycle\_rules\_override](#input\_lifecycle\_rules\_override) | The bucket's Lifecycle Rules configuration (advanced). Will override the 'versioned\_object\_retention\_days' setting. | <pre>map(object({<br>    action = object({<br>      type = string<br>    })<br>    condition = map(string)<br>  }))</pre> | `null` | no |
| <a name="input_name_override"></a> [name\_override](#input\_name\_override) | Set to override the default bucket name. Follows contentions; setting it to 'foo' in dev will result in the bucket being named 'ent-gcs-foo-dev-001' (<prefix>-<var.name\_override>-<env>-<generation>). Is also applied to the name of the Kubernetes config map. | `string` | `null` | no |
| <a name="input_storage_purpose"></a> [storage\_purpose](#input\_storage\_purpose) | The purpose of the storage bucket. Determines storage class, retention and geo-redundancy. Supported values: 'standard'. | `string` | `"standard"` | no |
| <a name="input_versioned_object_retention_days"></a> [versioned\_object\_retention\_days](#input\_versioned\_object\_retention\_days) | The number of days to keep old versions of changed or deleted files. Only takes effect if 'versioning' is enabled (default), and 'lifecycle\_rule\_override' is not used. NOTE: This parameter might have a large impact on cost depending on bucket use. | `number` | `2` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Whether to enable object versioning. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_storage_bucket"></a> [cloud\_storage\_bucket](#output\_cloud\_storage\_bucket) | The cloud storage bucket output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket. |
| <a name="output_init"></a> [init](#output\_init) | The init module used in the module. |
<!-- END_TF_DOCS -->