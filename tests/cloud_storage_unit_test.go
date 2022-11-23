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
	})

	output := terraform.InitAndPlan(t, terraformOptions)

	assert.Contains(t, output, "3 to add, 0 to change, 0 to destroy", "Plan OK and should attempt to create 3 resources")
}
