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
	 local_pillar_roots = "/srv/pillar"
         remote_state_tree = "/srv/salt"
         remote_pillar_roots = "/srv/pillar"
	 log_level = "debug"
	 on_failure = "continue"
	 custom_state = "state.apply test"
     }

	provisioner "remote-exec" {
		inline = [
		    "sudo apt-get install python-git -y",
		    "sed -i 's/#file_client: remote/file_client: local/' /etc/salt/minion",
		    "echo 'fileserver_backend:' >> /etc/salt/minion",
		    "echo '  - roots' >> /etc/salt/minion",
		    "echo '  - gitfs\n\n'>> /etc/salt/minion",
		    "echo 'gitfs_remotes:' >> /etc/salt/minion",
   		    "echo '  - https://github.com/leslitagordita/docker-formula.git\n\n' >> /etc/salt/minion",
		    "echo 'gitfs_provider: gitpython' >> /etc/salt/minion",
		    "systemctl restart salt-minion",
		    "salt-call --local state.apply"
		]
	    }
}
