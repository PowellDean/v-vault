module client

struct Error_response {
	pub: errors []string [required]
}

struct Init_response {
    initialized bool [required]
}

struct Key_status_response {
    pub:
    term int
    install_time string
    encryptions int
    lease_id string
    renewable bool
}

type Key_status_or_error = Key_status_response | Error_response

struct Policies_response {
    policies []string
    keys []string
    lease_id string
    renewable bool
    pub mut:
    error_messages []string [skip]
}

struct Secret {
    request_id string
    lease_id string
    renewable bool
    lease_duration int
    data map[string]string
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
