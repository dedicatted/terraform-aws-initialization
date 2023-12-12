package test

import (
	"fmt"
	"os/exec"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestInitialization(t *testing.T) {

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../terraform-aws-initialization",
	}

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Get the generated secret name from the Terraform output
	secretNameFromOutput := terraform.Output(t, terraformOptions, "generated_secret_name")

	// Print out the generated secret name for debugging
	fmt.Printf("secretNameFromOutput: %s\n", secretNameFromOutput)

	// Delete AWS Secrets Manager secret permanently
	cmd := exec.Command("aws", "secretsmanager", "delete-secret", "--secret-id", secretNameFromOutput, "--force-delete-without-recovery")
	cmd.Run()

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)
}
