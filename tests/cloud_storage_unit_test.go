//go:build unit

package cloud_storage_unit_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformCloudStorageUnit(t *testing.T) {
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "fixtures/bucket",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
		Logger:  logger.Discard,

		PlanFilePath: "plan.out",
	})

	plan := terraform.InitAndPlanAndShowWithStruct(t, terraformOptions)

	// Make sure the right address vas registered
	terraform.RequireResourceChangesMapKeyExists(t, plan, "module.cloud-storage.google_storage_bucket.main")

	// Check values from plan output
	cloudStorageChanges := plan.ResourcePlannedValuesMap["module.cloud-storage.google_storage_bucket.main"]
	// Location
	assert.Equal(t, cloudStorageChanges.AttributeValues["location"], "EUROPE-WEST1", "Incorrect location")
	// force destroy defalts to false
	assert.Equal(t, cloudStorageChanges.AttributeValues["force_destroy"], false, "Force destroy should be false")
	// storage class is standard
	assert.Equal(t, cloudStorageChanges.AttributeValues["storage_class"], "STANDARD", "Storage class should be type STANDARD")
	// label for disable_offsite_backup should not exist
	labels := cloudStorageChanges.AttributeValues["labels"]
	disable_offsite_backup := labels.(map[string]interface{})["disable_offsite_backup"]
	assert.Emptyf(t, disable_offsite_backup, "Fount label disable_offsite_backup. This should only exist when set in a production environment.")
	// object versioning is active
	versioningEnabled := cloudStorageChanges.AttributeValues["versioning"].([]interface{})[0].(map[string]interface{})["enabled"]
	assert.Equal(t, versioningEnabled, true, "Versioning is not enabled")
}
