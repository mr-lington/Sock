#  create iam role and attach the policy document
resource "aws_iam_role" "ec2_role" {
  name               = "ec2_role"
  assume_role_policy = "${file("${path.root}/ec2-assume.json")}"
}

#  create iam role policy and attach the policy document
resource "aws_iam_role_policy_attachment" "ec2-role-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.ec2_role.name
}

# create iam instance profile 
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}