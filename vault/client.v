module vault

import json
import net.http
import net.urllib

const default_url = 'http://127.0.0.1:8200'

pub struct Client {
pub:
    scheme  string
    host    string
    port    string
    mut:
    token   string
}

pub fn (c Client) delete_secret_v1(mountpoint string, secret string) API_error {
    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    url := c.to_string() + '/v1/$mountpoint/$secret'

    mut req := http.Request{
        method: .delete,
        header: header,
        url: url
    }

    response := req.do() or {
        match err.msg {
            'dial_tcp failed' {
                return API_error{errors: ['Vault server not started']}
            }
            else { return API_error{errors: [err.msg]} }
        }
        return API_error{}
    }

    match response.status() {
        .no_content {
            return API_error{errors: []}
        }
        .forbidden {
            return API_error{errors: ['Not authorized']}
        }
        else {
            return API_error{errors: ['Unknown error in delete_secret_v1']}
        }
    }
}

pub fn (c Client) delete_secret_v2(
            mountpoint string,
            secret string) API_error {
    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    url := c.to_string() + '/v1/$mountpoint/data/$secret'

    mut req := http.Request{
        method: .delete,
        header: header,
        url: url
    }

    response := req.do() or {
        match err.msg {
            'dial_tcp failed' {
                return API_error{errors: ['Vault server not started']}
            }
            else { return API_error{errors: [err.msg]} }
        }
        return API_error{}
    }

    match response.status() {
        .no_content {
            return API_error{errors: []}
        }
        .forbidden {
            return API_error{errors: ['Not authorized']}
        }
        else {
            return API_error{errors: ['Unknown error in delete_secret_v1']}
        }
    }
}

pub fn (c Client) delete_secret_v2_versions(
            mountpoint string,
            secret string,
            versions []int) bool {
    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    data := '{"versions": $versions}'
    url := c.to_string() + '/v1/$mountpoint/delete/$secret'

    mut req := http.Request{
        method: .post,
        header: header,
        data: data,
        url: url
    }

    response := req.do() or {
        panic(err)
    }

    match response.status() {
        .no_content {
            return true
        }
        else {
            return false
        }
    }
}

pub fn (c Client) destroy_secret_v2_versions(
            mountpoint string,
            secret string,
            versions []int) bool {
    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    url := c.to_string() + '/v1/$mountpoint/destroy/$secret'
    data := '{"versions": $versions}'

    mut req := http.Request{
        method: .post,
        header: header,
        data: data,
        url: url
    }

    response := req.do() or {
        panic(err)
    }

    match response.status() {
        .no_content {
            return true
        }
        else {
            return false
        }
    }
}

pub fn (c Client) get_encryption_key_status() (Key_status, API_error) {
    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    url := c.to_string() + '/v1/sys/key-status'

    mut req := http.Request{
        method: .get,
        //header: header,
        url: url
    }

    mut res := Key_status{}
    mut failure := API_error{errors: []}

    response := req.do() or {
        match err.msg {
            'dial_tcp failed' {
                failure = API_error{errors: ['Vault server not started']}
            }
            else { failure = API_error{errors: [err.msg]} }
        }
        return res, failure
    }

    match response.status() {
        .ok {
            res = json.decode(Key_status, response.text) or {
                panic(err)
            }
        }
        else {
            failure = json.decode(API_error, response.text) or {
                panic(err)
            }
        }
    }

    return res, failure
}

// get_secret will return the value of the requested secret
pub fn (c Client) get_secret_v1(mountpoint string,
            key string) (Secret_v1, API_error) {
    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    mut url := c.to_string() + '/v1/$mountpoint/$key'

    mut req := http.Request{
        method: .get,
        header: header,
        url: url
    }

    mut res := Secret_v1{}
    mut failure := API_error{errors:[]}

    response := req.do() or {
        match err.msg {
            'dial_tcp failed' {
                failure = API_error{errors: ['Vault server not started']}
            }
            else { failure = API_error{errors: [err.msg]} }
        }
        return res, failure
    }

    match response.status() {
        .ok {
            res = json.decode(Secret_v1, response.text) or {
                panic(err)
            }
        }
        .not_found {
            //return(error('Secret $key not found'))
            failure = API_error{errors: ['Secret $key not found']}
        }
        else {
            //return error(response.text)
            failure = API_error{errors: [response.text]}
        }
    }

    return res, failure
}

