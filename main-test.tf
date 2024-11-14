variable "my_variable" {
  type        = string
  description = "Test string variable"
  default     = "sunshine"
}

variable "max_value" {
  type        = number
  description = "This is the maximum value of sunshine points"
  default     = 100
  sensitive   = true
}

variable "min_value" {
  type        = number
  description = "This is the minimum value of sunshine points"
  default     = 5
  sensitive   = true
}

variable "available_types" {
  type    = list(string)
  default = ["Cozy", "Radiant", "Warm", "Playful", "Sparkling", "Lucky", "Joyful"]
}

resource "null_resource" "check_ip_and_variable" {
  triggers = {
    current_time = timestamp()
  }
  provisioner "local-exec" {
    command = "curl -s https://ifconfig.me/ip > ip.txt"
  }
}

resource "random_integer" "random_index" {
  min = 0
  max = length(var.available_types) - 1
}

resource "random_integer" "random_integer" {
  max = var.max_value
  min = var.min_value

  #  # Validation and error handling
  #  lifecycle {
  #    ignore_changes = [max, min]  # Ignore changes to max and min values
  #  }
}

data "local_file" "read_ip_and_variable" {
  depends_on = [null_resource.check_ip_and_variable]
  filename   = "./ip.txt"
}

output "scalr_ip_with_variables" {
  value = "Current IP for sunshine instance is: ${data.local_file.read_ip.content}\nSunshine type is ${element(var.available_types, random_integer.random_index.result)} ${var.my_variable}\nCurrent time is ${timestamp()}\nYou get ${random_integer.random_integer.result} sunshine points.\nHave a great day!"
}
