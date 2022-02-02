module vault

pub struct Secret_v1 {
    request_id string
    lease_id string
    renewable bool
    lease_duration int
    data map[string]string
}

pub fn (s Secret_v1) print_data() {
    println(s.data)
}

pub fn (s Secret_v1) key() string {
    return s.data.keys()[0]
}

pub fn (s Secret_v1) value() string {
    return s.data[s.key()]
}
