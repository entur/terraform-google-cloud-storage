//go:build integration

package cloud_storage_integration_test

import (
	"context"
	"fmt"
	"testing"

	"cloud.google.com/go/storage"
	"github.com/gruntwork-io/terratest/modules/gcp"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformCloudStorageIntegration(t *testing.T) {

	// Give a unique name to the Cloud Storage bucket we provision.
	nameOverride := "terratest"
	generation := random.Random(1, 999)
	// Create string version of generation and keep leading zeroes
	generationStr := fmt.Sprintf("%03d", generation)
	expectedName := fmt.Sprintf("ent-gcs-%s-dev-%s", nameOverride, generationStr)

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "fixtures/bucket",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name_override": nameOverride,
			"generation":    generation,
		},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
		Logger:  logger.Discard,
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of an output variable.
	output := terraform.OutputMap(t, terraformOptions, "cloud_storage_bucket")
	bucketName := output["name"]

	// Verify that bucket name is as expected
	assert.Equal(t, expectedName, bucketName)

	// Verify that storage bucket exists
	gcp.AssertStorageBucketExists(t, bucketName)

	// Get metadata from Cloud Storage bucket
	ctx := context.Background()
	client, err := storage.NewClient(ctx)
	if err != nil {
		t.Fail()
		fmt.Println("ERROR:: ", err.Error())
	}

	attrs, err := client.Bucket(bucketName).Attrs(ctx)
	if err != nil {
		t.Fail()
		fmt.Println("ERROR:: ", err.Error())
	} else {
		// Verify that bucket has uniform bucket-level access
		assert.Equal(t, true, attrs.UniformBucketLevelAccess.Enabled, "Uniform bucket-level access is not enabled")
		// Verify location
		assert.Equal(t, "EUROPE-WEST1", attrs.Location, "Location is not correct")
	}
}
