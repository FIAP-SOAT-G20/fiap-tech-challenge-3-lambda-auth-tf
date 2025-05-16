// build the binary for the lambda function in a specific path
resource "null_resource" "function_binary" {
  provisioner "local-exec" {
    command  = "GOOS=linux GOARCH=amd64 CGO_ENABLED=0 GOFLAGS=-trimpath go build -mod=readonly -ldflags='-s -w' -o ${local.binary_path} ${local.src_path}"
  }
}

// zip the binary, aws we can use only zip files to AWS lambda
data "archive_file" "function_archive" {
  depends_on = [null_resource.function_binary]

  type = "zip"
  source_file = local.binary_path
  output_path = local.archive_path
}

