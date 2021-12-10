module client

import json
import net.http
import net.urllib

const default_url = 'http://127.0.0.1:8200'

struct Init_status {
    initialized bool [required]
}
    

pub struct Client {
pub:
    scheme  string
    host    string
    port    string
}

// new_client creates a fully initialized Vault Client structure. It optionally
// accepts a string argument as the address of the Vault server. If no argument
// is given, look to see if $VAULT_ADDR has been set and initialize from that.
// If neither is specified, use the default Vault address http://127.0.0.1:8200
pub fn new_client(address ...string) Client {
    mut scheme := ''
    mut host := ''
    mut port := ''
    mut raw_url := ''
    
    if ($env('VAULT_TOKEN')) == '' { panic('Set VAULT_TOKEN!') }

    match address.len {
        0 { raw_url = $env('VAULT_ADDR') }
        1 { raw_url = address[0] }
        else { panic('Expected just 1 address argument, found more') }
    }
    
    if raw_url == '' { raw_url = default_url }
    
    url := urllib.parse(raw_url) or {
        panic('cannot parse $default_url')
    }
    
    match url.scheme {
        'http' { scheme = url.scheme }
        'https' { scheme = url.scheme }
        else { panic('need to state http or https') }
    }
    
    host_elements := url.host.split(':')
    match true {
        host_elements.len == 1 { panic('network port not specified') }
        host_elements.len == 2 {
            host = host_elements[0]
            port = host_elements[1] }
        else { panic('Error parsing given Vault address') }
    }
    
    client := Client{scheme: scheme, host: host, port: port}
    return client
}

pub fn (c Client) to_string() string {
    return '$c.scheme://$c.host:$c.port'
}

pub fn (c Client) is_initialized() bool {
    url := c.to_string() + '/v1/sys/init'
    response := http.get(url) or {
        panic(err)
    }
    
    init_status := json.decode(Init_status, response.text) or {
        panic('Failed to decode response, error: $err')
    }
    return init_status.initialized
}
