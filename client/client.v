module client

import json
import net.http
import net.urllib

const default_url = 'http://127.0.0.1:8200'

pub struct Client {
pub:
    scheme  string
    host    string
    port    string
    pub mut: token   string
}

pub fn (c Client) get_encryption_key_status(tkn string) ?Key_status_response {
    mut wanted_response := Key_status_response{}

    mut header := http.new_header()
    header.add_custom('X-Vault-Token', tkn) or {
        panic('Cannot create request header')
    }
    
    url := c.to_string() + '/v1/sys/key-status'
    //url := c.to_string() + '/v1/sys/policy'

    mut req := http.Request{
        method: .get,
        header: header,
        url: url
    }
    
    response := req.do() or {
        panic(err)
    }

    match response.status() {
        .ok {
            wanted_response = json.decode(Key_status_response, response.text) or {
                //return(error(response.text))
                panic(err)
            }
        }
        else {
            unwanted_response := json.decode(Error_response, response.text) or {
                panic('Cannot decode error response')
            }
            wanted_response.error_messages = unwanted_response.errors
        }
    }
    return wanted_response
}

pub fn (c Client) list_policies(tkn string) ?Policies_response {
    mut wanted_response := Policies_response{}

    mut header := http.new_header()
    header.add_custom('X-Vault-Token', tkn) or {
        panic('Cannot create request header')
    }
    
    url := c.to_string() + '/v1/sys/policy'

    mut req := http.Request{
        method: .get,
        header: header,
        url: url
    }
    
    response := req.do() or {
        panic(err)
    }

    match response.status() {
        .ok {
            wanted_response = json.decode(Policies_response, response.text)
            or {
                panic(err)
            }
        }
        else {
            unwanted_response := json.decode(Error_response, response.text) or {
                panic('Cannot decode error response')
            }
            wanted_response.error_messages = unwanted_response.errors
        }
    }
    return wanted_response
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
    
    //if ($env('VAULT_TOKEN')) == '' { panic('Set VAULT_TOKEN!') }

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

pub fn (c Client) is_initialized() bool {
    url := c.to_string() + '/v1/sys/init'
    response := http.get(url) or {
        panic(err)
    }
    
    init_status := json.decode(Init_response, response.text) or {
        panic('Failed to decode response, error: $err')
    }
    return init_status.initialized
}

pub fn (s Status_response) is_sealed() bool {
    if s.sealed { return true }
    return false
}

pub fn (c Client) read_policy(token string, name string) {
    mut wanted_response := Policies_response{}

    mut header := http.new_header()
    header.add_custom('X-Vault-Token', token) or {
        panic('Cannot create request header')
    }
    
    url := c.to_string() + '/v1/sys/policy/$name'

    mut req := http.Request{
        method: .get,
        header: header,
        url: url
    }
    
    response := req.do() or {
        panic(err)
    }

    println(response.text)
    match response.status() {
        .ok {
            wanted_response = json.decode(Policies_response, response.text)
            or {
                panic(err)
            }
        }
        else {
            unwanted_response := json.decode(Error_response, response.text) or {
                panic('Cannot decode error response')
            }
            wanted_response.error_messages = unwanted_response.errors
        }
    }
    //return wanted_response
}

pub fn (c Client) to_string() string {
    return '$c.scheme://$c.host:$c.port'
}

pub fn (c Client) unseal(token string) ?Status_response {
    url := c.to_string() + '/v1/sys/unseal'
	body := '{"key": "$token"}'
    mut wanted_response := Status_response{}
    mut unwanted_response := Error_response{errors: []}

    response := http.post(url, body) or {
        return(err)
    }
    
    match response.status() {
        .ok {
            wanted_response = json.decode(Status_response, response.text) or {
                return(error(response.text))
            }
        }
        else {
            unwanted_response = json.decode(Error_response, response.text) or {
                return(error(response.text))
            }
            wanted_response.error_messages = unwanted_response.errors
        }
    }
    return wanted_response
}

pub fn (s Status_response) unseal_progress() int {
    return s.progress
}