pub fn (c Client) get_secret_v2(
            mountpoint string,
            key string,
            ver int) (Secret_v2, API_error) {
    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    mut url := c.to_string() + '/v1/$mountpoint/data/$key?version=$ver'

    mut req := http.Request{
        method: .get,
        header: header,
        url: url
    }

    response := req.do() or {
        panic(err)
    }

    mut res := Secret_v2{}
    mut failure := API_error{errors: []}
    match response.status() {
        .ok {
            res = json.decode(Secret_v2, response.text) or {
                panic(err)
            }
        }
        .not_found {
            failure = API_error{errors: ['Secret $key not found']}
        }
        else {
            failure = json.decode(API_error, response.text) or {
                panic(err)
            }
        }
    }

    return res, failure
}

pub fn (c Client) get_system_health() (System_health, API_error) {
    mut url := c.to_string() + '/v1/sys/health'

    mut req := http.Request{
        method: .get,
        url: url
    }

    response := req.do() or {
        panic(err)
    }

    mut res := System_health{}
    mut failure := API_error{errors:[]}
    match response.status() {
        .ok {
            res = json.decode(System_health, response.text) or {
                panic(err)
            }
        }
        .service_unavailable {
            res = json.decode(System_health, response.text) or {
                panic(err)
            }
        }
        .not_implemented {
            res = json.decode(System_health, response.text) or {
                panic(err)
            }
        }
        else {
            failure = API_error{errors: [response.text]}
        }
    }

    return res, failure
}

pub fn (c Client) list_secrets(mountpoint string) (Key_list, API_error) {
    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    url := c.to_string() + '/v1/$mountpoint?list=true'

    mut req := http.Request{
        method: .get,
        header: header,
        url: url
    }

    response := req.do() or {
        match err.msg {
            'dial_tcp failed' {
                panic('Vault Server Not Started')
            } else {
                panic(err)
            }
        }
        panic(err)
    }

    mut res := Key_list{}
    mut failure := API_error{errors: []}

    match response.status() {
        .ok {
            res = json.decode(Key_list, response.text) or {
                panic(err)
            }
        }
        .not_found {
            failure = API_error{errors: ['No value found at $mountpoint']}
        }
        else {
            failure = json.decode(API_error, response.text) or {
                panic(err)
            }
        }
    }

    return res, failure
}

pub fn (c Client) list_policies() (Policies, API_error) {
    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    url := c.to_string() + '/v1/sys/policy'

    mut req := http.Request{
        method: .get,
        header: header,
        url: url
    }

    mut res := Policies{}
    mut failure := API_error{errors: []}

    response := req.do() or {
        //panic(err)
        match err.msg {
            'dial_tcp failed' {
                failure = API_error{errors: ['Vault server not started']}
            }
            else { failure = API_error{errors: [err.msg]} }
        }
        return res, failure
    }

    match response.status() {
        .ok {
            res = json.decode(Policies, response.text) or {
                panic(err)
            }
        }
        else {
            failure = json.decode(API_error, response.text) or {
                panic('Cannot decode error response')
            }
        }
    }
    return res, failure
}

// new_client is the control function for creating a new connection to a Vault
// server. It accepts a vault address in the form 'http://<ipv4_addres:port>'
// (may also be blank -- see new_client_via_token for details),
// and an Authentication type (either .token or .username). If Authtype is
// .token, the next argument must be the Vault token. If Authtype is .username,
// both a username and password must be passed in, in that order.
pub fn new_client(address string, method Authtype, kwargs ...string) Client {
    match method {
        .token {
            match kwargs.len {
                0 { panic('Pass in a required token') }
                1 { return new_client_via_token(address, kwargs[0]) }
                else { panic('You passed too many arguments. Just pass 1 token') }
            }
            if kwargs.len < 1 {
                panic('pass in a required token')
            }
            return new_client_via_token(address, kwargs[0])
        }
        .username {
            match kwargs.len {
                0 { panic('Pass in both a username and password') }
                1 { panic('Need to pass a password, not just a username') }
                2 { return new_client_via_login(address, kwargs[0], kwargs[1]) }
                else { panic('You passed to many arguments. Not sure which is which') }
            }
        }
    }
}

