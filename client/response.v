module client

struct Error_response {
	errors []string [required]
}

struct Init_response {
    initialized bool [required]
}

struct Key_status_response {
    term int
    install_time string
    encryptions int
    lease_id string
    renewable bool
    pub mut:
    error_messages []string [skip]
}

struct Policies_response {
    policies []string
    keys []string
    lease_id string
    renewable bool
    pub mut:
    error_messages []string [skip]
}

struct Status_response {
	@type string
	initialized string
	sealed bool
	t int
	n int
	progress int
	nonce string
	version string
	migration bool
	cluster_name string
	cluster_id string
	recovery_seal bool
	storage_type string
    pub mut:
    error_messages []string [skip]
}
