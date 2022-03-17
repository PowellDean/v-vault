module vault

pub struct Secret_v1 {
pub:
	request_id     string
	lease_id       string
	renewable      bool
	lease_duration int
	data           map[string]string
}

type Secret_v1_response = API_error | Secret_v1

pub fn (s Secret_v1) print_data() {
	println(s.data)
}

pub fn (s Secret_v1) has_data() bool {
	return s.data.len > 0
}

pub fn (s Secret_v1) key() string {
	return s.data.keys()[0]
}

pub fn (s Secret_v1) value() string {
	return s.data[s.key()]
}