// new_client_via_token creates a fully initialized Vault Client structure.
// It optionally accepts a string argument as the address of the Vault server.
// If no argument is given, look to see if $VAULT_ADDR has been set and
// initialize from that. If neither is specified, use the default Vault address
// http://127.0.0.1:8200
fn new_client_via_token(address string, token string) Client {
    mut scheme := ''
    mut host := ''
    mut port := ''
    mut raw_url := ''

    //if ($env('VAULT_TOKEN')) == '' { panic('Set VAULT_TOKEN!') }

    match address.len {
        0 { raw_url = $env('VAULT_ADDR') }
        1 { raw_url = address }
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

    client := Client{scheme: scheme, host: host, port: port, token: token}
    return client
}

fn new_client_via_login(address string, uname string, pswd string) Client {
    mut a_client := new_client_via_token(address, '')

    url := a_client.to_string() + '/v1/auth/userpass/login/$uname'
    data := '{"password": "$pswd"}'

    mut req := http.Request{
        method: .post,
        data: data,
        url: url
    }

    response := req.do() or {
        panic(err)
    }

    match response.status() {
        .ok {
            wanted_response := json.decode(User_login_response, response.text)
            or {
                panic(err)
            }
            a_client.token = wanted_response.auth.client_token
        } else {
            panic(response.text)
        }
    }
    return a_client
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

pub fn (c Client) is_sealed() bool {
    url := c.to_string() + '/v1/sys/seal-status'
    response := http.get(url) or {
        panic(err)
    }

    match response.status() {
        .ok {
            status := json.decode(Status_response, response.text) or {
                panic(err)
            }
            return status.sealed
        }
        else {
            panic(response.text)
        }
    }
}

pub fn (c Client) put_secret_v1(
            mountpoint string,
            key string,
            new_key string,
            new_value string) {

    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    url := c.to_string() + '/v1/$mountpoint/$key'
    data := '{"$new_key": "$new_value"}'

    mut req := http.Request{
        method: .post,
        header: header,
        data: data,
        url: url
    }

    response := req.do() or {
        panic(err)
    }

    match response.status() {
        .no_content {
            println('Put operation successful')
        }
        .bad_request {
            println('Bad Request!')
        }
        else {
            println(response.status())
        }
    }
}

pub fn (c Client) put_secret_v2(
            mountpoint string,
            key string,
            new_key string,
            new_value string) {

    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    url := c.to_string() + '/v1/$mountpoint/data/$key'
    data := '{"$new_key": "$new_value"}'

    mut req := http.Request{
        method: .post,
        header: header,
        data: data,
        url: url
    }

    response := req.do() or {
        panic(err)
    }

    match response.status() {
        .no_content {
            println('Put operation successful')
        }
        .bad_request {
            println('Bad Request!')
        }
        else {
            println(response.status())
        }
    }
}

pub fn (c Client) read_policy(name string) {
    mut wanted_response := Policies{}

    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    url := c.to_string() + '/v1/sys/policy/$name'

    mut req := http.Request{
        method: .get,
        header: header,
        url: url
    }

    response := req.do() or {
        match err.msg {
            'dial_tcp failed' {
                failure := API_error{errors: ['Vault server not started']}
            }
            else { failure := API_error{errors: [err.msg]} }
        }
        println(err.msg)
        return
    }

    match response.status() {
        .ok {
            wanted_response = json.decode(Policies, response.text)
            or {
                panic(err)
            }
        }
        else {
            unwanted_response := json.decode(API_error, response.text) or {
                panic('Cannot decode error response')
            }
            //wanted_response.error_messages = unwanted_response.errors
        }
    }
    //return wanted_response
}

pub fn (c Client) token() string {
    return c.token
}

pub fn (c Client) token_lookup(tkn string) ?Token_lookup_response {
    mut header := http.new_header()
    header.add_custom('X-Vault-Token', tkn) or {
        panic('Cannot create request header')
    }
    header.add_custom('accept', '*/*') or {
        panic('Cannot create request header')
    }

    url := c.to_string() + '/v1/auth/token/lookup'

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
            res := json.decode(Token_lookup_response, response.text) or {
                panic(err)
            }
            return res
        }
        .not_found {
            return(error('Nope'))
        }
        else {
            return error(response.text)
        }
    }
}

pub fn (c Client) to_string() string {
    return '$c.scheme://$c.host:$c.port'
}

pub fn (c Client) undelete_secret_v2_versions(
            mountpoint string,
            secret string,
            versions []int) bool {
    mut header := http.new_header()
    header.add_custom('X-Vault-Token', c.token) or {
        panic('Cannot create request header')
    }

    url := c.to_string() + '/v1/$mountpoint/undelete/$secret'
    data := '{"versions": $versions}'

    mut req := http.Request{
        method: .post,
        header: header,
        data: data,
        url: url
    }

    response := req.do() or {
        panic(err)
    }

    match response.status() {
        .no_content {
            return true
        }
        else {
            return false
        }
    }
}

pub fn (c Client) unseal(token string) ?Status_response {
    url := c.to_string() + '/v1/sys/unseal'
	body := '{"key": "$token"}'
    mut wanted_response := Status_response{}
    mut unwanted_response := API_error{errors: []}

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
            unwanted_response = json.decode(API_error, response.text) or {
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
