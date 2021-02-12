class profile::ssh_server {
	package {'openssh-server':
		ensure => present,
	}
	service { 'sshd':
		ensure => 'running',
		enable => 'true',
	}
	ssh_authorized_key { 'root@master.puppet.vm':
		ensure => present,
		user   => 'root',
		type   => 'ssh-rsa',
		key    => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHckT7CPpUfDchIfqKp4GcXWwU5EBMoahrWU2Tz1jW1PeUL5LuhvOg+nEdZARzSfWI2hgkTh98R1+SN9QA7UVsuezmJwNJk3I6rbiBE+Qq/PKLIUuEDbqWsspKTWVVUoWdlvUSXtmBR9XXqTJDwUhfo7SCV/DfdM8qgM57jarobQd0qmdAESc4u7drcSg7Hi63dSdIEOSmVsKFIsDqsnC/qtv2fm6MYaMXQyANgvgnVNWhtjSF1NJNLQ5ryFNHr41aDcCM8AwU29NIs7cs29t1/TWQSUqsn2Gw3mWubf2C5FZPPjLtNArAbgYXGjtVya6xxRK75ZOlNWkair24o289 root@master.puppet.vm',
	}
}
