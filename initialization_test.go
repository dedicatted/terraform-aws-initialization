package test

import (
	"testing"
	"os/exec"
	"fmt"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestInitialization(t *testing.T) {
	// Set default values for the variables
	secretsManagerSecretName := "terraform-admin-secrets"

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../terraform-aws-initialization",
	}

	// Print out the values for debugging
	fmt.Printf("secretsManagerSecretName: %s\n", secretsManagerSecretName)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	t.Cleanup(func() {
		// Delete AWS Secrets Manager secret permanently
		cmd := exec.Command("aws", "secretsmanager", "delete-secret", "--secret-id", secretsManagerSecretName, "--force-delete-without-recovery")
		cmd.Run()
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)
}
