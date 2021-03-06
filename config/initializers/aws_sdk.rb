# aws_secret_file: path to *.yml file with AWS_ACCESS_KEY_ID and AWS_SECRET_KEY_ID if exist
aws_secret_file = Rails.configuration.service['aws_secret_file']

if aws_secret_file.present?
  creds = YAML.load(File.read(aws_secret_file))
  aws_creds = Aws::Credentials.new(
    creds['aws_access_key'],
    creds['aws_secret_key']
  )
  Aws.config.update(region: creds['aws_region'], credentials: aws_creds)
end
