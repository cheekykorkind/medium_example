# https://www.terraform.io/docs/configuration/functions/templatefile.html
output "output_s3_policy_template" {
  value = templatefile("${path.root}/s3_policy_template.tpl", {
    my-value = "goodddddddddddddddddddddddddd"
  })
}


# https://www.terraform.io/docs/configuration/functions/file.html
# https://www.terraform.io/docs/providers/template/d/file.html
data "template_file" "ecs_task_definition" {
  template = "${file("${path.root}/ecs_task_definition.json.tpl")}"

  vars = {
    my-farmily-name = "yesssssssssssssssssssssssssssssssssssss"
  }
}

output "output_template-two" {
  value = data.template_file.ecs_task_definition.rendered
}
