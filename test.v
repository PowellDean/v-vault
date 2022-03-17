module main

import vault

fn main() {
	/*
	x := vault.new_client('', 's.lTcfCOKmGqgvx0XoPwLfA9eA')
    println(x)
    println(x.is_initialized())
    mut ans := x.unseal('fhfmZKz4FvPNFdgP/jgBUMz6YOAuutfcVEJnfXed2vPJ')?
    if ans.error_messages.len > 0 {
        println('ERROR!')
    } else {
        println('SUCCESS!')
    }

    if ans.is_sealed() {
        ans = x.unseal('USWyGq9a2UEYHAlrvPVqjir8UitgFaA3QP9R3rIMJ09B')?
    }
    println(ans.unseal_progress())

    if ans.is_sealed() {
        ans = x.unseal('W6oNBEfNWdnK/aiq0udIZ/rW9Dv6NVTVQt+E/SKKjToP')?
    }
    //println(ans.unseal_progress())

    sp := x.get_encryption_key_status()?
    println(sp.type_name())
    println(sp)
    match sp {
        vault.Key_status_response {
            println(sp.install_time)
        }
        vault.Error_response { panic(sp.errors[0]) }
    }
    println(x.list_policies()?)
    //x.read_policy('s.lTcfCOKmGqgvx0XoPwLfA9eA', 'my-policy')


    //ans = x.unseal('fhfmZKz4FvPNFdgP/jgBUMz6YOAuutfcVEJnfXed2vPJ')?
    //println(ans)
	*/
	// t1() or { println(err) }
	x := new_client('', Authtype.token, 's.GIXfyr6ifNEyiuSFenr8x549')
	// secret_v1(x)
	// secret_v2(x)
	system_health(x)
	// list_secrets_v1(x, 'secret')
	// list_policies(x)
	// destroy_v2_secret(x)
	// x.read_policy('default')
	// new_v1_secret(x)
	// new_v2_secret(x)
	// lookup_token(x, 's.GIXfyr6ifNEyiuSFenr8x549')
}

fn destroy_v2_secret(x .Client) {
	my_err := x.destroy_secret_v2_versions('cubbyhole', 'foo', [1, 2])
	if my_err.is_clear() {
		println('Success!')
	} else {
		println('Failure! $my_err')
	}
}

fn list_secrets_v1(x .Client, mountpoint string) {
	list, my_err := x.list_secrets(mountpoint)
	if my_err.is_clear() {
		println('Success! $list')
	} else {
		println('Failure! $my_err')
	}
}

fn list_policies(x .Client) {
	list, my_err := x.list_policies()
	if my_err.is_clear() {
		println('Success! $list')
	} else {
		println('Failure! $my_err')
	}
}

fn lookup_token(x .Client, tkn string) {
	list, my_err := x.token_lookup(tkn)
	if my_err.is_clear() {
		println('Success! $list')
	} else {
		println('Failure! $my_err')
	}
}

fn new_v1_secret(x .Client) {
	my_err := x.put_secret_v1('cubbyhole', 'blah', 'newkey', 'newvalue')
	if my_err.is_clear() {
		println('Success! $my_err')
	} else {
		println('Failure! $my_err')
	}
}

fn new_v2_secret(x .Client) {
	my_err := x.put_secret_v2('secret', 'blurb', 'monkey', 'sey')
	if my_err.is_clear() {
		println('Success! $my_err')
	} else {
		println('Failure! $my_err')
	}
}

fn secret_v1(x .Client) {
	s1, my_err := x.get_secret_v1('cubbyhole', 'foo')
	if my_err.errors.len == 0 {
		println(s1)
		println(s1.key())
		println(s1.value())
	} else {
		println(my_err)
	}
}

fn secret_v2(x .Client) {
	s2, my_err := x.get_secret_v2('secret', 'bar', 0)
	if my_err.is_clear() {
		println(s2)
		println(s2.key())
		println(s2.value())
	} else {
		println(my_err)
	}
}

fn system_health(x .Client) {
	health, my_err := x.get_system_health()

	if my_err.is_clear() {
		println('Success! $health')
	} else {
		println('Failure: $my_err')
	}
}

fn t1() ? {
	// x := vault.new_client('', vault.Authtype.token, 's.TGw3d9HJLiouaXAgZJUW6xQl')
	// x := vault.new_client('', vault.Authtype.username, 'dpowell', 'dpowell')
	// println(x)
	// println(x.is_initialized())
	// y.print_data()
	// z := x.get_secret_v2('secret', 'foo', 0) or {
	//    println(err)
	//    vault.Secret_v2{}
	//}
	// println(z)
	// println(z.value())
	// println(x.is_sealed())

	// x.put_secret_v2('secret', 'blah', 'newkey', 'newvalue')
	// x.read_policy('default')
	// g := x.token_lookup(x.token())?
	// println(g)
	// x.list_secrets('cubbyhole')?
	// println(g)
	// if x.delete_secret_v1('cubbyhole', 'foo') { println('ok') }
	// if x.delete_secret_v2('secret', 'baz') { println('ok') }
	// if x.delete_secret_v2_versions('secret', 'foo', [4, 5]) { println('ok') }
	// if x.undelete_secret_v2_versions('secret', 'foo', [2, 4, 5]) { println('ok') }
	// if x.undelete_secret_v2('secret', 'baz') { println('ok') }
	// if x.destroy_secret_v2_versions('secret', 'foo', [2]) { println('ok') }
}
