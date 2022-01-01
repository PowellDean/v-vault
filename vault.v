module main
import client

fn main() {
    x := client.new_client()
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
    
    //println(x.get_encryption_key_status('s.lTcfCOKmGqgvx0XoPwLfA9eA')?)
    //println(x.list_policies('s.lTcfCOKmGqgvx0XoPwLfA9eA')?)
    x.read_policy('s.lTcfCOKmGqgvx0XoPwLfA9eA', 'my-policy')
    
    
    //ans = x.unseal('fhfmZKz4FvPNFdgP/jgBUMz6YOAuutfcVEJnfXed2vPJ')?
    //println(ans)
}
