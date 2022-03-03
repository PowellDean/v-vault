module vault

pub struct API_error {
    pub mut:
	errors []string
}

struct System_health {
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

struct Key_list_data {
    keys []string
}

pub struct Key_list {
    request_id string
    lease_id   string
    renewable  bool
    data       Key_list_data
}

struct Key_status {
    pub:
    term int
    install_time string
    encryptions int
    lease_id string
    renewable bool
}

struct Mountpoints {
    mountpoint map[string]string
}

struct Policy {
    name     string
    rules    string
}

struct Policy_list {
    policies []string
    keys []string
    lease_id string
    renewable bool
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

struct Token_lookup_data {
    accessor string
    creation_time int
    creation_ttl int
    display_name string
    entity_id string
    explicit_max_ttl int
    id string
    num_uses int
    orphan bool
    path string
    policies []string
    ttl int
    @type string
}

struct Token_lookup_response {
    request_id string
    lease_id string
    renewable bool
    lease_duration int
    data Token_lookup_data
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

pub fn (e API_error) is_clear() bool {
    return e.errors.len == 0
}
