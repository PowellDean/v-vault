module vault

struct Error_response {
	pub: errors []string [required]
}

struct Health_response {
    initialized bool
    sealed bool
    standby bool
    performance_standby bool
    replication_performance_mode string
    replication_dr_mode string
    server_time_utc int
    version string
    cluster_name string
    cluster_id string
}

struct Init_response {
    initialized bool [required]
}

struct Key_list {
    keys []string
}

pub struct Key_list_response {
    request_id string
    lease_id   string
    renewable  bool
    data       Key_list
}

type Key_list_or_error = Key_list_response | Error_response

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

struct User_auth {
    client_token string
}

struct User_login_response {
    request_id string
    lease_id string
    renewable bool
    lease_duration int
    auth User_auth
}
