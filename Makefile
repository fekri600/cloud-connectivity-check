.ONESHELL:
.SHELLFLAGS = -e -o pipefail -c

apply-and-test:
	terraform init && terraform apply -auto-approve
	@echo "Waiting 20 seconds for logs to be delivered..."
	sleep 20

	@echo "Fetching CloudWatch logs for connectivity tests..."
	@mkdir -p outputs
	
	LOG_GROUP="/aws/ssm/connectivity-staging"; \
	INSTANCE_TAG="i2506connect-staging-ec2"; \
	INSTANCE_ID=$$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$$INSTANCE_TAG" --query "Reservations[0].Instances[0].InstanceId" --output text); \
	LOG_STREAM=$$(aws logs describe-log-streams --log-group-name $$LOG_GROUP --order-by LastEventTime --descending --limit 1 --query "logStreams[0].logStreamName" --output text 2>/dev/null); \
	if [ "$$LOG_STREAM" = "None" ] || [ -z "$$LOG_STREAM" ]; then \
		echo "⚠️  Logs not found for staging. Skipping."; \
	else \
		echo "📥 Downloading logs for staging..."; \
		aws logs get-log-events \
			--log-group-name "$$LOG_GROUP" \
			--log-stream-name "$$LOG_STREAM" \
			--limit 50 \
			--output text > outputs/connectivity_test_staging.txt; \
		echo "✅ Logs saved to outputs/connectivity_test_staging.txt"; \
	fi

delete:
	terraform destroy -auto-approve
	@echo "✅ Delete completed."
