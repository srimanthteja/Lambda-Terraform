resource "aws_instance" "my_instance" {
  ami           = "ami-04e5276ebb8451442"
  instance_type = "t2.micro"

  tags = {
    Name = "my-instance-stale-volume"
  }
}

resource "aws_ebs_snapshot" "my_instance_vol_snapshot" {
  volume_id = "vol-0fa1a342b45827be6"

  tags = {
    Name = "stale-instance-vol-snapshot"
  }
}