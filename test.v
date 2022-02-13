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
    t1() or { println(err) }
}

fn t1() ?{
    x := vault.new_client('', vault.Authtype.token, 's.8biw95wvETlpOCzVw8MNqqV5')
    //x := vault.new_client('', vault.Authtype.username, 'dpowell', 'dpowell')
    //println(x)
    //println(x.is_initialized())
    //println(x.get_secret_v1('cubbyhole', 'foo')?)
    //y := x.get_secret_v1('cubbyhole', 'foo') or {
    //    println(err)
    //    vault.Secret_v1{}
    //}
    //println(y)
    //y.print_data()
    //println(y.key())
    //println(y.value())
    //z := x.get_secret_v2('secret', 'foo') or {
    //    println(err)
    //    vault.Secret_v2{}
    //}
    //println(z)
    //println(z.value())
    //println(x.is_sealed())
    //j := x.list_secrets('cubbyhole') or {
        //println(err)
        //vault.Key_list_response{}
    //}
    //println(j)

    //x.put_secret_v2('secret', 'blah', 'newkey', 'newvalue')
    //x.read_policy('default')
    //x.get_system_health() or { panic(err) }
    //g := x.token_lookup(x.token())?
    //println(g)
    x.list_secrets('cubbyhole')?
    //println(g)
}
