//go:build integration

package cloud_storage

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"

	// import the blueprints test framework modules for testing and assertions
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

const exampleDir = "../../examples/minimal_test"

func TestCloudStorageModule(t *testing.T) {
	// Give a unique name to the Cloud Storage bucket we provision.
	nameOverride := "terratest"
	generation := random.Random(1, 999)
	// Create string version of generation and keep leading zeroes
	generationStr := fmt.Sprintf("%03d", generation)
	expectedName := fmt.Sprintf("gs://ent-gcs-%s-dev-%s/", nameOverride, generationStr)

	// variables to pass to our Terraform code
	testVars := map[string]interface{}{
		// Give a unique name to the Cloud Storage bucket we provision.
		"name_override": nameOverride,
		"generation":    generation,
	}

	// initialize Terraform test from the blueprint test framework
	cloudStorage := tft.NewTFBlueprintTest(t,
		tft.WithTFDir(exampleDir),
		tft.WithVars(testVars),
	)

	// define and write a custom verifier for this test case call the default verify for confirming no additional changes
	cloudStorage.DefineVerify(func(assert *assert.Assertions) {
		// perform default verification ensuring Terraform reports no additional changes on an applied blueprint
		cloudStorage.DefaultVerify(assert)

		// invoke the gcloud module in the Blueprints test framework to run a gcloud command that will output resource properties in a JSON format
		// the tft struct can be used to pull output variables of the TF module being invoked by this test and use the op object (a gjson struct)
		// to parse through the JSON results and assert the values of the resource against the constants defined above
		op := gcloud.Run(t, fmt.Sprintf("storage buckets describe %s", cloudStorage.GetStringOutput("cloud_storage_bucket_url")))
		// Verify bucket name
		assert.Equal(expectedName, op.Get("storage_url").String(), "Bucket name is "+expectedName)
		// Verify location
		assert.Equal("EUROPE-WEST1", op.Get("location").String(), "Bucket location is EUROPE-WEST1")
		// Verify that bucket has uniform bucket-level access
		assert.True(op.Get("uniform_bucket_level_access").Bool(), "Uniform bucket-level access is enabled")
	})
	// call the test function to execute the integration test
	cloudStorage.Test()
}
