//go:build integration

package cloud_storage

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

const exampleDir = "../../examples/minimal_test"

func TestCloudStorageModule(t *testing.T) {
	nameOverride := "terratest"
	generation := random.Random(1, 999)
	enableAccessLogs := true

	testVars := map[string]interface{}{
		"name_override": nameOverride,
		"generation":    generation,
		"enable_access_logs": enableAccessLogs,
	}

	cloudStorage := tft.NewTFBlueprintTest(t,
		tft.WithTFDir(exampleDir),
		tft.WithVars(testVars),
	)

	cloudStorage.DefineVerify(func(assert *assert.Assertions) {
		generationStr := fmt.Sprintf("%03d", generation)
		expectedName := fmt.Sprintf("gs://ent-gcs-%s-dev-%s/", nameOverride, generationStr)
		expectedLogBucket := fmt.Sprintf("ent-gcs-%s-axlogs-dev-%s", nameOverride, generationStr)

		bucket := gcloud.Run(t, fmt.Sprintf("storage buckets describe %s", cloudStorage.GetStringOutput("cloud_storage_bucket_url")))
		assert.Equal(expectedName, bucket.Get("storage_url").String(), "Bucket name is "+expectedName)
		assert.Equal("EUROPE-WEST1", bucket.Get("location").String(), "Bucket location is EUROPE-WEST1")
		assert.True(bucket.Get("uniform_bucket_level_access").Bool(), "Uniform bucket-level access is enabled")
		assert.Equal(expectedLogBucket, bucket.Get("logging_config.logBucket").String(), "Log bucket is "+expectedLogBucket)
	})

	cloudStorage.Test()
}
