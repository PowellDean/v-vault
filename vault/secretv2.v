module vault

pub struct Secret_v2_metadata {
    created_time string
    deletion_time string
    destroyed bool
    version int
}

struct Secret_v2_data {
    data map[string]string
    metadata Secret_v2_metadata
}

pub struct Secret_v2 {
    request_id string
    lease_id string
    renewable bool
    lease_duration int
    data Secret_v2_data
}

pub fn (s Secret_v2) print_data() {
    println(s.data)
}

pub fn (s Secret_v2) key() string {
    return s.data.data.keys()[0]
}

pub fn (s Secret_v2) value() string {
    return s.data.data[s.key()]
}
