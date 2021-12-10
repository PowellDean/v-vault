module main
import client

fn main() {
    x := client.new_client()
    println(x)
    println(x.is_initialized())
}
