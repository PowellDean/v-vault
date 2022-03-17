module main

import client

fn test_new_client_no_args() {
	assert client.new_client().to_string() == 'http://127.0.0.1:8200'
}
