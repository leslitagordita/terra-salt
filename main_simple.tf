provider "linode" {
    token = "${var.token}"
}

locals {
    key ="${var.key}"
}

resource "linode_sshkey" "main_key" {
    label = "${var.key_label}"
    ssh_key = "${chomp(file(local.key))}"
}

resource "linode_instance" "linode_id" {
     image = "${var.image}"
     label = "${var.label}"
     region = "${var.region}"
     type = "${var.type}"
     authorized_keys = [ "${linode_sshkey.main_key.ssh_key}" ]
     root_pass = "${var.root_pass}"

     connection {
	 type     = "ssh"
	 user     = "root"
	 password = "${var.root_pass}"
     }

     provisioner "salt-masterless" {
	 bootstrap_args = "-K -D"
	 local_state_tree = "/srv/salt"
	 remote_state_tree = "/srv/salt"
	 local_pillar_roots = "/srv/pillar"
	 remote_pillar_roots = "/srv/pillar"
	 log_level = "debug"
     }
}
